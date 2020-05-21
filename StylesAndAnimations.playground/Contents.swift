//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
		
		let button = ThreeBarButton(x: 50, y: 50, height: 20)
		button.backgroundColor = .white
		view.addSubview(button)
		self.view = view
    }
}

class ThreeBarButton : UIButton {
	
	init(x: CGFloat, y: CGFloat, height: CGFloat) {
		super.init(frame: CGRect(x: x, y: y, width: height*1.5, height: height))
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func draw(_ rect: CGRect) {
		let lines: [UIBezierPath] = {
			var paths = [UIBezierPath]()
			for offset in 0...4 {
				let partialRect = CGRect(x: rect.origin.x, y: rect.origin.y + CGFloat(offset*Int(rect.height)/5), width: rect.width, height: rect.height/5)
				let line = CGPath(rect: partialRect, transform: nil)
				let bezierLine = UIBezierPath(cgPath: line)
				paths.append(bezierLine)
			}
			return paths
		}()
		for i in 0..<lines.count {
			if i % 2 == 0 {
				lines[i].fill()
			}
		}
	}
	
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
