//
//  RandomNiceties.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 4/18/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import Foundation

struct Nicety {
	var niceStatement: String
	let niceties = [
	"You look great today!",
	"Your loved ones can't wait to hear from you!",
	"Your smile is infectious, spread it instead of COVID",
	"Love to tap? Tap to love!",
	"Quick lovin' comin' out the oven!"
	]
	
	init() {
		self.niceStatement = niceties.randomElement()!
	}
}
