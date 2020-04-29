//
//  AddEvaluateGoodsTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/3/10.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class AddEvaluateGoodsTableViewCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var star: StarEvaluateView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
