//
//  InviteGoodsViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/12/12.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class InviteGoodsViewController: UIViewController {
    @IBOutlet weak var topImage: UIImageView!

    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image1: UIImageView!

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var toGoodsDetailBtn: UIButton!
    @IBOutlet weak var salesNum: UILabel!
    @IBOutlet weak var oldPrice: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var goodsName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userIcon: UIImageView!
    var toGoodsDetail: ((Int) -> Void)!
    var data: InnviteGoods? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
        userIcon.layer.cornerRadius = 45/2
        userIcon.layer.masksToBounds = true
        toGoodsDetailBtn.layer.cornerRadius = 37/2
        toGoodsDetailBtn.layer.masksToBounds = true
        topImage.af_setImage(withURL: URL(string: (data?.data!.image)!)!)
        if data?.data?.images.count ?? 0 >= 1 {
            image1.af_setImage(withURL: URL(string: (data?.data?.images[0].image)!)!)
        }
        if data?.data?.images.count ?? 0 >= 2 {
            image2.af_setImage(withURL: URL(string: (data?.data?.images[1].image)!)!)
        }
        if data?.data?.images.count ?? 0 >= 3 {
            image3.af_setImage(withURL: URL(string: (data?.data?.images[2].image)!)!)
        }
        if data?.data?.images.count ?? 0 >= 4 {
            image4.af_setImage(withURL: URL(string: (data?.data?.images[3].image)!)!)
        }
        if let ig = data?.data!.userImage {
            userIcon.af_setImage(withURL: URL(string: (ig))!)
        }
        userName.text = data?.data?.userName
        goodsName.text = data?.data?.name
        info.text = data?.data?.recommendContent
        setPri(str: "￥\(data?.data?.price ?? "0.00")")
        salesNum.text = "销量: \(data?.data?.saleCnt ?? "0")"
        setOldPri(str: "￥\(data?.data?.oldPrice ?? "0.00")")
    }

    func setPri(str: String) {
        let fontAttr = NSMutableAttributedString(string: str)
        fontAttr.addAttribute(.font, value: UIFont.systemFont(ofSize: 10), range: NSRange(location: 0, length: 1))
        fontAttr.addAttribute(.baselineOffset, value: 5, range: NSRange(location: 0, length: 1))
        price.attributedText = fontAttr
    }

    func setOldPri(str: String) {
        let fontAttr = NSMutableAttributedString(string: str)
        fontAttr.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: str.count))
        oldPrice.attributedText = fontAttr
    }

    @IBAction func toDetailAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        toGoodsDetail(1)
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

}
