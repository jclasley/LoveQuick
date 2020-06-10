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
	
	let dispatch = DispatchGroup()
	
}


// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
