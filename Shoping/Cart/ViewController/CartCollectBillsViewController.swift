//
//  CartCollectBillsViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/22.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import ZLCollectionViewFlowLayout

class CartCollectBillsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let height = ScreenWidth/414.0

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "凑单"
        let layout = ZLCollectionViewVerticalLayout()
        layout.delegate = self

        collectionView?.backgroundColor = UIColor.white
                      collectionView?.delegate = self
                      collectionView?.dataSource = self
                      self.view.addSubview(collectionView!)
                      // 注册cell
        collectionView?.register(UINib.init(nibName: "GoodsListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GoodsListCollectionViewCell")

    }

}
extension CartCollectBillsViewController: UICollectionViewDelegate, UICollectionViewDataSource, ZLCollectionViewBaseFlowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return   10
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:GoodsListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GoodsListCollectionViewCell", for: indexPath) as! GoodsListCollectionViewCell
//        cell.goodsImg.af_setImage(withURL: URL(string: (data?.data.products[indexPath.item].image)!)!)
//        cell.goodsName.text = data?.data.products[indexPath.item].name
//        cell.info.text = data?.data.products[indexPath.item].title
//        cell.price.text = "￥" + (data?.data.products[indexPath.item].price ?? "0") + " ￥\(data?.data.products[indexPath.item].oldPrice ?? "0")"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = 175*height
            let heightd = ga_heightForComment(fontSize: 17, width: width, text:  "")
            return CGSize(width: 195*height, height: heightd + 300)
    }

    func ga_heightForComment(fontSize: CGFloat, width: CGFloat, text: String) -> CGFloat {
         let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: text).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
         return ceil(rect.height)
     }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets.init(top: 0, left: 8*height, bottom: 0, right: 8*height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 14*height
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 5*height
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSize(width: 0, height: 20)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
