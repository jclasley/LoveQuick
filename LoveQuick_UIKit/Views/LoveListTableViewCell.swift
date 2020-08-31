//
//  LoveListTableViewCell.swift
//  LoveQuick_UIKit
//
//  Created by Jonathan Lasley on 5/13/20.
//  Copyright © 2020 Jonathan Lasley. All rights reserved.
//

import UIKit

let pastelYellow = UIColor(displayP3Red: 246/255, green: 247/255, blue: 135/255, alpha: 1) //pale yellow

class LoveListTableViewCell: UITableViewCell {

	let userName: UILabel = {
		let lbl = UILabel()
		lbl.textColor = pastelYellow
		lbl.textAlignment = .left
		lbl.font = UIFont(name: "Bradley Hand", size: 20)
		return lbl
	}()
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.backgroundColor = .clear
		self.contentView.addSubview(userName)
		
		self.userName.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor,
							 paddingTop: 8, paddingLeft: 15, paddingBottom: 8, paddingRight: 15,
							 width: self.frame.width, height: self.frame.height, enableInsets: false)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

class TemplateCell: UITableViewCell {
	
	let templateLbl: UILabel = {
		let lbl = UILabel()
		lbl.text = "Add someone to your love list!"
		lbl.textColor = .white
		lbl.textAlignment = .left
		lbl.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .medium)
		return lbl
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.backgroundColor = .clear
		self.contentView.addSubview(templateLbl)
		self.templateLbl.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 15, paddingBottom: 8, paddingRight: 0, width: self.frame.width, height: self.frame.height, enableInsets: false)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
