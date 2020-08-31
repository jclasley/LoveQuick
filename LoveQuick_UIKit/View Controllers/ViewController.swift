//
//  ViewController.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 4/16/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import UIKit
import FirebaseAuth
import RxSwift
import RxCocoa


var user: User?

@IBDesignable
class ViewController: UIViewController {
	@IBOutlet weak var navBarHamburger: UIBarButtonItem!
	@IBOutlet weak var contView: UIView!
	@IBOutlet weak var nicetyLabel: UILabel!
	@IBOutlet weak var heart: UIImageView!
	
	@IBOutlet weak var menuButton: UIButton!
	@IBOutlet weak var loveListButton: UIButton!
	@IBOutlet weak var greeting: UILabel!
	let heartView = UIView()
	//auth vars
	public var user: User?
	var handle: AuthStateDidChangeListenerHandle?
	
	//RX
	var greetingRX: Disposable!
	
	//db
	var dataFetched = false
	
	@IBOutlet weak var heartImage: UIImageView!
	@IBOutlet weak var transitionView: UIView!
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		//MARK: Auth redirect
		//redirect
		if (Globals.user == nil) {
			showLoginScreen()
		} else {
			self.user = Globals.user
		}

		//MARK: Greeting
		self.greeting.text = "Hi, \(Globals.user?.displayName ?? "friend")!"
		self.greetingRX = self.user?.publishedDisplayName.bind(to: self.greeting.rx.text)
				
		//MARK: Heart
		createTapGesutre(for: heartImage)
		
		//MARK: Nicety
		let nicety = Nicety()
		
		nicetyLabel.text = nicety.niceStatement
		nicetyLabel.textAlignment = .center
		nicetyLabel.numberOfLines = 2
		nicetyLabel.lineBreakMode = .byWordWrapping
		
		//MARK: Buttons
		menuButton.frame.size = CGSize(width: 40, height: 40)
			
		//MARK: Hero
		self.transitionView.heroModifiers = [.duration((1))]
		self.transitionView.isHidden = true
	}
	
	//MARK: animation
	func createTapGesutre(for view: UIView) {
		let tap = UITapGestureRecognizer(target: self, action: #selector(doAnimation(recognizer:)))
		view.addGestureRecognizer(tap)
	}
	//TODO: Add in drop down "sent" after hearts fall
	
	@objc func doAnimation(recognizer: UITapGestureRecognizer) {
		let tappedView = recognizer.view!
		if Globals.user!.isAbleToSendLove {
			CustomAnimations.fallingHeartsAnimation(view: tappedView)
			Globals.user!.isAbleToSendLove = false
			
		// Create local notification
			// 1. content
			let sendAgainContent = UNMutableNotificationContent()
			sendAgainContent.title = "Ready"
			sendAgainContent.body = "Put on your tap shoes, cause you're free to love again!"
			// 2. trigger
			let sendAgainTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(CustomAnimations.totalTime), repeats: false)
			// 3. request
			let sendAgainRequest = UNNotificationRequest(identifier: "sendAgain", content: sendAgainContent, trigger: sendAgainTrigger)
			UNUserNotificationCenter.current().add(sendAgainRequest, withCompletionHandler: { error in
				if let e = error {
					print(e)
				}
			})
		}
	}
	
	@IBAction func animationTwo(_ sender: Any) {
		CustomAnimations.growWiggleLeave(view: heartImage)
		
	}
	
	@IBAction func animationOne(_ sender: Any) {
		CustomAnimations.fallingHeartsAnimation(view: heartImage)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		//MARK: NavigationBar
		self.navigationController?.navigationBar.isHidden = true
		self.navigationController?.modalPresentationStyle = .fullScreen
		self.view.setNeedsDisplay()
	}

	@IBAction func returnToView(_ sender: Any) {
		}
	
	//MARK: Menu
	@IBAction func openMenu(_ sender: Any) {
		if let profDetail = self.storyboard?.instantiateViewController(withIdentifier: "profileDetail") {
			profDetail.hero.isEnabled = true
			self.navigationController?.heroNavigationAnimationType = .cover(direction: .right)
			self.navigationController?.pushViewController(profDetail, animated: true)
		}
	}
	
	@IBAction func showLoveList(_ sender: Any) {
		let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
		
		effectView.frame = self.view.frame
		self.view.addSubview(effectView)
		//recognizer
		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(removeViewFromParent(_:)))
		effectView.addGestureRecognizer(tapRecognizer)
		//lovelist
		if let lovelist = self.storyboard?.instantiateViewController(withIdentifier: "loveList") as? LoveListTableTableViewController {
			effectView.contentView.addSubview(lovelist.tableView)
			self.addChild(lovelist)
			lovelist.didMove(toParent: self)
			lovelist.tableView.center = effectView.center			
			
			//lovelist formatting
			lovelist.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
			lovelist.tableView.layer.cornerRadius = 16
		}
	}

	@objc func removeViewFromParent(_ recognizer: UITapGestureRecognizer) {
			if let table = self.children.last as? UITableViewController {
				guard !table.tableView.frame.contains(recognizer.location(in: self.view)) else { //guard tap is not inside table
					return //if is, return
				}
				//if not..
				table.willMove(toParent: nil)
				table.removeFromParent()
				table.tableView.removeFromSuperview()
				
				guard self.view.subviews.last is UIVisualEffectView else {
					return
				}
				self.view.subviews.last?.removeFromSuperview()
			}
	}
	
	//MARK: segue
	func showLoginScreen() {
		let loginVC = storyboard?.instantiateViewController(withIdentifier: "loginView")
		loginVC!.modalPresentationStyle = .fullScreen
		DispatchQueue.main.async {
			self.present(loginVC!, animated: false, completion: nil)
		}
	}
	
	
//
//	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		switch segue.identifier {
//			case
//		}
//			}
//
	
}

extension UIView {
	func setAnchorPoint(_ point: CGPoint) {
		var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
		var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);
		
		newPoint = newPoint.applying(transform)
		oldPoint = oldPoint.applying(transform)
		
		var position = layer.position
		
		position.x -= oldPoint.x
		position.x += newPoint.x
		
		position.y -= oldPoint.y
		position.y += newPoint.y
		
		layer.position = position
		layer.anchorPoint = point
	}
}

