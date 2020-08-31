//
//  LoadingViewController.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 6/4/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import UIKit
import FirebaseAuth
import Hero

var theUser: User?


class LoadingViewController: UIViewController {

	@IBOutlet weak var loveQuickTitle: UIImageView!
	var handle: AuthStateDidChangeListenerHandle?
	var user: User?
//	let db = Firestore.firestore()

	override func viewDidLoad() {
        super.viewDidLoad()
		//TODO: FIX #if DEBUG to work
		
		#if DEBUG
		UserDefaults.standard.set(false, forKey: "launchedBefore")
		#endif
		
        //Hero
		self.loveQuickTitle.heroModifiers = [.fade]
    }
    
	//MARK: Auth
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.isHidden = true
		
		handle = Auth.auth().addStateDidChangeListener { (auth, user) in
			if let user = user {
				self.user = User(uid: user.uid, displayName: user.displayName, email: user.email)
				//fetch letter
				Globals.user = self.user
				Globals.user?.fetchLoveLetters()
				if let mainViewController = self.storyboard?.instantiateViewController(identifier: "mainVC") {
					mainViewController.hero.isEnabled = true
					self.loveQuickTitle.heroModifiers = [.fade]
					Globals.convertToMainVC(mainViewController)?.user = self.user
					self.colorChangeTransition(of: self.view, to: mainViewController, color: #colorLiteral(red: 0.8647238016, green: 0.06425023824, blue: 0, alpha: 1))
				}
				
			} else {
				if let loginViewController = self.storyboard?.instantiateViewController(identifier: "loginView") {
					loginViewController.hero.isEnabled = true
					DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
						self.navigationController?.heroNavigationAnimationType = .fade
						self.navigationController?.pushViewController(loginViewController, animated: true)
					})
					
				}
			}
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		Auth.auth().removeStateDidChangeListener(handle!)
	}
	
	//return background to purple
	override func viewDidDisappear(_ animated: Bool) {
		self.view.backgroundColor = #colorLiteral(red: 0.6901960784, green: 0.568627451, blue: 0.9294117647, alpha: 1)
	}
	
//	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		if let navVC = segue.destination as? UINavigationController {
//			if let mainVC = navVC.children[0] as? ViewController {
//				mainVC.modalPresentationStyle  = .fullScreen
//				mainVC.user = self.user
//			}
//		}
//	}
	
	//MARK: Animations
	func colorChangeTransition(of v: UIView, to vc: UIViewController, color: UIColor = .systemPink) {
		UIView.animate(withDuration: 1, animations: {
			v.backgroundColor = color
		}, completion: { finished in
			if finished {
				self.navigationController?.hero.isEnabled = true
				self.navigationController?.heroNavigationAnimationType = .fade
				self.navigationController?.pushViewController(vc, animated: true)
			}
		})
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
