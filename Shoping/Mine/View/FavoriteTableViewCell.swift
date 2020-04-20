//
//  FavoriteTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/17.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var width: NSLayoutConstraint!
    @IBOutlet weak var right: NSLayoutConstraint!
    @IBOutlet weak var left: NSLayoutConstraint!
    @IBOutlet weak var select: UIImageView!
    @IBOutlet weak var addCart: UIButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
