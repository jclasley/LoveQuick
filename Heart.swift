//
//  Heart.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 4/17/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import UIKit


struct HeartShape {
	var frame: CGRect
	internal let stopOne = UIColor(displayP3Red: 230/255, green: 117/255, blue: 255/255, alpha: 1.0)
	internal let stopTwo = UIColor(displayP3Red: 190/255, green: 25/255, blue: 227/255, alpha: 1.0)
	internal var gradient = CAGradientLayer()
	public var heartShape = CAShapeLayer()
	
	init(frame: CGRect) {
		self.frame = frame
		self.heartShape = getLayer()
		self.createGradientLayer()
	}
	
	func createGradientLayer() {
		self.gradient.shadowPath = createHeart(in: frame).cgPath
		self.gradient.colors = [stopOne.cgColor, stopTwo.cgColor]
		gradient.frame = frame
		gradient.startPoint = CGPoint(x: 0, y: 0)
		gradient.position = CGPoint(x: 0, y: 0)
		gradient.mask = heartShape
		gradient.shadowRadius = 2
		gradient.shadowColor = UIColor.gray.cgColor
		gradient.shadowOpacity = 0.8
		
	}
	
	func createShadow() -> CAShapeLayer {
		let color = UIColor.black.cgColor
		//resize
		let shadowShape = CAShapeLayer()
		shadowShape.mask = heartShape
		shadowShape.fillColor = color
		
		return shadowShape
		
	}
	
	func getLayer() -> CAShapeLayer {
			let shapeLayer = CAShapeLayer()
			
		shapeLayer.path = createHeart(in: frame).cgPath
		shapeLayer.strokeColor = UIColor.red.cgColor
		shapeLayer.lineWidth = 3
		shapeLayer.position = CGPoint(x: 0, y: 0)
		return shapeLayer
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
}
