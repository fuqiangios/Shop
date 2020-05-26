//
//  AhioTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/5/20.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class AhioTableViewCell: UITableViewCell {
    @IBOutlet weak var bennnianyeji: UILabel!
    @IBOutlet weak var shangyueyeji: UILabel!
    @IBOutlet weak var benyueyeji: UILabel!
    @IBOutlet weak var zuoriyeji: UILabel!
    @IBOutlet weak var friendNum: UILabel!
    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var ci: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
//        ci.layer.borderColor = UIColor.darkText.cgColor
//        ci.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
