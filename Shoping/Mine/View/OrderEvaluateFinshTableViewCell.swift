//
//  OrderEvaluateFinshTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/3/11.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class OrderEvaluateFinshTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLable: UILabel!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var star: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var goodsName: UILabel!
    @IBOutlet weak var goodsImg: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var coment: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
//        setShadow(view: backView, sColor: UIColor.init(white: 0.8, alpha: 1), offset: CGSize(width: 0, height: 0), opacity: 1, radius: 5)
            backView.layer.cornerRadius = 5
        userImg.layer.cornerRadius = 25
        userImg.layer.masksToBounds = true
        deleteBtn.layer.borderColor = UIColor.black.cgColor
        deleteBtn.layer.borderWidth = 1
        deleteBtn.layer.cornerRadius = 5
        deleteBtn.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
