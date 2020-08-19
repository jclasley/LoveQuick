//
//  Animations.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 8/3/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import Foundation
import UIKit

struct CustomAnimations {

	static func growWiggleLeave(view: UIView) {
		let center = view.center
		view.setAnchorPoint(CGPoint(x: 0.5, y: 1))
		let l = UILabel()
		l.text = "Love sent!"
		l.font = UIFont(name: "Futura", size: 20)
		l.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
		l.textAlignment = .center
		l.center = CGPoint(x: view.superview!.center.x - 500, y: view.superview!.center.y) //have to use superview because anchor point change throws off the center
		print(l.center)
		view.superview?.addSubview(l)
		
		UIView.animateKeyframes(withDuration: 2.5, delay: 0, options: .calculationModeCubic, animations: {
			UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1, animations: {
				view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
			})
			UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.1, animations: {
				view.transform = CGAffineTransform(scaleX: 1, y: 1)
			})
			UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.1, animations: {
				view.transform = CGAffineTransform(rotationAngle: deg2rad(-30))
			})
			UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.1, animations: {
				view.transform = CGAffineTransform(rotationAngle: deg2rad(30))
			})
			UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.1, animations: {
				view.transform = CGAffineTransform(rotationAngle: deg2rad(-15))
			})
			UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.1, animations: {
				view.transform = CGAffineTransform(rotationAngle: deg2rad(15))
			})
			UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.1, animations: {
				view.transform = CGAffineTransform(rotationAngle: deg2rad(0))
			})
			UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.1, animations: {
				view.transform = CGAffineTransform(scaleX: 1, y: 1)
			})
			UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1, animations: {
				view.setAnchorPoint(CGPoint(x: 0.5, y: 0.5))
				l.center.x += 500
				view.center.x += 500
			})
			
		}, completion: { _ in
			view.isHidden = true
			view.transform = CGAffineTransform(scaleX: 1, y: 1)
			view.center = center
			DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
				l.removeFromSuperview()
			})
			}
		)
	}
	
	static func fallingHeartsAnimation (view tappedView: UIView) {
		guard let superview = tappedView.superview else {
			print("Failure. Tapped view \(tappedView)")
			return
		}
		print(tappedView.superview.debugDescription)
		let randomHearts = CustomAnimations.createRandomHeartLocations(in: tappedView.superview!)
		let offscreenOrigin = randomHearts.frame.origin
		let l = UILabel()

			UIView.animateKeyframes(withDuration: 4, delay: 0, options: .calculationModeCubic, animations: {
				UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1, animations: {
					tappedView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3) //shrink down
				})
				UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.1, animations: {
					tappedView.center.y += tappedView.superview!.frame.height
				})
				UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.7, animations: {
					
					l.text = "Love sent!"
					l.font = UIFont(name: "Futura", size: 20)
					l.frame = CGRect(origin: offscreenOrigin, size: CGSize(width: superview.frame.width, height: 50))
					print(l.frame.origin)
					l.textAlignment = .center
					superview.addSubview(l)
					l.center = superview.center
					
					superview.addSubview(randomHearts)
					randomHearts.transform = CGAffineTransform(translationX: 0, y: randomHearts.frame.height * 2.02)
					print("Multiplication", randomHearts.frame.height * 2.02)
					print("Substracting center Ys", superview.center.y - randomHearts.center.y)
				})
			}, completion: { _ in
				tappedView.isHidden = true
				tappedView.transform = CGAffineTransform(scaleX: 1, y: 1)
				tappedView.center = superview.center
				randomHearts.removeFromSuperview()
				DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
					l.removeFromSuperview()
				})
			} )
		
	}
	
	static private func createRandomHeartLocations(in view: UIView) -> UIView {
		
			let v = UIView()
			v.frame = view.frame
			v.frame.size.height *= 2
			v.backgroundColor = .clear
			
			for num in 0...19 {
				let h = UIImageView(image: UIImage(named: "drawnHeart"))
				h.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
				switch num {
					case 0...4: //quadrant 1
						h.center = CGPoint(x: CGFloat.random(in: v.frame.minX...v.frame.midX),
										   y: CGFloat.random(in: v.frame.minY...v.frame.midY))
					case 5...9: //quadrant 2
						h.center = CGPoint(x: CGFloat.random(in: v.frame.midX...v.frame.maxX),
										   y: CGFloat.random(in: v.frame.minY...v.frame.midY))
					case 10...14: //quadrant 3
						h.center = CGPoint(x: CGFloat.random(in: v.frame.minX...v.frame.midX),
										   y: CGFloat.random(in: v.frame.midY...v.frame.maxY))
					case 15...19: //quadrant 4
						h.center = CGPoint(x: CGFloat.random(in: v.frame.midX...v.frame.maxX),
										   y: CGFloat.random(in: v.frame.midY...v.frame.maxY))
					default:
						break
				}
				v.addSubview(h)
			}
			v.frame.origin = CGPoint(x: 0, y: -1.02 * v.frame.height)
			return v
		
	}
	
	//TODO: Add in more animations
	//1. Heart starts spinning and growing, background fades to red, "Love sent" grows from center
	//2.
	//3.
	//4.
}
