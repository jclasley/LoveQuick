//
//  User.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 4/24/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class User: Equatable {
	//MARK: protocols
	static func == (lhs: User, rhs: User) -> Bool {
		lhs.uid == rhs.uid
	}
	
	//MARK: props
	var uid: String
	var displayName: String?
	var email: String?
	var userListWithUIDs = [String]()
	var loveListWithNames = [String]()
	var db: Firestore!
	
	let dispatchGroup = DispatchGroup()
	var hasUpdatedFromDB = false
	
	//MARK: Err enum
	enum Error: Swift.Error {
		case invalidUser
		
		var localizedDescription: String {
			switch self {
				case .invalidUser:
					return "Not a registered user"
			}
		}
	}
	
	//MARK: init
	init(uid: String, displayName: String?, email: String?) {
		self.uid = uid
		self.displayName = displayName
		self.email = email
		self.db = Firestore.firestore()
	}
	
	//
	func getFirstName() -> String? {
		if let name = displayName {
			if let space = name.firstIndex(of: " ") {
				return String(name.prefix(upTo: space)) //return string up to but not including the index of the space character
			} else {
				return name //return whole name if no space
			}
		} else {
			return nil //no display name, default to friend
		}
	}
	
	func changeDisplayName(to: String) {
		if let user = Auth.auth().currentUser {
		let changeRequest = user.createProfileChangeRequest()
		changeRequest.displayName = displayName
		changeRequest.commitChanges {error in
			if let error = error {
				print(error)
				}
			}
		}
	}
	
	func updateFirestoreWithInfo() {
		db.collection("users").document(uid).setData([
			"Display name": displayName!,
			"Email": email!,
			"User list": userListWithUIDs,
		])
	}
	
	func signUp(forDisplayName displayName: String, withPassword password: String) {
		Auth.auth().createUser(withEmail: email!, password: password) { result, error in
			if let error = error {
				print("Error \(error)")
			} else {
				//change displayName
				self.changeDisplayName(to: displayName)
				//create DB reference
				self.updateFirestoreWithInfo()
			}
		}
	}

	//MARK: fetch lovelist from DB
	
	func asyncPopulateLoveListWithUIDs() {
		self.dispatchGroup.enter()
		db.collection("users").document(self.uid).getDocument() { snapshot, error in
			if let error = error {
				print("Error: \(error)")
				self.dispatchGroup.leave()
			} else {
				self.userListWithUIDs = snapshot?.data()?["User list"] as! [String]
				self.asyncConvertUIDToUsernames()
				self.dispatchGroup.leave()
			}
		}
	}
	
	func asyncConvertUIDToUsernames() {
		
		for uids in self.userListWithUIDs {
			self.dispatchGroup.enter()
			db.collection("users").document(uids).getDocument() { snapshot, error in
				if let error = error {
					//handle error
					print(error) //silence warning
					self.dispatchGroup.leave()
				} else {
					if let displayName = snapshot?.data()?["Display name"] {
						self.loveListWithNames.append(displayName as! String)
						self.dispatchGroup.leave()
					}
				}
			}
		}
	}
	
	//MARK: Add/remove from lovelist
	
	func asyncRemoveFromList(_ uid: String) {
		self.dispatchGroup.enter()
		db.collection("users").document(self.uid).updateData(
			["User list": FieldValue.arrayRemove([uid])]
		) { error in
			if let error = error {
				print(error)
				self.dispatchGroup.leave()
			} else {
				self.dispatchGroup.leave()
			}
		}
	}
	
	func asyncAddToList(_ uid: String) {
		self.dispatchGroup.enter()
		db.collection("users").document(self.uid).updateData(
			["User list": FieldValue.arrayUnion([uid])]
		) { error in
			if let error = error {
				print(error)
				self.dispatchGroup.leave()
			} else {
				self.dispatchGroup.leave()
			}
		}
	}
	
	
}
