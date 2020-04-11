//
//  GoodsListCollectionViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/16.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class GoodsListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var goodsImg: UIImageView!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var saleCount: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var goodsName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setShadow(view: backView, sColor: UIColor.init(white: 0.9, alpha: 1), offset: CGSize(width: 0, height: 0), opacity: 0.8, radius: 3)
        backView.layer.cornerRadius = 5
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
