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
import FirebaseFirestore


var user: User?

@IBDesignable
class ViewController: UIViewController {
	@IBOutlet weak var navBarHamburger: UIBarButtonItem!
	@IBOutlet weak var contView: UIView!
	@IBOutlet weak var nicetyLabel: UILabel!
	@IBOutlet weak var heart: UIImageView!
	
	@IBOutlet weak var heartImage: UIImageView!
	@IBOutlet weak var transitionView: UIView!
	@IBOutlet weak var menuButton: UIButton!
	@IBOutlet weak var loveListButton: UIButton!
	@IBOutlet weak var greeting: UILabel!
	let heartView = UIView()
	let heartCover = UIView()
	//auth vars
	public var user: User?
	var handle: AuthStateDidChangeListenerHandle?
	
	//RX
	var greetingRX: Disposable!
	
	//db
	var dataFetched = false

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		//MARK: Permissions
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { auth, error in
			if auth {
				print("Y")
				DispatchQueue.main.async {
					UIApplication.shared.registerForRemoteNotifications()
				}
				
			}
		})
		
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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		//MARK: NavigationBar
		self.navigationController?.navigationBar.isHidden = true
		self.navigationController?.modalPresentationStyle = .fullScreen
		showTimerLabel() // in case view is loading from when there is a timer
		self.view.setNeedsDisplay()
	}
	
	//MARK: animation
	func createTapGesutre(for view: UIView) {
		let tap = UITapGestureRecognizer(target: self, action: #selector(doAnimation(recognizer:)))
		view.addGestureRecognizer(tap)
	}
	//TODO: Add in drop down "sent" after hearts fall
	
	fileprivate func createNotification() {
		// Create local notification
		// 1. content
		let sendAgainContent = UNMutableNotificationContent()
		sendAgainContent.title = "Recharged!"
		sendAgainContent.body = "Put on your tap shoes, cause you're free to tap that heart and spread the love again!"
		// 2. trigger
		let sendAgainTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(CustomAnimations.totalTime), repeats: false)
		// 3. request
		let sendAgainRequest = UNNotificationRequest(identifier: "sendAgain", content: sendAgainContent, trigger: sendAgainTrigger)
		UNUserNotificationCenter.current().add(sendAgainRequest, withCompletionHandler: { error in
			if let e = error {
				print(e)
			} else {
				self.triggerDate = sendAgainTrigger.nextTriggerDate()!
			}
		})
	}
	
	var triggerDate: Date!
	@IBOutlet weak var timerLabel: UILabel!
	private func showTimerLabel() {
		guard !Globals.user!.isAbleToSendLove else { print("Guarded"); return } // prevent showing of label when there is no need to
		DispatchQueue.main.async {
			self.timerLabel.text = ""
			self.timerLabel.isHidden = false
		}
		
		Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in

			let timeLeft = Int(Globals.user!.timeRemainingToTapInSeconds)
			guard timeLeft >= 0 else { // should never reach this state
				self.heartCover.removeFromSuperview()
				timer.invalidate()
				return
			}
			if timeLeft == 0 {
				Globals.user!.isAbleToSendLove = true
				self.timerLabel.text = "0:00"
				self.timerLabel.isHidden = true
				self.heartCover.removeFromSuperview()
				timer.invalidate()
			} else {
				self.timerLabel.text = convertSecondsToFormattedTime(seconds: timeLeft)
				self.reduceHeight(of: self.heartCover, to: CGFloat(CustomAnimations.totalTime - timeLeft))
			}
		})
	}

	
	var initialCoverHeight: CGFloat!
	private func reduceHeight(of cover: UIView, to x: CGFloat) {
		UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
			cover.frame.size.height = self.initialCoverHeight - (CGFloat(self.initialCoverHeight/CGFloat(CustomAnimations.totalTime))*x)
		})
	}
	
	func addBlockOverHeart(_ heart: UIView) {
		heartCover.frame = heart.frame
		heartCover.backgroundColor = heart.superview!.backgroundColor
		self.view.addSubview(heartCover)
		NSLayoutConstraint.activate([
			heartCover.topAnchor.constraint(equalTo: heart.topAnchor),
			heartCover.leadingAnchor.constraint(equalTo: heart.leadingAnchor),
			heartCover.trailingAnchor.constraint(equalTo: heart.trailingAnchor)
		])
		heartCover.setAnchorPoint(CGPoint(x:0.5,y:0))
		initialCoverHeight = heartCover.frame.height
	}
	
	@objc func doAnimation(recognizer: UITapGestureRecognizer) {
		let tappedView = recognizer.view!
		if Globals.user!.isAbleToSendLove {
			CustomAnimations.fallingHeartsAnimation(view: tappedView, completion: {
				Globals.user!.isAbleToSendLove = false
				Globals.user!.dateLastTapped = Date()
				self.createNotification()
				self.showTimerLabel()
				self.addBlockOverHeart(tappedView)
				self.heartImage.isHidden = false
			})
			
		}
	}
	
	@IBAction func animationTwo(_ sender: Any) {
		CustomAnimations.growWiggleLeave(view: heartImage)
		
	}
	
	@IBAction func animationOne(_ sender: Any) {
		CustomAnimations.fallingHeartsAnimation(view: heartImage)
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
	
	//MARK: Notifications received
	func showNotificationGeneral() {
		let notificationReceivedLabel = UILabel()
		notificationReceivedLabel.textAlignment = .center
		notificationReceivedLabel.font = UIFont.init(name: "Noteworthy Light", size: 20)
		notificationReceivedLabel.text = "Someone's thinking about you!"
		
		// frame
		notificationReceivedLabel.translatesAutoresizingMaskIntoConstraints = false
		notificationReceivedLabel.frame.size = CGSize(width: self.view.frame.width, height: 32)
		view.addSubview(notificationReceivedLabel)
		NSLayoutConstraint.activate([
			notificationReceivedLabel.topAnchor.constraint(equalTo: heartImage.bottomAnchor, constant: 8),
			notificationReceivedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
			notificationReceivedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 8),
			notificationReceivedLabel.bottomAnchor.constraint(lessThanOrEqualTo: nicetyLabel.topAnchor, constant: -8)
		])
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

