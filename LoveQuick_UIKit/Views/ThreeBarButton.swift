//
//  ThreeBarButton.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 5/21/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import UIKit

class ThreeBarButton: UIButton {
	@IBInspectable
	var strokeWidth: CGFloat
	
	init(x: CGFloat, y: CGFloat, height: CGFloat, strokeWidth: CGFloat = 2) {
		
		self.strokeWidth = strokeWidth
		super.init(frame: CGRect(x: x, y: y, width: height*1.5, height: height))
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func draw(_ rect: CGRect) {
		let color = #colorLiteral(red: 0.3423182462, green: 0.07435001198, blue: 0.5976959074, alpha: 1)
		color.setStroke()
		
		for line in 1...3 {
			let yOffset: CGFloat = {
				var offset = CGFloat()
				switch line {
					case 1:
						offset = rect.origin.y + strokeWidth/2
						print("1: \(offset)")
						return offset
					case 2:
						offset = rect.origin.y + rect.height/CGFloat(line)
						print("2: \(offset)")
						return offset
					case 3:
						offset = rect.origin.y + rect.height - strokeWidth/2
						print("3: \(offset)")
						return offset
					default:
						return offset
				}
			}()

			let path = UIBezierPath()
			path.move(to: CGPoint(x: rect.origin.x, y: yOffset))
			path.addLine(to: CGPoint(x: rect.origin.x + rect.width, y: yOffset))
			path.lineWidth = strokeWidth
			path.stroke()
		}
	}
	
}
