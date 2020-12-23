//
//  MinToolTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/21.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class MinToolTableViewCell: UITableViewCell {
    @IBOutlet weak var btn1: UIButton!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var backGroundView: UIView!
    
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn5: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
//        setShadow(view: backGroundView, sColor: UIColor.init(white: 0.8, alpha: 1), offset: CGSize(width: 0, height: 0), opacity: 1, radius: 5)
//        backGroundView.layer.cornerRadius = 5
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
