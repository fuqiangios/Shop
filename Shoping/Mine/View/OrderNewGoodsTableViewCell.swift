//
//  OrderNewGoodsTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/12.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class OrderNewGoodsTableViewCell: UITableViewCell {
    @IBOutlet weak var orderId: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var img0: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.borderWidth = 1
        bgView.layer.cornerRadius = 5
        bgView.layer.borderColor = UIColor.lineColor.cgColor

        leftBtn.layer.borderWidth = 1
        leftBtn.layer.borderColor = UIColor.graylineColor.cgColor

        rightBtn.layer.borderWidth = 1
        rightBtn.layer.borderColor = UIColor.graylineColor.cgColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setBtn(tag: Int) {
        // 1待付款 2待发货 3待收货 4待评价 5完成
        switch tag {
        case 1:
            leftBtn.isHidden = true
            rightBtn.isHidden = false
            rightBtn.layer.borderColor = rightBtn.tintColor.cgColor
            rightBtn.layer.borderWidth = 1
            rightBtn.layer.cornerRadius = 5
            rightBtn.layer.masksToBounds = true
            rightBtn.setTitle("付款", for: .normal)
//            rightBtn.setTitleColor(price.tintColor, for: .normal)
        case 2,3:
            leftBtn.isHidden = true
            rightBtn.isHidden = true
        case 4:
            leftBtn.isHidden = false
            leftBtn.layer.borderColor = rightBtn.tintColor.cgColor
            leftBtn.layer.borderWidth = 1
            leftBtn.layer.cornerRadius = 5
            leftBtn.layer.masksToBounds = true
            leftBtn.setTitle("查看物流", for: .normal)

            rightBtn.isHidden = false
            rightBtn.layer.borderColor = rightBtn.tintColor.cgColor
            rightBtn.layer.borderWidth = 1
            rightBtn.layer.cornerRadius = 5
            rightBtn.layer.masksToBounds = true
            rightBtn.setTitle("确认收货", for: .normal)
//            rightBtn.setTitleColor(price.tintColor, for: .normal)
        case 5:
            leftBtn.isHidden = false
            leftBtn.layer.borderColor = rightBtn.tintColor.cgColor
            leftBtn.layer.borderWidth = 1
            leftBtn.layer.cornerRadius = 5
            leftBtn.layer.masksToBounds = true
            leftBtn.setTitleColor(.black, for: .normal)
            leftBtn.setTitle("删除", for: .normal)

            rightBtn.isHidden = false
            rightBtn.layer.borderColor = rightBtn.tintColor.cgColor
            rightBtn.layer.borderWidth = 1
            rightBtn.layer.cornerRadius = 5
            rightBtn.layer.masksToBounds = true
            rightBtn.setTitle("评论", for: .normal)
//            rightBtn.setTitleColor(price.tintColor, for: .normal)
        default:
            leftBtn.isHidden = true
            rightBtn.isHidden = false
            rightBtn.layer.borderColor = rightBtn.tintColor.cgColor
            rightBtn.layer.borderWidth = 1
            rightBtn.layer.cornerRadius = 5
            rightBtn.layer.masksToBounds = true
            rightBtn.setTitleColor(.black, for: .normal)
            rightBtn.setTitle("删除", for: .normal)
        }
    }
    
}
