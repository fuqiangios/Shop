//
//  VipProductTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/29.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class VipProductTableViewCell: UITableViewCell {

    @IBOutlet weak var gr: UIView!
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var line: UIImageView!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dacheng: UILabel!
    @IBOutlet weak var yichou: UILabel!
    @IBOutlet weak var zhichi: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        gr.layer.cornerRadius = 10
        gr.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
