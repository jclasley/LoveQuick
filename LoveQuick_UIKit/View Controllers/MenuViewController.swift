//
//  MenuViewController.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 6/10/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import UIKit
import Hero
import FirebaseFirestore
import FirebaseAuth
import RxSwift

class MenuViewController: UIViewController, UITextFieldDelegate {
	
	var user: User?
	lazy var thinking = UIActivityIndicatorView(style: .large)
	
	@IBOutlet weak var signOutButton: UIButton!
	override func viewDidLoad() {
        super.viewDidLoad()
		self.signOutButton.styleForLogin()
		loveLetters.text = Globals.user?.loveLetters
		self.navigationItem.title = "Profile"
    }
	
	@IBOutlet weak var displayName: UITextField!
	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var loveLetters: UILabel!
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.user = Globals.user
		let navBar = self.navigationController?.navigationBar
		navBar?.isHidden = false
		navBar?.barTintColor = #colorLiteral(red: 0.7132477164, green: 0.5669612885, blue: 0.9291825891, alpha: 1)
		displayName.text = self.user?.displayName
		displayName.isEnabled = false
		displayName.delegate = self
		email.text = self.user?.email
		email.isEnabled = false
	}
	
	@IBAction func changeDisplayName (_ sender: Any) {
		self.displayName.isEnabled = true
		self.displayName.becomeFirstResponder()
	}
	
	@IBAction func changeEmail(_ sender: Any) {
		self.email.isEnabled = true
		self.email.becomeFirstResponder()
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		//blur effect
		let blur = UIBlurEffect(style: .regular)
		let effectView = UIVisualEffectView(frame: self.view.frame)
		thinking.frame = effectView.frame
		effectView.contentView.addSubview(thinking)
		thinking.startAnimating()
		effectView.effect = blur
		self.view.addSubview(effectView)

		switch textField {
			case displayName:
				if displayName.text != nil {
					if let changeRequest = self.user?.changeDisplayName(to: displayName.text!) {
						Globals.user?.displayName = displayName.text
						changeRequest.commitChanges() { error in
							if let error = error {
								print(error)
							} else {
								self.thinking.stopAnimating()
							}
							effectView.removeFromSuperview()
						}
					}

				}
				
			case email:
				if email.text != nil {
					Auth.auth().currentUser?.updateEmail(to: email.text!) { error in
						if let error = error {
							print(error)
							effectView.removeFromSuperview()
						} else {
							self.thinking.stopAnimating()
							effectView.removeFromSuperview()
						}
					}
			}
			default:
				
				return
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		textField.isEnabled = false
		return true
	}
	
	@IBAction func returnFromEditing(_ sender: Any) {
		self.view.endEditing(true)
	}
	
	
	override func viewWillDisappear(_ animated: Bool) {
		self.navigationController?.heroNavigationAnimationType = .uncover(direction: .left)
		super.viewWillDisappear(animated)
	}

	@IBAction func signOut(_ sender: Any) {
		do {
			try Auth.auth().signOut()
			self.navigationController?.heroNavigationAnimationType = .zoomSlide(direction: .right)
			hero.unwindToViewController(withClass: LoadingViewController.self)
		} catch {
			showErrorMessage()
		}
	}
	
	func showErrorMessage() {
		let errorView = nestedViewMaker(parent: self.view, scaleX: 0.85, y: 0.33)
		errorView.backgroundColor = .white
		errorView.layer.borderWidth = 2.0
		errorView.layer.borderColor = UIColor.black.cgColor
		
		let errorLabel = UILabel()
		errorLabel.text = "Uh oh, somehting went wrong!"
		errorLabel.frame = errorView.frame
		errorLabel.textAlignment = .center
		errorView.addSubview(errorLabel)
		self.view.addSubview(errorView)
	}

}
