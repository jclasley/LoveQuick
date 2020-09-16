//
//  AddToLoveListViewController.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 7/17/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AddToLoveListViewController: UIViewController {

	@IBOutlet weak var addedConfirmation: UILabel!
	@IBOutlet weak var loveLetters: UITextField!
	@IBOutlet weak var addButton: UIButton!
	var db: Firestore!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.addButton.styleForLogin()
		self.navigationController?.navigationBar.isHidden = false
		self.navigationController?.removeBorder()
		db = Firestore.firestore()
        // Do any additional setup after loading the view.
		
		// Confirmation
		addedConfirmation.isHidden = true
    }
    
	override func viewWillDisappear(_ animated: Bool) {
		self.navigationController?.hero.navigationAnimationType = .push(direction: .right)
		super.viewWillDisappear(true)
	}
	
	@IBAction func returnToView(_ sender: Any) {
		self.loveLetters.endEditing(true)
	}
	
	enum addErrors: CustomStringConvertible {
		
		case noUser
		case alreadyInList
		case addSelf
		var description: String {
			switch self {
				case .noUser:
					return "No user found"
				case .alreadyInList:
					return "They're already in your list!"
				case .addSelf:
					return "We know you love yourself, but try again!"
			}
		}
	}
	
	@IBAction func addToList(_ sender: Any) {
		guard let letters = loveLetters.text else {
			return
			self.loveLetters.text = nil
		}
		guard Globals.user?.loveLetterDictionary.index(forKey: letters) == nil else {
			self.addedConfirmation.text = addErrors.alreadyInList.description
			self.addedConfirmation.isHidden = false
			self.loveLetters.text = nil
			return
		}
		
		let query = db.collection("users").whereField("LoveLetters", isEqualTo: loveLetters.text as Any)
		query.getDocuments(completion: { snapshot, error in
			if let error = error {
				print(error)
			}
			if !snapshot!.isEmpty, let doc = snapshot?.documents[0] {
				let userToAdd = doc.data()["Display name"] as! String
				//TODO: Add user's UID to list
				Globals.user?.asyncAddToList(letters)
				self.addedConfirmation.text = "You've added \(userToAdd) to your list!"
				self.addedConfirmation.isHidden = false
				self.loveLetters.text = nil
			} else {
				self.addedConfirmation.text =
					addErrors.noUser.description
				self.addedConfirmation.isHidden = false
				self.loveLetters.text = nil
			}
		})
	}
}
