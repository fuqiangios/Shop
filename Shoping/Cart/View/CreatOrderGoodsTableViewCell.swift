//
//  CreatOrderGoodsTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/1/30.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class CreatOrderGoodsTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var evaluateBtn: UIButton!
    @IBOutlet weak var bottomc: NSLayoutConstraint!
    @IBOutlet weak var topc: NSLayoutConstraint!

    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        evaluateBtn.layer.borderColor = evaluateBtn.tintColor.cgColor
        evaluateBtn.layer.borderWidth = 1
        evaluateBtn.layer.cornerRadius = 3
    }

    func shadow() {
        topc.constant = 6
        bottomc.constant = 6
        setShadow(view: backView, sColor: UIColor.init(white: 0.8, alpha: 1), offset: CGSize(width: 0, height: 0), opacity: 1, radius: 5)
        backView.layer.cornerRadius = 5
    }

    func applyCurvedShadow() {
    let size = backView.bounds.size
    let width = size.width
    let height = size.height
    let path = UIBezierPath()
    path.move(to: CGPoint(x: width, y: 0))
//    path.addLine(to: CGPoint(x: width - 3, y: 0))
//    path.addLine(to: CGPoint(x: width + 3, y: height))
    path.addLine(to: CGPoint(x:0, y: height))
    path.close()
    let layer = backView.layer
    layer.shadowPath = path.cgPath
    layer.shadowColor = UIColor.init(white: 0.8, alpha: 1).cgColor
    layer.shadowOpacity = 1
    layer.shadowRadius = 5
    layer.shadowOffset = CGSize(width: 0, height: 0)
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

    func shadowsLeftRight() {
//        [_shaowView viewShadowPathWithColor:[UIColor redColor] shadowOpacity:0.5 shadowRadius:5 shadowPathType:shaowBtn.tag shadowPathWidth:10]
        backView.viewShadowPath(with: UIColor.init(white: 0.8, alpha: 1), shadowOpacity: 0.5, shadowRadius: 5, shadowPathType: .common, shadowPathWidth:7, width: ScreenWidth - 22)
//        backView.viewShadowPath(with: UIColor.init(white: 0.8, alpha: 1), shadowOpacity: 0.7, shadowRadius: 1, shadowPathType: .right, shadowPathWidth: 7)
    }

        func shadowsLeftRightTop() {
            topc.constant = 6
            backView.viewShadowPath(with: UIColor.init(white: 0.8, alpha: 1), shadowOpacity: 0.5, shadowRadius: 5, shadowPathType: .common, shadowPathWidth:7, width: ScreenWidth - 22)
    //        backView.viewShadowPath(with: UIColor.init(white: 0.8, alpha: 1), shadowOpacity: 0.7, shadowRadius: 1, shadowPathType: .right, shadowPathWidth: 7)
        }
}
