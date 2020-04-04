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
    
    @IBOutlet weak var saleCount: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var goodsName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
