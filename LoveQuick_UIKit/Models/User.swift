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
import RxSwift

class User: Equatable {
	//MARK: protocols
	static func == (lhs: User, rhs: User) -> Bool {
		lhs.uid == rhs.uid
	}
	
	//MARK: props
	var uid: String
	var displayName: String? {
		willSet {
			publishedDisplayName.onNext("Hi, \(newValue!)!")
		}
	}
	let publishedDisplayName = PublishSubject<String>()
	var email: String?
	var loveLetters: String!
	var userListWithUIDs = [String]()
	var loveListWithNames = [String]()
	var loveLetterDictionary = Dictionary<String,String>()
	var db: Firestore!
	var isAbleToSendLove: Bool = true
	let dispatchGroup = DispatchGroup()
	var hasUpdatedFromDB = false
	var deviceToken: String! {
		willSet {
			guard newValue != "" else { return }
			db.collection("users").document(self.uid).updateData(["Device token" : newValue!])
		}
	}
	
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
		self.deviceToken = ""
		fetchLoveLetters()
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
	
	func changeDisplayName(to name: String) -> UserProfileChangeRequest? {
		if let user = Auth.auth().currentUser {
		let changeRequest = user.createProfileChangeRequest()
		changeRequest.displayName = name
		return changeRequest
		}
		return nil
	}
	
	func fetchLoveLetters() {
		let db = Firestore.firestore()
		db.collection("users").document(self.uid).getDocument(completion: { (snapshot, error) in
			if let error = error {
				print(error.localizedDescription)
			} else {
				self.loveLetters = snapshot?.get("LoveLetters") as? String
			}
		})
	}
	
	func updateFirestoreWithInfo() {
		
		//TODO: Update to copy the sample data
		
		db.collection("users").document(uid).setData([
			"Display name": displayName!,
			"Email": email!,
			"LoveLetters": generateLoveLetters(),
			"User list": userListWithUIDs,
		])
	}
	
	func signUp(forDisplayName displayName: String, withPassword password: String) {
		Auth.auth().createUser(withEmail: email!, password: password) { result, error in
			if let error = error {
				print("Error \(error)")
			} else {
				//create DB reference
				self.updateFirestoreWithInfo()
				//change displayName
				self.changeDisplayName(to: displayName)
			}
		}
	}

	//MARK: fetch lovelist from DB
	let dispatch = DispatchGroup() // to manage conversion to names
	
	func asyncPopulateLoveListWithUIDs(completion: @escaping () -> Void) {
		// clear dictionary
		loveLetterDictionary.removeAll()

		db.collection("users").document(self.uid).getDocument() { snapshot, error in
			if let error = error {
				print("Error: \(error)")
			} else {
				let letterArray = snapshot?.data()?["User list"] as! [String]
				self.asyncConvertLoveLettersToUsernames(letterArray: letterArray)
				self.dispatch.notify(queue: .main, execute: {
					completion()
				})
			}
		}
	}
	
	func asyncConvertLoveLettersToUsernames(letterArray: [String], completion: @escaping () -> Void = { }) {
		for letters in letterArray {
			dispatch.enter() // enter once per item in array -- this will happen immediately despite the return status
			let query = db.collection("users").whereField("LoveLetters", isEqualTo: letters)
			query.getDocuments(completion: { (snapshot, error) in
				if let docs = snapshot?.documents {
					var i = 1 //Debugging
					for doc in docs {
						let displayName = doc.get("Display name") as! String
						// add to dictionary
						self.loveLetterDictionary[letters] = displayName
						self.dispatch.leave() // leave only when the item gets converted -- should only occur when the async operation returns
						i+=1
					}
				}
			})
		}
		completion()
	}
	
	//MARK: Add/remove from lovelist
	
	func asyncRemoveFromList(_ uid: String, completion: @escaping () -> () = { }) {
		self.dispatchGroup.enter()
		db.collection("users").document(self.uid).updateData(
			["User list": FieldValue.arrayRemove([uid])]
		) { error in
			if let error = error {
				print(error)
				self.dispatchGroup.leave()
			} else {
				self.asyncPopulateLoveListWithUIDs(completion: completion)
				self.dispatchGroup.leave()
			}
		}
	}
	
	func asyncAddToList(_ loveletters: String) {
		//adds based on loveletters, not UID
		self.dispatchGroup.enter()
		db.collection("users").document(self.uid).updateData(
			["User list": FieldValue.arrayUnion([loveletters])]
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
