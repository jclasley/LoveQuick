//
//  FirstTimeNicknameViewController.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 7/3/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import FirebaseAuth
import FirebaseFirestore

class FirstTimeNicknameViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var nickname: UITextField!
	var db: Firestore!
	var errorLabel: UILabel!
	override func viewDidLoad() {
        super.viewDidLoad()
		db = Firestore.firestore()
		nickname.delegate = self
		errorLabel = UILabel()
		errorLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 60)
		errorLabel.text = ""
		errorLabel.textAlignment = .center
		errorLabel.adjustsFontSizeToFitWidth = true
		errorLabel.translatesAutoresizingMaskIntoConstraints = false
		let constraints = [
			errorLabel.bottomAnchor.constraint(equalTo: subtext.topAnchor, constant: 8),
			errorLabel.topAnchor.constraint(equalTo: nickname.bottomAnchor, constant: 8),
			errorLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
			errorLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 8)
		]
		self.view.addSubview(errorLabel)
		NSLayoutConstraint.activate(constraints) //constraints for errorLabel
        // Do any additional setup after loading the view.
    }
    
	@IBAction func tapOutsideTextbox(_ sender: Any) {
		if nickname.isEditing {
			self.view.endEditing(true)
		}
	}
	
	//MARK: UITextFieldDelegate methods
	func textFieldDidBeginEditing(_ textField: UITextField) {
		//RXSwift validation
		let tfObs = PublishSubject<String>()
		self.errorLabel.text = ErrorTypes.empty.rawValue
		nickname.rx.text.orEmpty.bind(to: tfObs)
		tfObs.asObservable().subscribe(onNext: { newValue in
			if newValue.count > 0 {
				self.errorLabel.text = ErrorTypes.none.rawValue
			} else {
				self.errorLabel.text = ErrorTypes.empty.rawValue
			}
		})
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch errorLabel.text {
			case ErrorTypes.empty.rawValue:
				return false
			default:
				return true
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
		let blur = applyBlurredActivityIndicator(over: self.view)
		self.view.addSubview(blur)
		let change = Globals.user?.changeDisplayName(to: textField.text!)
		change?.commitChanges(completion: { _ in
			blur.removeFromSuperview()
			guard let newVC = self.storyboard?.instantiateViewController(identifier: "lastSignupIntro") else {
				return
			}
			self.navigationController?.pushViewController(newVC, animated: true)
		})
		
		//MARK: Remaining
		//switch to main view
		//add in popovers on each of the interactable units in the main view to give instruction on how to use the app
		//then, update NSUserDefaults to indicate that they have completed the initial launch
		//Add in notification feature
		//Animation for the heart
	}
	
	enum ErrorTypes: String {
		case empty = "Please enter a nickname"
		case database = "Something went wrong with the connection to the server"
		case none = ""
	}
	
	@IBOutlet weak var subtext: UILabel!
}
