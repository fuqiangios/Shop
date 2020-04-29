//
//  CommunityViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2019/12/25.
//  Copyright © 2019 付强. All rights reserved.
//

import UIKit
import ZLCollectionViewFlowLayout
import FSPagerView

class CommunityViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let Identifier       = "SelectedImageCollectionViewCell"
    let goods = "GoodsListCollectionViewCell"
    let headerBannerIdentifier = "CollectionBannerHeaderView"
    let headerTypeIdentifier = "CollectionTypeHeaderView"
    let height = ScreenWidth/414.0
    let FHeig = ScreenHeight/414.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let itme = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = itme
        title = "社交"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "相机"), style: .done, target: self, action: #selector(addNewCommunity))
        let layout = ZLCollectionViewVerticalLayout()
        layout.delegate = self
        collectionView.collectionViewLayout = layout
        collectionView?.backgroundColor = UIColor.tableviewBackgroundColor
        collectionView?.delegate = self
        collectionView?.dataSource = self
        self.view.addSubview(collectionView!)
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.isTranslucent = false
                      // 注册
        collectionView?.register(UINib.init(nibName: "CommunityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Identifier)
        collectionView?.register(UINib.init(nibName: "GoodsListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: goods)
                      // 注册headerView
        collectionView?.register(UINib.init(nibName: "SelectedBannerCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: headerBannerIdentifier)
        collectionView?.register(UINib.init(nibName: "SelectedTypeCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: headerTypeIdentifier)
        collectionView?.register(UINib.init(nibName: "SelectedFooterCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionFooter", withReuseIdentifier: "footer")
        collectionView?.register(UINib.init(nibName: "SelectedHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "header")
        collectionView?.register(UINib.init(nibName: "SelectedMoreCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "headerMore")
    }

    @objc func addNewCommunity() {
        let add = AddNewCommunityViewController()
        add.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(add, animated: true)
    }
}
extension CommunityViewController: UICollectionViewDelegate, UICollectionViewDataSource, ZLCollectionViewBaseFlowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell:CommunityCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier, for: indexPath) as! CommunityCollectionViewCell
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
            return cell

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: 180*height, height: 225*height)
        default:
            return CGSize(width: 195*height, height: 300)
        }
    }

    func ga_heightForComment(fontSize: CGFloat, width: CGFloat, text: String) -> CGFloat {
         let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: text).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
         return ceil(rect.height)
     }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets.init(top: 0, left: 18*height, bottom: 0, right: 8*height)
        case 1:
            return UIEdgeInsets.init(top: 0, left: 8*height, bottom: 0, right: 8*height)
        default:
            return UIEdgeInsets.init(top: 0, left: 15*height, bottom: 0, right: 15*height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 15*height
        } else if section == 1 {
            return 14*height
        } else if section == 4 {
            return 14*height
        } else if section == 5 {
            return 14*height
        } else if section == 6 {
            return 14*height
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 18*height
        } else if section == 1 {
            return 5*height
        } else if section == 4 {
            return 14*height
        } else if section == 5 {
            return 14*height
        } else if section == 6 {
            return 14*height
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: 0, height: 260)
        } else if section == 1 {
            return CGSize(width: 0, height: 180)
        } else if section == 3 || section == 4 {
            return CGSize(width: 0, height: 70)
        } else if section == 5 {
            return CGSize(width: 0, height: 40)
        }
        return CGSize(width: 0, height: 15)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: 0, height: 40)
        } else if section == 0 {
            return CGSize(width: 0, height: 20)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
                var reusableview:UICollectionReusableView!
                    reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerBannerIdentifier, for: indexPath) as! SelectedBannerCollectionReusableView

            let titleView = UIView(frame: CGRect(x: 16, y: 10, width: view.frame.width - 32, height: 40))
               titleView.layer.cornerRadius = 10
               titleView.backgroundColor = UIColor.lightColor

               let seachText = UITextField(frame: CGRect(x: 10, y: 0, width: titleView.frame.size.width, height: 40))
               seachText.placeholder = "搜索产品名称"
               seachText.font = UIFont.PingFangSCLightFont16
               titleView.addSubview(seachText)

               reusableview.addSubview(titleView)

            let fsPagerView = FSPagerView(frame: CGRect(x: 15, y: 60, width: view.frame.size.width - 30, height: 185))
            fsPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "bannerCell")
            fsPagerView.delegate = self
            fsPagerView.dataSource = self
            fsPagerView.isInfinite = true
            fsPagerView.backgroundColor = .white
            fsPagerView.layer.cornerRadius = 10
            fsPagerView.layer.masksToBounds = true
            reusableview.addSubview(fsPagerView)
                return reusableview
        }else{
            let footView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer", for: indexPath)

            return footView
        }
    }

    func setTypeScroView(scroView: UIScrollView) {
//        let types = data?.data.labels ?? []
//        for index in 0..<types.count {
//            let btn = UIButton(type: .custom)
//            btn.frame = CGRect(x: index*110, y: 0, width: 110, height: 50)
//            btn.setTitle(types[index].name, for: .normal)
//            btn.setTitleColor(.black, for: .normal)
//            btn.setTitleColor(.red, for: .selected)
//            btn.tag = index + 1000
//            btn.addTarget(self, action: #selector(selectType(btn:)), for: .touchUpInside)
//            if index == 0 {
//                btn.isSelected = true
//                btn.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 17)
//            }
//            scroView.addSubview(btn)
//        }
//        scroView.contentSize = CGSize(width: 110*types.count, height: 50)
//        scroView.showsHorizontalScrollIndicator = false
//
//        let line = UIImageView(frame: CGRect(x: 45, y: 40, width: 20, height: 2))
//        line.tag = 9000
//        line.backgroundColor = .red
//        scroView.addSubview(line)
    }

    @objc func selectType(btn: UIButton) {
//        lablesIndex = btn.tag - 1000
//        setTopBtnNormal(button: btn)
//        collectionView?.reloadData()
    }

    func setTopBtnNormal(button: UIButton) {
//        let types = data?.data.labels ?? []
//        for index in 1000..<(1000+types.count) {
//            let btn = view.viewWithTag(index) as! UIButton
//            btn.isSelected = false
//            btn.titleLabel?.font = UIFont.PingFangSCLightFont18
//        }
//        button.isSelected = true
//        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 17)
//
//        let line = view.viewWithTag(9000)as! UIImageView
//        line.center = CGPoint(x: button.center.x, y: line.center.y)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = CommunityDetailViewController()
        detail.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
extension CommunityViewController: FSPagerViewDataSource,FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 2
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "bannerCell", at: index)
        cell.backgroundColor = .white
        cell.imageView?.backgroundColor = UIColor.green
        cell.imageView?.layer.cornerRadius = 10
        cell.imageView?.layer.masksToBounds = true
//        cell.imageView?.af_setImage(withURL: URL(string: (data?.data.category_banner[index].image)!)!)
        return cell
    }
}
