//
//  LoveListViewController.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 6/13/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import UIKit

class LoveListViewController: UINavigationController {
	let blur = UIBlurEffect(style: .regular)
	let effectView = UIVisualEffectView()
	@IBOutlet weak var containerView: UIView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		effectView.effect = blur
		effectView.frame = self.view.frame
		

        // Do any additional setup after loading the view.
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
