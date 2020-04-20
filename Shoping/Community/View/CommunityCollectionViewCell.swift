//
//  CommunityCollectionViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/19.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class CommunityCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var redNum: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 10
        backView.layer.masksToBounds = true
        userImg.layer.cornerRadius = 13
        userImg.layer.masksToBounds = true
    }

}
