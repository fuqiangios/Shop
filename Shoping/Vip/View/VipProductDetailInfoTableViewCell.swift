//
//  VipProductDetailInfoTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/29.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class VipProductDetailInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var yichou: UILabel!
    
    @IBOutlet weak var webHei: NSLayoutConstraint!
    @IBOutlet weak var lineHei: NSLayoutConstraint!
    @IBOutlet weak var web: UIWebView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var dacheng: UILabel!
    @IBOutlet weak var zhichi: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
