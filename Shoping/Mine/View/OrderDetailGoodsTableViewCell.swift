//
//  OrderDetailGoodsTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/3/3.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class OrderDetailGoodsTableViewCell: UITableViewCell {
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var shipingPrice: UILabel!
    @IBOutlet weak var youhuiPrice: UILabel!
    @IBOutlet weak var discountPrice: UILabel!
    @IBOutlet weak var goodPrice: UILabel!
    @IBOutlet weak var returnBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
//        shadowsLeftRight()
//        returnBtn.layer.cornerRadius = 5
//        returnBtn.layer.borderColor = returnBtn.tintColor.cgColor
//        returnBtn.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

    func shadowsLeftRight() {
    //        [_shaowView viewShadowPathWithColor:[UIColor redColor] shadowOpacity:0.5 shadowRadius:5 shadowPathType:shaowBtn.tag shadowPathWidth:10]
            backView.viewShadowPath(with: UIColor.init(white: 0.8, alpha: 1), shadowOpacity: 0.5, shadowRadius: 5, shadowPathType: .common, shadowPathWidth:7, width: ScreenWidth - 22)
    //        backView.viewShadowPath(with: UIColor.init(white: 0.8, alpha: 1), shadowOpacity: 0.7, shadowRadius: 1, shadowPathType: .right, shadowPathWidth: 7)
    }
}
