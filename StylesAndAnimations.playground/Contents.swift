//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

let calendar = Calendar.current
let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: Date(timeIntervalSinceNow: 60*60))
var nowComponents = calendar.dateComponents([.hour, .minute, .second], from: Date())
let difference = calendar.dateComponents([.minute, .second], from: nowComponents, to: timeComponents)
DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
	nowComponents = calendar.dateComponents([.hour, .minute, .second], from: Date())
	print(calendar.dateComponents([.minute, .second], from: nowComponents, to: timeComponents))
} )
// Present the view controller in the Live View window
