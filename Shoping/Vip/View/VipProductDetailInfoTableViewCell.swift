//
//  VipProductDetailInfoTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/29.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class VipProductDetailInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var web: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        web.scrollView.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
