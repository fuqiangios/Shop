//
//  CartCollectBillsViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/22.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import ZLCollectionViewFlowLayout
import MJRefresh

class CartCollectBillsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let height = ScreenWidth/414.0
    var order = ""
    var page = 1
    var data: ChangeCollectList? = nil
    var state: CollectStats? = nil
    var mony = "price_down" //price_up

    @IBOutlet weak var line: UILabel!
    @IBOutlet weak var goBack: UIButton!
    @IBOutlet weak var needPrice: UILabel!
    @IBOutlet weak var price: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "凑单"
        goBack.layer.cornerRadius = 45/2
        goBack.layer.masksToBounds = true
        goBack.addTarget(self, action: #selector(bacl), for: .touchUpInside)
        let layout = ZLCollectionViewVerticalLayout()
        layout.delegate = self

        collectionView?.backgroundColor = UIColor.white
                      collectionView?.delegate = self
                      collectionView?.dataSource = self
                      self.view.addSubview(collectionView!)
                      // 注册cell
        collectionView?.register(UINib.init(nibName: "GoodsListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GoodsListCollectionViewCell")
        collectionView?.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page = self.page + 1
            self.loadDataMore()
        })
        collectionView?.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            self.loadData()
        })
        loadData()

    }

    @objc func bacl() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func addCartl(btn: UIButton) {
        let item = data?.data.products[btn.tag - 100]
        API.addCart(product_id: item?.id ?? "", quantity: "1", product_option_union_id: item?.productOptionUnionID ?? "").request { (result) in
            switch result {
            case .success(let data):
                self.state = data.data.stats
                self.setBottom()
            case .failure(let error):
                CLProgressHUD.showError(in: self.view, delegate: self, title: "库存不足", duration: 1)
                print(error)
                print(error.self)
                print(error.localizedDescription)
            }
        }
    }

    @IBAction func type(_ sender: UIButton) {
        if sender.tag == 2 {
            if order == "" {
                order = "price_down"
                sender.setImage(UIImage(named: "价格降序"), for: .normal)
            } else if order == "price_down" {
                order = "price_up"
                sender.setImage(UIImage(named: "价格升序"), for: .normal)
            } else {
                order = "price_down"
                sender.setImage(UIImage(named: "价格降序"), for: .normal)
            }
        } else {
            order = ""
        }
        line.center = CGPoint(x: sender.center.x, y: sender.center.y + 18)
        loadData()
    }
    func loadData() {
        page = 1
        API.cartCollect(order: order, page: "\(page)").request { (result) in
            self.collectionView.mj_header?.endRefreshing()
            switch result {
            case .success(let data):
                self.data = data
                self.state = data.data.stats
                self.collectionView.reloadData()
                self.setBottom()
            case .failure(let er):
                print(er)
            }
        }
    }

    func loadDataMore() {
        API.cartCollect(order: order, page: "\(page)").request { (result) in
            self.collectionView.mj_footer?.endRefreshing()
            switch result {
            case .success(let data):
                var ar = self.data?.data.products ?? []
                ar = ar + data.data.products
                self.data = ChangeCollectList(result: true, message: "", status: 200, data: CollectDataClass(products: ar, stats: data.data.stats))
                self.state = data.data.stats
                self.collectionView.reloadData()
                self.setBottom()
            case .failure(let er):
                print(er)
            }
        }
    }

    func setBottom() {
        price.text = "合计: ￥\(state?.total ?? "0")"
        if state?.diffPrice ?? 0 > 0 {
            needPrice.text = "再购￥\(state?.diffPrice ?? 0)元免邮"
        } else {
            needPrice.text = "已免邮费"
        }
    }
}
extension CartCollectBillsViewController: UICollectionViewDelegate, UICollectionViewDataSource, ZLCollectionViewBaseFlowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.data.products.count ?? 0
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:GoodsListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GoodsListCollectionViewCell", for: indexPath) as! GoodsListCollectionViewCell
        cell.goodsImg.af_setImage(withURL: URL(string: (data?.data.products[indexPath.item].image)!)!)
        cell.goodsName.text = data?.data.products[indexPath.item].name
        cell.info.text = data?.data.products[indexPath.item].title
        cell.price.text = "￥" + (data?.data.products[indexPath.item].price ?? "0")
        cell.addCart.isHidden = false
        cell.addCart.tag = indexPath.item + 100
        cell.addCart.addTarget(self, action: #selector(addCartl(btn:)), for: .touchUpInside)
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
