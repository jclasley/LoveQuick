//
//  LoginViewController.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 4/21/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Hero

class LoginViewController: UIViewController, UITextFieldDelegate {

	//auth
	var handle: AuthStateDidChangeListenerHandle?
	var user: User?
	let db = Firestore.firestore()
	
	@IBOutlet weak var loveQuick: UIImageView!
	@IBOutlet weak var catchphrase: UILabel!
	@IBOutlet weak var signInButton: UIButton!
	@IBOutlet weak var errorMessage: UILabel!
	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	
	//MARK: lets
	let redPink = UIColor(displayP3Red: 241/255, green: 146/255, blue: 214/255, alpha: 1)
	let pastelYellow = UIColor(displayP3Red: 246/255, green: 247/255, blue: 135/255, alpha: 1)
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		//MARK: Delegates
		emailField.delegate = self
		passwordField.delegate = self
		Auth.auth().addStateDidChangeListener { (auth, user) in
			if let user = user {
				Globals.user = User(uid: user.uid, displayName: user.displayName, email: user.email)
			}
		}
		
		signInButton.styleForLogin()
		
		view.backgroundColor = #colorLiteral(red: 0.6916132569, green: 0.5701339841, blue: 0.929064393, alpha: 1)
		
		let shadow = NSShadow()
		shadow.shadowColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
		shadow.shadowBlurRadius = 3

		self.navigationController?.hero.isEnabled = true
		loveQuick.hero.modifiers = [.scale()]
		
		//MARK: catchphraseAttributes
		let cAttributes: [NSAttributedString.Key: Any] = [
			.font: catchphrase.font!,
			.shadow: shadow,
			.foregroundColor: #colorLiteral(red: 1, green: 0.8875713944, blue: 0.4026675224, alpha: 1)
		]
		
		let cAttrb = NSAttributedString(string: catchphrase.text ?? "", attributes: cAttributes)
		catchphrase.attributedText = cAttrb
		
		//MARK: error message
		//add animation for its appearance
		
        // Do any additional setup after loading the view.
    }
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		let nextTag = textField.tag + 1
		
		if let nextField = textField.superview?.viewWithTag(nextTag) {
			nextField.becomeFirstResponder()
		} else if let nextField = textField.superview?.superview?.viewWithTag(nextTag){
			nextField.becomeFirstResponder()
		} else {
			textField.resignFirstResponder()
		}
		return true
	}

	//zoom in on field
//
//	func textFieldDidBeginEditing(_ textField: UITextField) {
//		view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
//		if textField.tag > 1 {
//			let totalTagHeight = textField.frame.height * CGFloat((textField.tag - 1))
//			view.frame.origin.y -= totalTagHeight
//		}
//	}
//
//	func textFieldDidEndEditing(_ textField: UITextField) {
//		view.transform = CGAffineTransform(scaleX: 1, y: 1)
//		if textField.tag > 1 {
//			let totalTagHeight = textField.frame.height * CGFloat((textField.tag - 1))
//			view.frame.origin.y += totalTagHeight
//		}
//	}
	
	@IBAction func returnView(_ sender: Any) {
		view.endEditing(true)
	}
	
	@IBAction func signUpTapped(_ sender: Any) {
		self.performSegue(withIdentifier: "navToSignUp", sender: nil)
	}
	
	//MARK: Auth
	@IBAction func signIn(_ sender: Any) {
		let activity = UIActivityIndicatorView(style: .large)
		activity.center = self.view.center
		activity.frame = self.view.frame
		activity.startAnimating()
		self.view.addSubview(activity)
		
		if (emailField.hasText && passwordField.hasText) {
			Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { result, error in
				if (error != nil) {
					self.errorMessage.isHidden = false
				} else {
					activity.stopAnimating()
					if isFirstTime() {
						if let firstLaunchVC = self.storyboard?.instantiateViewController(identifier: "firstTimeLaunch") {
							self.navigationController?.hero.replaceViewController(with: firstLaunchVC)
						}
					}
					self.view.heroID = "titleBackground"
					if let mainVC = self.storyboard?.instantiateViewController(identifier: "mainVC") {
						mainVC.hero.isEnabled = true
						Globals.convertToMainVC(mainVC)?.user = self.user
						self.colorChangeTransition(of: self.view, to: mainVC, color: #colorLiteral(red: 0.8686888218, green: 0.06397780031, blue: 0, alpha: 1))

					}
				}
			}			
		}
	}
	
	func colorChangeTransition(of v: UIView, to vc: UIViewController, color: UIColor = .systemPink) {
		UIView.animate(withDuration: 1, animations: {
			v.backgroundColor = color
		}, completion: { _ in
			self.navigationController?.pushViewController(vc, animated: true)
		})
	}

}
