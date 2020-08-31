//
//  LoveListTableTableViewController.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 6/18/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import UIKit
import FirebaseFirestore
@IBDesignable
class LoveListTableTableViewController: UITableViewController {
	
	var loveLettersArray: [(key: String, value: String)]!
	let dispatchGroup = DispatchGroup()
	
	lazy var activity: UIActivityIndicatorView = {
		let act = UIActivityIndicatorView(style: .large)
		act.hidesWhenStopped = true
		act.center = self.view.center
		return act
	}()
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Get data
		
		self.view.addSubview(activity)
		activity.startAnimating()
		Globals.user?.asyncPopulateLoveListWithUIDs() {
			self.loveLettersArray = Globals.user!.loveLetterDictionary.map({$0})
			self.activity.stopAnimating()
			self.tableView.reloadData()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Configure table appearance
		
		self.tableView!.frame.size.height = self.view.frame.size.height * 0.85
		self.tableView.separatorStyle = .none
		
		// Header
		
		self.tableView.tableHeaderView = {
			let image = UIImage(named: "My LoveList")
			let imageView = UIImageView(image: image)
			imageView.translatesAutoresizingMaskIntoConstraints = false
			imageView.contentMode = .scaleAspectFit
//			imageView.frame.size.height = image!.size.height
			return imageView
		}()
		let header = self.tableView.tableHeaderView!
		NSLayoutConstraint.activate([
			header.topAnchor.constraint(equalTo: self.tableView.topAnchor, constant: 16),
			header.leadingAnchor.constraint(equalTo: self.tableView.leadingAnchor, constant: 28),
			header.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
			header.trailingAnchor.constraint(equalTo: self.tableView.trailingAnchor, constant: 28)
		])
		
		print("Table header view: ", self.tableView.tableHeaderView)
		print("Header for section 0", self.tableView.headerView(forSection: 0))
		
		

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
	

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		return (Globals.user?.loveLetterDictionary.count ?? 0) + 1
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == Globals.user!.loveLetterDictionary.count {
			let cell = tableView.dequeueReusableCell(withIdentifier: "addNewUser", for: indexPath)
			return cell
		}
		let cell = tableView.dequeueReusableCell(withIdentifier: "loveListUser", for: indexPath)
		//main text
		let nameLabel = cell.contentView.viewWithTag(1) as! UILabel
		nameLabel.text = loveLettersArray[indexPath.row].value

		let letterLabel = cell.contentView.viewWithTag(2) as! UILabel
		letterLabel.text = "#" + loveLettersArray[indexPath.row].key
		return cell
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
			Globals.user?.asyncRemoveFromList(loveLettersArray[indexPath.row].key) {
				tableView.deleteRows(at: [indexPath], with: .fade)
			}
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
	@IBAction func showAddNewUser(_ sender: Any) {
		guard let addNewUserVC = self.storyboard?.instantiateViewController(identifier: "addUser") else {
			return
		}
		self.navigationController?.pushViewController(addNewUserVC, animated: false)
	}

	
	//MARK: Retrieve from DB
	let db = Firestore.firestore()
	
}
