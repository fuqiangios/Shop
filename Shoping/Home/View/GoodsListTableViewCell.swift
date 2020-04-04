//
//  GoodsListTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/1/3.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class GoodsListTableViewCell: UITableViewCell {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setPrice()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setPrice() {
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 28)!,
            NSAttributedString.Key.foregroundColor: UIColor.red
        ]
        let attributesR: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.red
        ]
        let attrName = NSMutableAttributedString(string: "￥200    200人付款")
        attrName.addAttributes(attributes, range: NSRange.init(location: 1, length: 3))
        attrName.addAttributes(attributesR, range: NSRange.init(location: 0, length: 1))
        priceLabel.attributedText = attrName
    }
    
}
