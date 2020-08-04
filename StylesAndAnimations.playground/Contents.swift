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
	let l = String((0..<5).map({ _ in letters.randomElement()! }))
	return l
}

func deg2rad(_ number: CGFloat) -> CGFloat {
    return number * .pi / 180
}

let view = UIView()
view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
view.backgroundColor = UIColor.blue
view.transform = CGAffineTransform(rotationAngle: deg2rad(-10))

PlaygroundPage.current.liveView = view

// Present the view controller in the Live View window
