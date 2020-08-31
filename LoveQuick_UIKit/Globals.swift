//
//  Globals.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 6/5/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

struct Globals {
	
	static var user: User?
	
	static func convertToMainVC(_ uvc: UIViewController) -> ViewController? {
		uvc as? ViewController
	}
	
}

extension UIView {
	@IBInspectable var cornerRadius: CGFloat {
		get {
			return self.layer.cornerRadius
		}
		set {
			self.layer.cornerRadius = newValue
		}
	}
}
