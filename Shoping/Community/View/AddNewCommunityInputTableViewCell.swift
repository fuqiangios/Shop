//
//  AddNewCommunityInputTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/19.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class AddNewCommunityInputTableViewCell: UITableViewCell {

    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
