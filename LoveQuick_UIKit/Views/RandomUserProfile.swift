//
//  RandomUserProfile.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 6/9/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import UIKit

struct RandomPicture {
	let pictures: [UIImage] = {
		var img = [UIImage]()
		img.append(UIImage(named: "cloudHeart")!)
		return img
	}()
	
}
