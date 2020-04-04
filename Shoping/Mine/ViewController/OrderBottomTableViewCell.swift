//
//  OrderBottomTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/28.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class OrderBottomTableViewCell: UITableViewCell {

    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setShadow(view: backView, sColor: UIColor.init(white: 0.8, alpha: 1), offset: CGSize(width: 0, height: 0), opacity: 1, radius: 5)
          backView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setBtn(tag: Int) {
        // 1待付款 2待发货 3待收货 4待评价 5完成
        switch tag {
        case 1:
            leftBtn.isHidden = true
            rightBtn.isHidden = false
            rightBtn.layer.borderColor = price.tintColor.cgColor
            rightBtn.layer.borderWidth = 1
            rightBtn.layer.cornerRadius = 5
            rightBtn.layer.masksToBounds = true
            rightBtn.setTitle("付款", for: .normal)
            rightBtn.setTitleColor(price.tintColor, for: .normal)
        case 2,3:
            leftBtn.isHidden = true
            rightBtn.isHidden = true
        case 4:
            leftBtn.isHidden = false
            leftBtn.layer.borderColor = UIColor.black.cgColor
            leftBtn.layer.borderWidth = 1
            leftBtn.layer.cornerRadius = 5
            leftBtn.layer.masksToBounds = true
            leftBtn.setTitleColor(.black, for: .normal)
            leftBtn.setTitle("查看物流", for: .normal)

            rightBtn.isHidden = false
            rightBtn.layer.borderColor = price.tintColor.cgColor
            rightBtn.layer.borderWidth = 1
            rightBtn.layer.cornerRadius = 5
            rightBtn.layer.masksToBounds = true
            rightBtn.setTitle("确认收货", for: .normal)
            rightBtn.setTitleColor(price.tintColor, for: .normal)
        case 5:
            leftBtn.isHidden = false
            leftBtn.layer.borderColor = UIColor.black.cgColor
            leftBtn.layer.borderWidth = 1
            leftBtn.layer.cornerRadius = 5
            leftBtn.layer.masksToBounds = true
            leftBtn.setTitleColor(.black, for: .normal)
            leftBtn.setTitle("删除", for: .normal)

            rightBtn.isHidden = false
            rightBtn.layer.borderColor = price.tintColor.cgColor
            rightBtn.layer.borderWidth = 1
            rightBtn.layer.cornerRadius = 5
            rightBtn.layer.masksToBounds = true
            rightBtn.setTitle("评论", for: .normal)
            rightBtn.setTitleColor(price.tintColor, for: .normal)
        default:
            rightBtn.isHidden = false
            rightBtn.layer.borderColor = UIColor.black.cgColor
            rightBtn.layer.borderWidth = 1
            rightBtn.layer.cornerRadius = 5
            rightBtn.layer.masksToBounds = true
            rightBtn.setTitleColor(.black, for: .normal)
            rightBtn.setTitle("删除", for: .normal)
        }
    }

    func setShadow(view:UIView,sColor:UIColor,offset:CGSize,
                   opacity:Float,radius:CGFloat) {
        //设置阴影颜色
        view.layer.shadowColor = sColor.cgColor
        //设置透明度
        view.layer.shadowOpacity = opacity
        //设置阴影半径
        view.layer.shadowRadius = radius
        //设置阴影偏移量
        view.layer.shadowOffset = offset
    }
    
}
