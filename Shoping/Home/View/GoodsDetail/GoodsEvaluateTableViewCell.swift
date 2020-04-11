//
//  GoodsEvaluateTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/1/8.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class GoodsEvaluateTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var imgLayout: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.layer.cornerRadius = 25
        userImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
