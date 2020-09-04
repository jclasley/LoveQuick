//
//  ConvenienceFunctions.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 5/18/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

func deg2rad(_ number: CGFloat) -> CGFloat {
    return number * .pi / 180
}

func nestedViewMaker(parent: UIView, scaleX: CGFloat, y: CGFloat) -> UIView {
	let v = UIView()
	v.frame = CGRect(origin: parent.frame.origin, size: CGSize(width: parent.frame.width * scaleX, height: parent.frame.height * y))
	v.center = parent.center
	return v
}

func applyBlurredActivityIndicator(over v: UIView) -> UIView {
	let blurrer = UIBlurEffect(style: .regular)
	let blur = UIVisualEffectView(effect: blurrer)
	blur.frame = v.frame
	let actInd = UIActivityIndicatorView(style: .large)
	actInd.center = blur.center
	blur.contentView.addSubview(actInd)
	actInd.startAnimating()
	return blur
}

func isFirstTime() -> Bool {
	return UserDefaults.standard.bool(forKey: "launchedBefore")
}

func generateLoveLetters() -> String {
	let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	var l: String
	repeat {
		l = String((0..<5).map({ _ in letters.randomElement()! }))
	} while (loveLettersTaken(letters: l))
	return l
}

private func loveLettersTaken(letters: String) -> Bool {
	let db = Firestore.firestore()
	let usersRef = db.collection("users")
	var takenOrError: Bool = true
	usersRef.whereField("LoveLetters", isEqualTo: letters).getDocuments(completion: { (qSnap, error) in
		if let error = error {
			print(error.localizedDescription)
			takenOrError = true
		} else {
			if qSnap!.documents.count > 0 {
				takenOrError = true
			} else {
				takenOrError = false
			}
		}
	})
	return takenOrError
}

extension UINavigationController {
	func removeBorder() {
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.layoutIfNeeded()
	}
}
