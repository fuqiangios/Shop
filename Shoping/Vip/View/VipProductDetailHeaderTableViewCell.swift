//
//  VipProductDetailHeaderTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/29.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class VipProductDetailHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var allPeopleNum: UILabel!

    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var finshAmount: UILabel!
    @IBOutlet weak var allAmount: UILabel!
    @IBOutlet weak var jointPeopleNum: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
