//
//  EnvelopeView.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 4/30/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import UIKit
@IBDesignable
class EnvelopeView: UIView {
	@IBInspectable var fillColor: UIColor = UIColor.white
	@IBInspectable var strokeColor: UIColor = UIColor.gray

    override func draw(_ rect: CGRect) {
		fillColor.setFill()
		strokeColor.setStroke()
		let body = getEnvelopePath(rect).body
		body.stroke()
		let flap = getEnvelopePath(rect).flap
		flap.stroke()
	}
	
	func getEnvelopePath(_ rect: CGRect) -> (body: UIBezierPath, flap: UIBezierPath) {
		let flap = CGMutablePath()
		flap.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y * 1.05))
		flap.addLine(to: CGPoint(x: rect.width/2, y: rect.origin.y + rect.height / 2))
		flap.addLine(to: CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y * 1.05))
		//downcast
		let flapPath = UIBezierPath(cgPath: flap as CGPath)
		
		let body = UIBezierPath(rect: rect)
		
		return (body, flapPath)
	}
	
}
