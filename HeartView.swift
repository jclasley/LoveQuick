//
//  HeartView.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 4/30/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import UIKit

@IBDesignable
class HeartView: UIView {
	@IBInspectable var fillColor: UIColor = UIColor.systemPink
	
    override func draw(_ rect: CGRect) {
		let path = createHeart(in: rect)
		fillColor.setFill()
		path.fill()
    }
	
	func createHeart(in frame: CGRect) -> UIBezierPath {
		//baseline points

		let curvePoints = determineCurvePoints(forFrame: frame)
		
		//curves
		let heart = UIBezierPath()
		heart.move(to: CGPoint(x: frame.width/2, y: frame.height * 0.3))
		heart.addCurve(to: curvePoints[0].point, controlPoint1: curvePoints[0].curve1, controlPoint2: curvePoints[0].curve2)
		heart.addCurve(to: curvePoints[1].point, controlPoint1: curvePoints[1].curve1, controlPoint2: curvePoints[1].curve2)
		heart.addCurve(to: curvePoints[2].point, controlPoint1: curvePoints[2].curve1, controlPoint2: curvePoints[2].curve2)
		heart.addCurve(to: curvePoints[3].point, controlPoint1: curvePoints[3].curve1, controlPoint2: curvePoints[3].curve2)
		
		return heart
	}

	func determineCurvePoints(forFrame frame: CGRect) -> [(point: CGPoint, curve1: CGPoint, curve2: CGPoint)] {
		var pointArray = [(CGPoint, CGPoint, CGPoint)]()
		
		let marginXConstant = frame.width / 20
		let marginYConstant = frame.height / 25
		let mid = CGPoint(x: frame.width/2, y: frame.height * 0.3)
		//top right curve
		let rightArch = CGPoint(x: frame.width - marginXConstant, y: mid.y)
		let curve1C1 = CGPoint(x: mid.x + (rightArch.x - mid.x)/2, y: 0)
		let curve1C2 = CGPoint(x: frame.width - marginXConstant, y: 0)
		
		pointArray.append((rightArch, curve1C1, curve1C2))
		
		//top right to bottom
		let midBot = CGPoint(x: mid.x, y: frame.height - marginYConstant)
		let curve2C1 = CGPoint(x: rightArch.x, y: frame.height/2)
		let curve2C2 = CGPoint(x: mid.x + frame.width/10, y: midBot.y - frame.height/10)
		pointArray.append((midBot, curve2C1, curve2C2))
		
		//bottom to left arch
		let leftArch = CGPoint(x: 0 + marginXConstant, y: mid.y)
		let curve3C1 = CGPoint(x: mid.x - frame.width/10, y: midBot.y - frame.height/10)
		let curve3C2 = CGPoint(x: leftArch.x, y: frame.height/2)
		pointArray.append((leftArch, curve3C1, curve3C2))
		
		//left arch to mid
		let curve4C1 = CGPoint(x: 0 + marginXConstant, y: 0)
		let curve4C2 = CGPoint(x: mid.x - (mid.x - leftArch.x)/2, y: 0)
		pointArray.append((mid, curve4C1, curve4C2))
		
		return pointArray
	}
}
