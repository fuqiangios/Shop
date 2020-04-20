//
//  AddressListTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/1/31.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class AddressListTableViewCell: UITableViewCell {

    @IBOutlet weak var lb: UILabel!
    @IBOutlet weak var defaultHeight: NSLayoutConstraint!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var isDefault: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
//        setShadow(view: backView, sColor: UIColor.init(white: 0.8, alpha: 1), offset: CGSize(width: 0, height: 0), opacity: 1, radius: 5)
//        backView.layer.cornerRadius = 5
        isDefault.layer.cornerRadius = 5
        isDefault.layer.masksToBounds = true
        isDefault.layer.borderWidth = 1
        isDefault.layer.borderColor = UIColor.red.cgColor
        isDefault.textColor = .red
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
