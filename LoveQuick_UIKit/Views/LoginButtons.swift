//
//  LoginButtons.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 4/22/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import UIKit

extension UIButton {
	
	func styleForLogin() {
		let goodPurple = UIColor(displayP3Red: 111/255, green: 75/255, blue: 198/255, alpha: 1)
//		let lightPurple = UIColor(displayP3Red: 176/255, green: 145/255, blue: 237/255, alpha: 1)
		let redPink = UIColor(displayP3Red: 241/255, green: 146/255, blue: 214/255, alpha: 1)
//		let pastelYellow = UIColor(displayP3Red: 246/255, green: 247/255, blue: 135/255, alpha: 1)
		
		
		self.backgroundColor = redPink
		self.setTitleColor(goodPurple, for: .normal)
		self.layer.cornerRadius = 5
	}

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
