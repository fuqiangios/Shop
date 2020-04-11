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

class RecommendTypeViewController: UIViewController {
    var collectionView : UICollectionView?
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
        API.homeCategoryData(p_category_id: categoryId, category_id: nil).request { (response) in
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
        cell.goodsImg.af_setImage(withURL: URL(string: (data?.data.products[indexPath.item].image)!)!)
        cell.goodsName.text = data?.data.products[indexPath.item].name

        cell.price.text = "￥" + (data?.data.products[indexPath.item].price ?? "0") + " ￥\(data?.data.products[indexPath.item].oldPrice ?? "0")"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = 175*height
            let heightd = ga_heightForComment(fontSize: 17, width: width, text: data?.data.products[indexPath.item].name ?? "")
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

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "bannerCell", at: index)
        cell.imageView?.af_setImage(withURL: URL(string: (data?.data.category_banner[index].image)!)!)
        return cell
    }


}

