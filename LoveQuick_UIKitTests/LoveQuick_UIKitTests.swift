//
//  LoveQuick_UIKitTests.swift
//  LoveQuick_UIKitTests
//
//  Created by Jonathan Lasley on 4/16/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import XCTest
import FirebaseAuth
import FirebaseFirestore

@testable import LoveQuick_UIKit

class LoveQuick_UIKitTests: XCTestCase {

	var handler: AuthStateDidChangeListenerHandle?
	var user: LoveQuick_UIKit.User?
	var db: Firestore!
	
	//MARK: init/deinit
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		
		//establish db
		db = Firestore.firestore()
	
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
		try Auth.auth().signOut()
		//delete user created in tests
//		Auth.auth().currentUser?.delete { error in
//			if let error = error {
//				print(error)
//			}
//		}
    }
	
	//MARK: auth tests
	
	func testSignIn() throws {
		
		Auth.auth().signIn(withEmail: "jon.lasley@gmail.com", password: "abc123") { result, error in
			if let error = error {
				print("Error \(error)")
			}
		}
		
		XCTAssert(Auth.auth().currentUser != nil)
	}
	
	func testDisplayName() throws {
		
		Auth.auth().signIn(withEmail: "jon.lasley@gmail.com", password: "abc123") { result, error in
			if let error = error {
				print("Error \(error)")
			} else {
				self.user = LoveQuick_UIKit.User(uid: Auth.auth().currentUser!.uid, displayName: "John", email: "jon.lasley@gmail.com")
				self.user?.changeDisplayName(to: self.user!.displayName!)
				XCTAssert(self.user?.displayName == "John")
			}
		}
	}
		
	
	//MARK: DB tests
	
	func testDBCreation() throws {
	
		Auth.auth().signIn(withEmail: "jon.lasley@gmail.com", password: "abc123") {result, error in
			if let error = error {
				print("Error \(error)")
			} else {
				self.user = LoveQuick_UIKit.User(uid: Auth.auth().currentUser!.uid, displayName: "Jon", email: "jon.lasley@gmail.com")
			
				
				self.user?.updateFirestoreWithInfo()
				let curUserDB = self.db.collection("users").document(self.user?.uid ?? "")
				curUserDB.getDocument { result, error in
					if let error = error {
						print(error)
					} else {
						XCTAssert(result?.data()?.count == 3)
					}
				}
			}
		}

	}
	
	func testChangeDisplayName() throws {
		if let user = Auth.auth().currentUser {
			let changeRequest = user.createProfileChangeRequest()
			changeRequest.displayName = "Test"
			changeRequest.commitChanges {error in
				if let error = error {
					print(error)
				} else {
					XCTAssert(user.displayName == "Test")
				}
			}
		}

	}

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
