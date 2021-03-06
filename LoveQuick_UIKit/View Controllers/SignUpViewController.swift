//
//  SignUpViewController.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 4/22/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import UIKit
import FirebaseAuth
import Hero

class SignUpViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var signUpButton: UIButton!
	
	//fields
	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	@IBOutlet weak var passwordAuthField: UITextField!
	@IBOutlet weak var firstName: UITextField!
	@IBOutlet weak var lastName: UITextField!
	@IBOutlet weak var errorLabel: UILabel!
	
	//alignemnt
	override func viewDidLoad() {
        super.viewDidLoad()
		
		//add obervers
//		registerForKeyboardNotify()

		signUpButton.styleForLogin()
		view.backgroundColor = UIColor(displayP3Red: 176/255, green: 145/255, blue: 237/255, alpha: 1)
		
		// Nav controller stuff
		self.navigationController?.navigationBar.isHidden = false
		self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem
	
		//MARK: fields in view
		firstName.delegate = self
		lastName.delegate = self
		emailField.delegate = self
		passwordField.delegate = self
		passwordAuthField.delegate = self
    }
    
	override func viewWillDisappear(_ animated: Bool) {
		self.navigationController?.heroNavigationAnimationType = .push(direction: .right)
		super.viewWillDisappear(animated)
		self.navigationController?.navigationBar.isHidden = true
	}
//	override func viewWillAppear(_ animated: Bool) {
//		super.viewWillAppear(animated)
//		self.navigationController?.navigationBar.isHidden = false
//	}
	
	//MARK: Auth
	
	
	func passwordsMatch() -> Bool {
		if passwordField.hasText && passwordAuthField.hasText {
			return passwordField.text == passwordAuthField.text
		} else { return false }
	}
	
	var user: User?
	
	@IBOutlet var background: UIView!
	
	//MARK: textfields
	
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
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField.tag > 1 {
			let totalTagHeight = textField.frame.height * CGFloat((textField.tag - 1))
			view.frame.origin.y -= totalTagHeight
		}
		// clear error to elucidate repeat errors
		self.errorLabel.text = ""
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField.tag > 1 {
			let totalTagHeight = textField.frame.height * CGFloat((textField.tag - 1))
			view.frame.origin.y += totalTagHeight
		}
	}
	
	@IBAction func returnReponseToView(_ sender: Any) {
		view.endEditing(true)
	}

	
	//MARK: Auth functions
	
	@IBAction func signUp(_ sender: Any) {
		
		let fieldsAreValidatedBool = fieldsAreValidated(fields: emailField, passwordField, passwordAuthField, firstName, lastName).0
		let fieldsAreValidatedError = fieldsAreValidated(fields: emailField, passwordField, passwordAuthField, firstName, lastName).1
		if fieldsAreValidatedBool {
			Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { result, error in
				if error != nil {
					//show error description
					self.errorLabel.text = error.debugDescription
					self.errorLabel.isHidden = false
				} else {
					//create user instance
					self.user = User(uid: Auth.auth().currentUser!.uid, displayName: self.firstName.text, email: self.emailField.text!)
					//update global
					Globals.user = self.user
					//update DB
					self.user?.updateFirestoreWithInfo()
					//segue
					self.transitionTo(identifier: "firstTimeLaunch")
				}
			}
			
		} else {
			self.errorLabel.text = fieldsAreValidatedError?.message
			self.errorLabel.isHidden = false
		}
		
	}

	enum ErrorMessages {
		case invalidEmail(message: String)
		case passwordsNotMatch(message: String)
		case blankField(message: String)

		var message: String {
			switch self {
				case .invalidEmail(let message),
					.passwordsNotMatch(let message),
					.blankField(let message):
				return message
			}
		}
	}
	
	func fieldsAreValidated(fields: UITextField...) -> (Bool, ErrorMessages?) {
		var full = true
		var error: ErrorMessages?
		for field in fields {
			if !field.hasText {
				full = false
				error = .blankField(message: "All fields are required")
				return (full, error)
			}
		}
		if let email = emailField.text {
			if email.match(regex: "@.*com") == nil {
				full = false
				error = .invalidEmail(message: "Please enter a valid email address")
				return (full, error)
			}
		}
		if passwordField.text != passwordAuthField.text {
			full = false
			error = .passwordsNotMatch(message: "Passwords don't match")
			return (full, error)
		}
		return (full, error)
	}
	
	//MARK: DB
	
	
	//MARK: Segue
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let mainVC = segue.destination as? ViewController {
			mainVC.user = self.user
		}
	}
	
	func transitionTo(identifier: String) {
		if let newVC = self.storyboard?.instantiateViewController(identifier: identifier) {
			self.hero.isEnabled = true
			newVC.hero.isEnabled = true
			newVC.hero.modalAnimationType = .pull(direction: .left)
			self.navigationController?.hero.replaceViewController(with: newVC)
		}
		
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
