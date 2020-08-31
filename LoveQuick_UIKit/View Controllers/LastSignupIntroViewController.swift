//
//  LastSignupIntroViewController.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 7/12/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import UIKit

class LastSignupIntroViewController: UIViewController {

	@IBOutlet weak var bigText: UIImageView!
	override func viewDidLoad() {
        super.viewDidLoad()
		bigText.hero.modifiers = [ .fade]

        // Do any additional setup after loading the view.
    }
    
	@IBAction func goToMain(_ sender: Any) {
		guard let mainVC = self.storyboard?.instantiateViewController(identifier: "loadingVC") else {
			return
		}
		UserDefaults.standard.set(true, forKey: "launchedBefore")
		self.navigationController?.heroReplaceViewController(with: mainVC)
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
