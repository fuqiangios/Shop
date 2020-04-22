//
//  TypeCollectionViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/20.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class TypeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .white
//        setShadow(view: backGroundView, sColor: UIColor.init(white: 0.8, alpha: 1), offset: CGSize(width: 1, height: 1), opacity: 1, radius: 5)

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
