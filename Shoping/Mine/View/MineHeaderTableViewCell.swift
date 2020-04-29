//
//  MineHeaderTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/21.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class MineHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var lineBackView: UIView!

    @IBOutlet weak var barCode: UIButton!
    
    @IBOutlet weak var message: UIButton!
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var discountBtn: UIButton!
    @IBOutlet weak var priceBtn: UIButton!
    @IBOutlet weak var redPackgBtn: UIButton!
    @IBOutlet weak var pointBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
//        setShadow(view: lineBackView, sColor: UIColor.init(white: 0.8, alpha: 1), offset: CGSize(width: 1, height: 1), opacity: 1, radius: 5)
//        lineBackView.layer.cornerRadius = 5
        img.layer.borderWidth = 2
        img.layer.borderColor = UIColor.white.cgColor
        img.layer.cornerRadius = 35
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
