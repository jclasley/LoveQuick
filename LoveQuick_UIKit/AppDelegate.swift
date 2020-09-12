//
//  AppDelegate.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 4/16/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		FirebaseApp.configure()
		let db = Firestore.firestore()
		print(db) //silence warning
		registerForPushNotifications()
		
		//	Opened via push notifications
		let notificationOption = launchOptions?[.remoteNotification] 
		return true
	}

	func registerForPushNotifications() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {
			auth, error in
				if let error = error {
					print(error)
				} else if auth {
					print("Y")
				} else {
					print("N")
				}
			self.getNotificationSettings()
		})
	}
	
	func getNotificationSettings() {
		UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
			guard settings.authorizationStatus == .authorized else { return }
			DispatchQueue.main.async {
				UIApplication.shared.registerForRemoteNotifications()
			}
		})
	}
	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}
	
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
		let token = tokenParts.joined()
		print("Device Token: \(token)")
		Globals.user?.deviceToken = token
	}
	
	func application(
	  _ application: UIApplication,
	  didFailToRegisterForRemoteNotificationsWithError error: Error) {
	  print("Failed to register: \(error)")
	}


}

