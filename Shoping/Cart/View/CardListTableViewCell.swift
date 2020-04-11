//
//  CardListTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/1/12.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class CardListTableViewCell: UITableViewCell {

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var reduceBtn: UIButton!
    @IBOutlet weak var backView: UIView!
    

    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

        addBtn.layer.borderColor = UIColor.init(red: 181.0/255.0, green: 182.0/255.0, blue: 183.0/255.0, alpha: 1).cgColor
        addBtn.layer.borderWidth = 1
        addBtn.layer.cornerRadius = 3
        addBtn.layer.masksToBounds = true

        reduceBtn.layer.borderColor = UIColor.init(red: 181.0/255.0, green: 182.0/255.0, blue: 183.0/255.0, alpha: 1).cgColor
        reduceBtn.layer.borderWidth = 1
        reduceBtn.layer.cornerRadius = 3
        reduceBtn.layer.masksToBounds = true

        textField.layer.borderColor = UIColor.init(red: 181.0/255.0, green: 182.0/255.0, blue: 183.0/255.0, alpha: 1).cgColor
        textField.layer.borderWidth = 1

        selectBtn.imageView?.contentMode = .scaleAspectFit
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

    func setSelect(select: Bool) {
        if select {
            selectBtn.setImage(UIImage(named: "ic_gouwu"), for: .normal)
        } else {
            selectBtn.setImage(UIImage(named: "ic_zhifu"), for: .normal)
        }
    }
}
