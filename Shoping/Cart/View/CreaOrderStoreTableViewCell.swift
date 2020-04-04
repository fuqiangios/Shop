//
//  CreaOrderStoreTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/3/5.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class CreaOrderStoreTableViewCell: UITableViewCell {
    @IBOutlet weak var backVIew: UIView!

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var selectImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setShadow(view: backView, sColor: UIColor.init(white: 0.8, alpha: 1), offset: CGSize(width: 0, height: 0), opacity: 1, radius: 5)
        backView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

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
