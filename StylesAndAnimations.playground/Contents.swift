//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

//let shadow: NSShadow = {
//	let s = NSShadow()
//	s.shadowColor = UIColor.black
//	s.shadowBlurRadius = 4.0
//	return s
//}()
//let attributes: [NSAttributedString.Key : Any] = [
//	.shadow: shadow,
//	.foregroundColor: #colorLiteral(red: 1, green: 0.8822258415, blue: 0.4357810227, alpha: 1),
//	.font: UIFont(name: "Noteworthy", size: 60)!
//]
//
//let title = NSMutableAttributedString(string: "Hi, Jon", attributes: attributes)

func createLoveLetters() -> String {
	let letters = "ABCDEFGHIJKILMNOPQRSTUVWXYZ"
	var l = String((0..<5).map({ _ in letters.randomElement()! }))
	return l
}


let label: UILabel = {
	let l = UILabel()
	l.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 300, height: 200))
	l.text = createLoveLetters()
	l.textAlignment = .center
	l.baselineAdjustment = .alignCenters
	l.backgroundColor = #colorLiteral(red: 0.6916132569, green: 0.5701339841, blue: 0.929064393, alpha: 1)
	return l
}()

PlaygroundPage.current.liveView = label

// Present the view controller in the Live View window
