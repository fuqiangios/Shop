//
//  AddBackGoodsTypeTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/3/12.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class AddBackGoodsTypeTableViewCell: UITableViewCell {
    @IBOutlet weak var tui: UIButton!

    @IBOutlet weak var huan: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        tui.setImage(UIImage(named: "ic_gouwu"), for: .selected)
        huan.setImage(UIImage(named: "ic_gouwu"), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setSelect(tag: Int) {
        if tag == 1 {
            tui.isSelected = true
            huan.isSelected = false
        } else if tag == 2 {
            tui.isSelected = false
            huan.isSelected = true
        }
    }
}
