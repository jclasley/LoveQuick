//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

let shadow: NSShadow = {
	let s = NSShadow()
	s.shadowColor = UIColor.black
	s.shadowBlurRadius = 4.0
	return s
}()
let attributes: [NSAttributedString.Key : Any] = [
	.font: UIFont(name: "MarkerFelt-Thin", size: 32) as Any,
//	.shadow: shadow,
	.foregroundColor: #colorLiteral(red: 1, green: 0.8822258415, blue: 0.4357810227, alpha: 1),
	.strokeColor: #colorLiteral(red: 0.2767290609, green: 0.2767290609, blue: 0.2767290609, alpha: 1),
	.strokeWidth: -2.0,
	.kern: -3.0,
]

let title = NSMutableAttributedString(string: "Your LoveList", attributes: attributes)
title.setAttributes([NSAttributedString.Key.kern: 3.0], range: NSRange(location: 4, length: 1))


let label: UILabel = {
	let l = UILabel()
	l.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 300, height: 48))
	l.attributedText = title
	l.textAlignment = .center
	l.baselineAdjustment = .alignCenters
	l.backgroundColor = #colorLiteral(red: 0.6916132569, green: 0.5701339841, blue: 0.929064393, alpha: 1)
	return l
}()

PlaygroundPage.current.liveView = label

// Present the view controller in the Live View window
