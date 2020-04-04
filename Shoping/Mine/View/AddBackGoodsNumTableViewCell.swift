//
//  AddBackGoodsNumTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/3/12.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class AddBackGoodsNumTableViewCell: UITableViewCell {
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var reduceBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
//        setShadow(view: backView, sColor: UIColor.init(white: 0.8, alpha: 1), offset: CGSize(width: 0, height: 0), opacity: 1, radius: 5)
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
