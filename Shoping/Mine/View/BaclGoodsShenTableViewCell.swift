//
//  BaclGoodsShenTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/16.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class BaclGoodsShenTableViewCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var bbtn: UIButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var option: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        bbtn.layer.borderWidth = 1
        bbtn.layer.borderColor = bbtn.tintColor.cgColor
        bbtn.layer.borderWidth = 1
        bbtn.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
