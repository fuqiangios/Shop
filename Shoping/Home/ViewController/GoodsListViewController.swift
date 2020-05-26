//
//  GoodsListViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/1/3.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import ZLCollectionViewFlowLayout
import MJRefresh

class GoodsListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var data: CategoryList? = nil
    var category_id: String? = ""
    let Identifier       = "GoodsListCollectionViewCell"
    let headerBannerIdentifier = "CollectionBannerHeaderView"
    let headerTypeIdentifier = "CollectionTypeHeaderView"
    let height = ScreenWidth/414.0
    var order = ""
    var keyWord = ""
    var product_ids = ""
    var label_id = ""
    var label_code = ""
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "生活日语"
        self.navigationController?.navigationBar.isTranslucent = false
        setRightItem()
        setTableView()
        loadData()
    }

    func setTableView() {
        let layout = ZLCollectionViewVerticalLayout()
        layout.delegate = self

        collectionView.collectionViewLayout = layout
        collectionView?.backgroundColor = UIColor.white
                      collectionView?.delegate = self
                      collectionView?.dataSource = self
                      self.view.addSubview(collectionView!)
                      // 注册cell
        collectionView?.register(UINib.init(nibName: "GoodsListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Identifier)
                      // 注册headerView
        collectionView?.register(UINib.init(nibName: "SelectedBannerCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: headerBannerIdentifier)
        collectionView?.register(UINib.init(nibName: "SelectedTypeCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: headerTypeIdentifier)
        collectionView?.register(UINib.init(nibName: "SelectedFooterCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionFooter", withReuseIdentifier: "footer")
        collectionView?.register(UINib.init(nibName: "SelectedHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "header")
        collectionView?.register(UINib.init(nibName: "SelectedMoreCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "headerMore")
        collectionView?.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page = self.page + 1
            self.loadDataMore()
        })
        collectionView?.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            self.loadData()
        })
    }

    func setRightItem() {
        let rightBtn = UIButton(type: .custom)
        rightBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightBtn.setImage(UIImage(named: "search"), for: .normal)
        rightBtn.contentHorizontalAlignment = .right
        rightBtn.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
    }

    @objc func searchAction() {
        let search = GoodsSearViewController()
        self.navigationController?.pushViewController(search, animated: true)
    }

    func setSearBar() {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 30))
        titleView.layer.borderColor = UIColor.black.cgColor
        titleView.layer.borderWidth = 0.5
        titleView.layer.masksToBounds = true
        titleView.layer.cornerRadius = 10

        let seachText = UITextField(frame: CGRect(x: 10, y: 0, width: titleView.frame.size.width, height: 30))
        seachText.placeholder = "搜索商品"
        seachText.font = UIFont.systemFont(ofSize: 14)
        titleView.addSubview(seachText)

        self.navigationItem.titleView = titleView
    }

    func loadData() {
        page = 1
        API.homeCategoryData(p_category_id: label_code, category_id: category_id, order: order, key_word: keyWord,product_ids: product_ids,page: "\(page)",label_code:"", label_id: label_id)
            .request { (result) in
                self.collectionView.mj_header?.endRefreshing()
                switch result {
                case .success(let data):
                    self.data = data
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                    print(error.self)
                    print(error.localizedDescription)
                }
        }
    }

    func loadDataMore() {
        API.homeCategoryData(p_category_id: nil, category_id: category_id, order: order, key_word: keyWord,product_ids: product_ids,page: "\(page)", label_code:"", label_id: label_id)
            .request { (result) in
                self.collectionView.mj_footer?.endRefreshing()
                switch result {
                case .success(let data):
                    var ar = self.data?.data.products ?? []
                    ar = ar + data.data.products
                    self.data = CategoryList(result: true, message: "", status: 200, data: CategoryClass(products: ar, category_banner: self.data?.data.category_banner ?? []))
                    self.collectionView?.reloadData()
                case .failure(let error):
                    print(error)
                    print(error.self)
                    print(error.localizedDescription)
                }
        }
    }

    @IBAction func typeAction(_ sender: UIButton) {
        if sender.tag == 1 {
            order = ""
            let bt = view.viewWithTag(3)as!UIButton
            bt.setImage(UIImage(named: "价格升降序"), for: .normal)
        } else if sender.tag == 2 {
            order = "sale_down"
            let bt = view.viewWithTag(3)as!UIButton
            bt.setImage(UIImage(named: "价格升降序"), for: .normal)
        } else if sender.tag == 3 {
            if order == "price_down" {
                order = "price_up"
                sender.setImage(UIImage(named: "价格升序"), for: .normal)
            } else {
            order = "price_down"
                sender.setImage(UIImage(named: "价格降序"), for: .normal)
            }
        } else {
            order = "new_down"
            let bt = view.viewWithTag(3)as!UIButton
            bt.setImage(UIImage(named: "价格升降序"), for: .normal)
        }
        for index in 1...4 {
            let b = view.viewWithTag(index)as!UIButton
            b.setTitleColor(UIColor.darkText, for: .normal)
        }
        sender.setTitleColor(sender.tintColor, for: .normal)
        loadData()
    }
}
extension GoodsListViewController: UICollectionViewDelegate, UICollectionViewDataSource, ZLCollectionViewBaseFlowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.data.products.count ?? 0
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:GoodsListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier, for: indexPath) as! GoodsListCollectionViewCell
        if !(data?.data.products[indexPath.item].image ?? "").isEmpty {
        cell.goodsImg.af_setImage(withURL: URL(string: (data?.data.products[indexPath.item].image)!)!)
        }
        cell.goodsName.text = data?.data.products[indexPath.item].name
        cell.info.text = data?.data.products[indexPath.item].title
//        cell.price.text = "￥" + (data?.data.products[indexPath.item].price ?? "0")
        cell.setPri(str: "￥" + (data?.data.products[indexPath.item].price ?? "0"))

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = 175*height
            let heightd = ga_heightForComment(fontSize: 17, width: width, text: data?.data.products[indexPath.item].name ?? "")
            return CGSize(width: 195*height, height: 305)
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSize(width: 0, height: 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 20)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = GoodsDeatilViewController()
             detail.product_id = data?.data.products[indexPath.item].id ?? ""
            self.navigationController?.pushViewController(detail, animated: true)
    }
}

