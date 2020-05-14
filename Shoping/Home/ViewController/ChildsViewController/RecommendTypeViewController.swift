//
//  SelectedViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2019/12/25.
//  Copyright © 2019 付强. All rights reserved.
//

import UIKit
import ZLCollectionViewFlowLayout
import FSPagerView
import MJRefresh

class RecommendTypeViewController: UIViewController {
    var collectionView : UICollectionView?
    var page = 1
//    @IBOutlet weak var collectionView: UICollectionView!

    let Identifier       = "GoodsListCollectionViewCell"
    let headerBannerIdentifier = "CollectionBannerHeaderView"
    let headerTypeIdentifier = "CollectionTypeHeaderView"
    let height = ScreenWidth/414.0
    var data: CategoryList? = nil
    let categoryId: String
    
    var didSelectCell: ((String) -> Void)?

    init(categoryId: String) {
        self.categoryId = categoryId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    func loadData() {
        page = 1
        API.homeCategoryData(p_category_id: categoryId, category_id: nil, page: "\(page)").request { (response) in
            self.collectionView?.mj_header?.endRefreshing()
            switch response {
            case .success(let list):
                self.data = list
                self.collectionView?.reloadData()
            case .failure(let error):
                print(error)
                print(error.self)
                print(error.localizedDescription)
            }
        }
    }

    func loadDataMore() {
        API.homeCategoryData(p_category_id: categoryId, category_id: nil, page: "\(page)").request { (response) in
            self.collectionView?.mj_footer?.endRefreshing()
            switch response {
            case .success(let list):
                var ar = self.data?.data.products ?? []
                ar = ar + list.data.products
                self.data = CategoryList(result: true, message: "", status: 200, data: CategoryClass(products: ar, category_banner: self.data?.data.category_banner ?? []))
                self.collectionView?.reloadData()
            case .failure(let error):
                print(error)
                print(error.self)
                print(error.localizedDescription)
            }
        }
    }

    func setView(ehigth: Float)  {
        let layout = ZLCollectionViewVerticalLayout()
        layout.delegate = self

        collectionView = UICollectionView.init(frame: CGRect(x:0, y:0, width:view.frame.size.width, height:CGFloat(ehigth)), collectionViewLayout: layout)
        collectionView?.backgroundColor = UIColor.white
                      collectionView?.delegate = self
                      collectionView?.dataSource = self
                      self.view.addSubview(collectionView!)
        collectionView?.snp.makeConstraints({ (make) in
                    make.top.left.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                })
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
}

extension RecommendTypeViewController: UICollectionViewDelegate, UICollectionViewDataSource, ZLCollectionViewBaseFlowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.data.products.count ?? 0
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:GoodsListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier, for: indexPath) as! GoodsListCollectionViewCell
        if let im = data?.data.products[indexPath.item].image, im != "" {
            cell.goodsImg.af_setImage(withURL: URL(string: im)!)
        }

        cell.goodsName.text = data?.data.products[indexPath.item].name
        cell.info.text = data?.data.products[indexPath.item].title
        cell.price.text = "￥" + (data?.data.products[indexPath.item].price ?? "0")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = 175*height
            let heightd = ga_heightForComment(fontSize: 17, width: width, text: data?.data.products[indexPath.item].name ?? "")
            return CGSize(width: 195*height, height: heightd + 250)
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
        if data?.data.category_banner.count ?? 0 < 1 {
return CGSize(width: 0, height: 0)
        }
        return CGSize(width: 0, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSize(width: 0, height: 20)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
                var reusableview:UICollectionReusableView!
                    reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerBannerIdentifier, for: indexPath) as! SelectedBannerCollectionReusableView

            let fsPagerView = FSPagerView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 185))
            fsPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "bannerCell")
            fsPagerView.delegate = self
            fsPagerView.dataSource = self
            fsPagerView.isInfinite = true
            reusableview.addSubview(fsPagerView)
                return reusableview
        }else{
            let footView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer", for: indexPath)

            return footView
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCell?(data?.data.products[indexPath.item].id ?? "")
    }
}
extension RecommendTypeViewController: FSPagerViewDataSource,FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return data?.data.category_banner.count ?? 0
    }

    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if data?.data.category_banner[index].type == "1" {
            let web = WebViewController()
            web.hidesBottomBarWhenPushed = true
            web.title =  ""
            web.uri = data?.data.category_banner[index].content ?? "https://www.necesstore.com"
            self.navigationController?.viewControllers.last?.navigationController?.pushViewController(web, animated: true)
        } else {
                let list = GoodsListViewController()
                list.hidesBottomBarWhenPushed = true
            list.title = ""
            list.product_ids = data?.data.category_banner[index].productIDS ?? ""
            self.navigationController?.viewControllers.last?.navigationController?.pushViewController(list, animated: true)
        }
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "bannerCell", at: index)
        cell.imageView?.af_setImage(withURL: URL(string: (data?.data.category_banner[index].image)!)!)
        return cell
    }
}

