//
//  Animations.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 8/3/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

struct CustomAnimations {
	
	static let emptyHeart = UIImageView(image: UIImage(named: "heartOutline"))

	static func growWiggleLeave(view: UIView) {
		guard Globals.user!.isAbleToSendLove else {
			return
		}
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
				emptyHeart.frame = view.frame
				view.superview!.addSubview(emptyHeart)
			})
			}
		)
	}
	
	static func fallingHeartsAnimation (view tappedView: UIView) {
		guard let superview = tappedView.superview else {
			print("Failure. Tapped view \(tappedView)")
			return
		}
		guard Globals.user!.isAbleToSendLove else {
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
				})
			}, completion: { _ in
				tappedView.isHidden = true
				tappedView.transform = CGAffineTransform(scaleX: 1, y: 1)
				tappedView.center = superview.center
				randomHearts.removeFromSuperview()
				DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
					l.removeFromSuperview()
					emptyHeart.frame = tappedView.frame
					emptyHeart.translatesAutoresizingMaskIntoConstraints = false
					
					addBlockOverHeart(tappedView)
					tappedView.superview!.addSubview(emptyHeart)
					NSLayoutConstraint.activate([
						emptyHeart.topAnchor.constraint(equalTo: tappedView.topAnchor),
						emptyHeart.leadingAnchor.constraint(equalTo: tappedView.leadingAnchor),
						emptyHeart.centerXAnchor.constraint(equalTo: tappedView.centerXAnchor),
						emptyHeart.bottomAnchor.constraint(equalTo: tappedView.bottomAnchor)
					])
					emptyHeart.contentMode = .scaleAspectFit
					tappedView.isHidden = false
					addTimer(over: tappedView)
				})
			} )
		
	}
	
	static private func createRandomHeartLocations(in view: UIView) -> UIView {
		
			let v = UIView()
			v.frame = view.frame
			v.frame.size.height *= 2
			v.backgroundColor = .clear
			
			for num in 0...19 {
				let h = UIImageView(image: UIImage(named: "DrawnHeart"))
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
	
	static let totalTime: Int = 30
	static var totalTimePast: Int = 0
	static let timeText = PublishSubject<String>()
	
	static let heartCover = UIView()
	static func addBlockOverHeart(_ heart: UIView) {
		heartCover.frame = heart.frame
		heartCover.backgroundColor = heart.superview!.backgroundColor
		heart.superview!.addSubview(heartCover)
		NSLayoutConstraint.activate([
			heartCover.topAnchor.constraint(equalTo: heart.topAnchor),
			heartCover.bottomAnchor.constraint(equalTo: heart.bottomAnchor),
			heartCover.leadingAnchor.constraint(equalTo: heart.leadingAnchor),
			heartCover.trailingAnchor.constraint(equalTo: heart.trailingAnchor)
		])
		heartCover.setAnchorPoint(CGPoint(x:0.5,y:0))
		initialHeartCoverHeight = heartCover.frame.height
	}
	
	static var initialHeartCoverHeight: CGFloat = 0
	static func addTimer(over v: UIView) {
		let timerLabel = UILabel()
		timerLabel.frame = CGRect(x: 0, y: 0, width: 50, height: 25)
		timerLabel.textAlignment = .center
		timerLabel.backgroundColor = .clear
		_ = CustomAnimations.timeText.bind(to: timerLabel.rx.text)
		v.superview!.addSubview(timerLabel)
		timerLabel.center = CGPoint(x: v.center.x, y: v.frame.minY)

//		Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
//			if totalTimePast < totalTime {
//				// Reduce height of covering block
//
////				heartCover.transform = CGAffineTransform(scaleX: 1, y: 1)
//				CustomAnimations.totalTimePast += 1
//				let min = Int((CustomAnimations.totalTime - CustomAnimations.totalTimePast) / 60)
//				let sec = (CustomAnimations.totalTime - CustomAnimations.totalTimePast) % 60
//				CustomAnimations.timeText.onNext("\(min >= 10 ? min.description : "0" + min.description):\(sec >= 10 ? sec.description : "0" + sec.description)")
//				heartCover.frame.size.height = initialHeartCoverHeight - (CGFloat(initialHeartCoverHeight/CGFloat(CustomAnimations.totalTime))*CGFloat(CustomAnimations.totalTimePast))
//			}
//			else {
//				Globals.user!.isAbleToSendLove = true
//				heartCover.removeFromSuperview()
//				timerLabel.removeFromSuperview()
//				resetTotalTime()
//				timer.invalidate()
//			}
//		})
		
		
	}
	static func resetTotalTime() {
		totalTimePast = 0
	}
	
	//TODO: Add in more animations
	//1. Heart starts spinning and growing, background fades to red, "Love sent" grows from center
	//2.
	//3.
	//4.
}
