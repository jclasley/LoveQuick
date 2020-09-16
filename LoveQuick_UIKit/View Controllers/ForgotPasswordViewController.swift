//
//  ForgotPasswordViewController.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 9/16/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//


import UIKit
import FirebaseAuth
import RxSwift

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var resetButton: UIButton!
	@IBOutlet weak var emailToReset: UITextField!
	@IBOutlet weak var responseLabel: UILabel!
	
	@IBOutlet var leaveView: UITapGestureRecognizer!
	override func viewDidLoad() {
        super.viewDidLoad()
		//MARK: Delegate declarations
		emailToReset.delegate = self
        // Do any additional setup after loading the view.
		//MARK: Hero
		self.hero.isEnabled = true
		self.navigationController?.hero.navigationAnimationType = .pull(direction: .left)
//		self.navigationController?.navigationBar.isHidden = false
    }
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.navigationBar.isHidden = false
		super.viewWillAppear(animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		self.navigationController?.navigationBar.isHidden = true
		self.navigationController?.hero.navigationAnimationType = .push(direction: .right)
		super.viewWillDisappear(animated)
	}
    
	@IBAction func submitPasswordReset(_ sender: Any) {
		
		guard let email = emailToReset.text, email.match(regex: "..*@.*\\...{2,}") != nil else { // improper or empty email
			self.responseLabel.text = "Please enter a valid email address"
			self.responseLabel.isHidden = false
			return
		}
		Auth.auth().sendPasswordReset(withEmail: email, completion: { error in
			if let error = error {
				print(error)
			}
			else {
				self.view.endEditing(true)
				self.responseLabel.text = "Reset email sent"
				self.responseLabel.isHidden = false
			}
		})
	}
	
	
	@IBAction func leaveTextField(_ sender: Any) {
		view.endEditing(true)
	}
	
	//MARK: Delegate functions
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		//hide error message to better show repeate errors
		self.responseLabel.isHidden = true
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		leaveTextField(self)
		submitPasswordReset(self)
		return true
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
