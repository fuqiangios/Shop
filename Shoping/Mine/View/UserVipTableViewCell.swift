//
//  UserVipTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/5/19.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class UserVipTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var UserView: UIView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var yue: UILabel!
    @IBOutlet weak var jifen: UILabel!
    @IBOutlet weak var hongbao: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var fensi: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        UserView.layer.cornerRadius = 5
        UserView.layer.borderWidth = 1
        UserView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        UserView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
