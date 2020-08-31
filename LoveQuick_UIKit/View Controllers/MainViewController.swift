//
//  MainViewController.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 4/30/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
	
	var heartUpperBound: CGFloat!
	
	@IBOutlet weak var heartView: HeartView!
	@IBOutlet weak var envelope: EnvelopeView!
	override func viewDidLoad() {
        super.viewDidLoad()
		
		view.setNeedsDisplay()
		createPanRecognizer(forView: heartView)
//		heartView.setAnchorPoint(CGPoint(x: 0.5, y: 1)) //set anchor point to middle bottom so it shrinks into envelope
		heartView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
		heartUpperBound = heartView.frame.origin.y
    }
    
	func createPanRecognizer(forView targetView: UIView) {
		let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanRecognizer(recognizer:)))
		panRecognizer.minimumNumberOfTouches = 1
		targetView.addGestureRecognizer(panRecognizer)
	}
	
	@objc func handlePanRecognizer(recognizer: UIPanGestureRecognizer) {
		let translation = recognizer.translation(in: self.view)
		let targetView = recognizer.view!
		let targetViewCenter = targetView.center
		
		
		switch recognizer.state {
			
			case .began, .changed:
				let newPosition = CGPoint(x: targetView.center.x, y: targetViewCenter.y + translation.y)
				let dragPercentDiff = 1 - (translation.y) / 100
				envelope.isHidden = false
				if newPosition.y > heartUpperBound {
					guard dragPercentDiff >= 0 && dragPercentDiff <= 1 else {
						return
					}
					targetView.transform = CGAffineTransform(scaleX: dragPercentDiff, y: dragPercentDiff)
			}
			case .ended:
				envelope.isHidden = true
				recognizer.setTranslation(.zero, in: view)
				targetView.transform = CGAffineTransform(scaleX: 1, y: 1)
				break
			default:
				break
		}
		
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: anchor point
extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = point
    }
}
