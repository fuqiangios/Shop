//
//  OrderDetailNumTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/3/4.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class OrderDetailNumTableViewCell: UITableViewCell {

    @IBOutlet weak var retuenDate: UILabel!
    @IBOutlet weak var payDate: UILabel!
    @IBOutlet weak var creatDate: UILabel!
    @IBOutlet weak var orderNum: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setShadow(view: backView, sColor: UIColor.init(white: 0.8, alpha: 1), offset: CGSize(width: 0, height: 0), opacity: 1, radius: 5)
        backView.layer.cornerRadius = 5
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
