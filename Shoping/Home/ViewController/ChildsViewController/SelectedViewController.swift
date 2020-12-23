//
//  SelectedViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2019/12/25.
//  Copyright © 2019 付强. All rights reserved.
//

import UIKit
import ZLCollectionViewFlowLayout
import AlamofireImage
import FSPagerView

let ScreenWidth  = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height
class SelectedViewController: UIViewController {
    var collectionView : UICollectionView?
//    @IBOutlet weak var collectionView: UICollectionView!
    
    let Identifier       = "SelectedImageCollectionViewCell"
    let goods = "GoodsListCollectionViewCell"
    let headerBannerIdentifier = "CollectionBannerHeaderView"
    let headerTypeIdentifier = "CollectionTypeHeaderView"
    let height = ScreenWidth/414.0
    let FHeig = ScreenHeight/414.0
    var data: Home? = nil
    var lablesIndex = 0

    var didSelectCell: ((Int, IndexPath) -> Void)?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                      // 注册
        collectionView?.register(UINib.init(nibName: "SelectedImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Identifier)
        collectionView?.register(UINib.init(nibName: "GoodsListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: goods)
                      // 注册headerView
        collectionView?.register(UINib.init(nibName: "SelectedBannerCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: headerBannerIdentifier)
        collectionView?.register(UINib.init(nibName: "SelectedTypeCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: headerTypeIdentifier)
        collectionView?.register(UINib.init(nibName: "SelectedFooterCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionFooter", withReuseIdentifier: "footer")
        collectionView?.register(UINib.init(nibName: "SelectedHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "header")
        collectionView?.register(UINib.init(nibName: "SelectedMoreCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "headerMore")
    }
}

extension SelectedViewController: UICollectionViewDelegate, UICollectionViewDataSource, ZLCollectionViewBaseFlowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return data?.data.imageLabels.count ?? 0
        }
        return data?.data.labels[lablesIndex].product.count ?? 0
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell:GoodsListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: goods, for: indexPath) as! GoodsListCollectionViewCell
            if !(data?.data.labels[lablesIndex].product[indexPath.item].image.isEmpty ?? true) {
                cell.goodsImg.af_setImage(withURL: URL(string: (data?.data.labels[lablesIndex].product[indexPath.item].image)!)!)
            }
            cell.goodsName.text = (data?.data.labels[lablesIndex].product[indexPath.item].name ?? "")
            cell.info.text = data?.data.labels[lablesIndex].product[indexPath.item].title
            cell.setPri(str: "￥" + (data?.data.labels[lablesIndex].product[indexPath.item].price ?? "0"))
//            cell.price.text = "￥" + (data?.data.labels[lablesIndex].product[indexPath.item].price ?? "0")

            return cell
        }
        let cell:SelectedImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier, for: indexPath) as! SelectedImageCollectionViewCell
        if indexPath.section == 0 {
            cell.name.text = data?.data.imageLabels[indexPath.item].name ?? ""
            if data?.data.imageLabels[indexPath.item].image ?? "" != "" {
            cell.img.af_setImage(withURL: URL(string: data?.data.imageLabels[indexPath.item].image ?? "")!)
            }
//            if indexPath.item == 0 {
//                cell.img.image = UIImage(named: "新品上新")
//                if data?.data.imageLabels.count ?? 0 >= 1 {
//                    cell.name.text = data?.data.imageLabels[0].name ?? ""
//                }
//            } else if indexPath.item == 1 {
//                cell.img.image = UIImage(named: "Recommend")
//                if data?.data.imageLabels.count ?? 0 >= 2 {
//                    cell.name.text = data?.data.imageLabels[1].name ?? ""
//                }
//            } else if indexPath.item == 2 {
//                cell.img.image = UIImage(named: "food")
//                if data?.data.imageLabels.count ?? 0 >= 3 {
//                    cell.name.text = data?.data.imageLabels[2].name ?? ""
//                }
//            } else if indexPath.item == 3 {
//                cell.img.image = UIImage(named: "international")
//                if data?.data.imageLabels.count ?? 0 >= 4 {
//                    cell.name.text = data?.data.imageLabels[3].name ?? ""
//                }
//            } else {
//                cell.img.image = UIImage(named: "Live")
//                if data?.data.imageLabels.count ?? 0 >= 5 {
//                    cell.name.text = data?.data.imageLabels[4].name ?? ""
//                }
//            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: 90*height, height: 90*height)
        default:
            let width = 175*height
            let heightd = ga_heightForComment(fontSize: 17, width: width, text: data?.data.labels[lablesIndex].product[indexPath.item].name ?? "")
            return CGSize(width: 195*height, height: 305)
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
            return UIEdgeInsets.init(top: 0, left: 10*height, bottom: 0, right: 10*height)
        case 1:
            return UIEdgeInsets.init(top: 0, left: 8*height, bottom: 0, right: 8*height)
        default:
            return UIEdgeInsets.init(top: 0, left: 15*height, bottom: 0, right: 15*height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 5*height
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
            return 8*height
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
            return CGSize(width: 0, height: 200)
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
            if indexPath.section == 1 {
                let reusableview: SelectedTypeCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerTypeIdentifier, for: indexPath) as! SelectedTypeCollectionReusableView
                if reusableview.typeScrollView.subviews.count < 3 {
                    setTypeScroView(scroView: reusableview.typeScrollView)
                }
                let fsPagerView = FSPagerView(frame: CGRect(x: 16, y: 0, width: view.frame.size.width - 32, height: 110))
                  fsPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "bannerCell")
                fsPagerView.register(FSPagerBannerViewCell.self, forCellWithReuseIdentifier: "gifBannerCell")
//                fsPagerView.register(UINib.init(nibName: "FSPagerBannerViewCell", bundle: nil), forCellWithReuseIdentifier: "gifBannerCell")
                  fsPagerView.delegate = self
                  fsPagerView.dataSource = self
                  fsPagerView.isInfinite = true
                  fsPagerView.backgroundColor = .white
                fsPagerView.isScrollEnabled = false

//                  fsPagerView.layer.cornerRadius = 10
//                  fsPagerView.layer.masksToBounds = true
                fsPagerView.tag = 999
                  reusableview.addSubview(fsPagerView)
                return reusableview
            } else if indexPath.section == 0 {
                var reusableview:UICollectionReusableView!
                    reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerBannerIdentifier, for: indexPath) as! SelectedBannerCollectionReusableView
                          let fsPagerView = FSPagerView(frame: CGRect(x: 15, y: 10, width: view.frame.size.width - 30, height: 165))
                  fsPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "bannerCell")
                  fsPagerView.delegate = self
                  fsPagerView.dataSource = self
                  fsPagerView.isInfinite = true
                  fsPagerView.backgroundColor = .white
                  fsPagerView.layer.cornerRadius = 10
                  fsPagerView.layer.masksToBounds = true
                  reusableview.addSubview(fsPagerView)
                return reusableview
            } else if indexPath.section == 3 || indexPath.section == 4 {
                var reusableview:SelectedMoreCollectionReusableView!
                    reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerMore", for: indexPath) as! SelectedMoreCollectionReusableView
                if indexPath.section == 3 {
                    reusableview.name.text = "帮帮付"
                }
                return reusableview
            }
            var reusableview:UICollectionReusableView!
                reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            return reusableview
        }else{
            let footView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer", for: indexPath)

            return footView
        }
    }

    func setTypeScroView(scroView: UIScrollView) {
        let types = data?.data.labels ?? []
        for index in 0..<types.count {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: index*110, y: 0, width: 110, height: 50)
            btn.setTitle(types[index].name, for: .normal)
            btn.setTitleColor(.black, for: .normal)
            btn.setTitleColor(.red, for: .selected)
            btn.tag = index + 1000
            btn.addTarget(self, action: #selector(selectType(btn:)), for: .touchUpInside)
            if index == 0 {
                btn.isSelected = true
                btn.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 17)
            }
            scroView.addSubview(btn)
        }
        scroView.contentSize = CGSize(width: 110*types.count, height: 50)
        scroView.showsHorizontalScrollIndicator = false

        let line = UIImageView(frame: CGRect(x: 45, y: 40, width: 20, height: 2))
        line.tag = 9000
        line.backgroundColor = .red
        scroView.addSubview(line)
    }

    @objc func selectType(btn: UIButton) {
        lablesIndex = btn.tag - 1000
        setTopBtnNormal(button: btn)
        collectionView?.reloadData()
    }

    func setTopBtnNormal(button: UIButton) {
        let types = data?.data.labels ?? []
        for index in 1000..<(1000+types.count) {
            let btn = view.viewWithTag(index) as! UIButton
            btn.isSelected = false
            btn.titleLabel?.font = UIFont.PingFangSCLightFont18
        }
        button.isSelected = true
        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 17)

        let line = view.viewWithTag(9000)as! UIImageView
        line.center = CGPoint(x: button.center.x, y: line.center.y)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCell?(lablesIndex, indexPath)
    }
}
extension SelectedViewController: FSPagerViewDataSource,FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if pagerView.tag == 999 {
            return data?.data.advertMiddle.count ?? 0
        }
        return data?.data.advertTop.count ?? 0
    }

    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if pagerView.tag == 999 {
            if data?.data.advertMiddle[index].type == "1" {
                let web = WebViewController()
                web.hidesBottomBarWhenPushed = true
                web.title = data?.data.advertMiddle[index].name ?? ""
                web.uri = data?.data.advertMiddle[index].content ?? "https://www.necesstore.com"
                self.navigationController?.viewControllers.last?.navigationController?.pushViewController(web, animated: true)
            } else if data?.data.advertMiddle[index].type == "2" {
                    let list = GoodsListViewController()
                    list.hidesBottomBarWhenPushed = true
                list.title = data?.data.advertMiddle[index].name ?? ""
                list.product_ids = data?.data.advertMiddle[index].productIDS ?? ""
                self.navigationController?.viewControllers.last?.navigationController?.pushViewController(list, animated: true)
            } else if data?.data.advertMiddle[index].type == "3" {
                if UserSetting.default.activeUserToken == nil {
                let login = LoginViewController()
                self.navigationController?.pushViewController(login, animated: true)
                    return
                }
                let shop = RenRenFightingWViewController()
                shop.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(shop, animated: true)
            }
        } else {
        if data?.data.advertTop[index].type == "1" {
            let web = WebViewController()
            web.hidesBottomBarWhenPushed = true
            web.title = data?.data.advertTop[index].name ?? ""
            web.uri = data?.data.advertTop[index].content ?? "https://www.necesstore.com"
            self.navigationController?.viewControllers.last?.navigationController?.pushViewController(web, animated: true)

        } else if data?.data.advertTop[index].type == "2"{
                let list = GoodsListViewController()
                list.hidesBottomBarWhenPushed = true
            list.title = data?.data.advertTop[index].name ?? ""
            list.product_ids = data?.data.advertTop[index].productIDS ?? ""
            self.navigationController?.viewControllers.last?.navigationController?.pushViewController(list, animated: true)
        } else if data?.data.advertTop[index].type == "3" {
            if UserSetting.default.activeUserToken == nil {
            let login = LoginViewController()
            self.navigationController?.pushViewController(login, animated: true)
                return
            }
            let shop = RenRenFightingWViewController()
            shop.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(shop, animated: true)
          }
        }
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {

//        cell.imageView?.backgroundColor = UIColor.green
//        cell.imageView?.layer.cornerRadius = 10
//        cell.imageView?.layer.masksToBounds = true
        if pagerView.tag == 999 {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "gifBannerCell", at: index) as!FSPagerBannerViewCell
            
            cell.backgroundColor = .white
            let url = URL.init(string: (data?.data.advertMiddle[index].image)!)!
            let request = URLRequest(url: url)
               //异步加载图片
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler:{ (response, data, error) -> Void in
                if (error != nil) {
                    print(error)
                    return
                }
                cell.gif?.gifData = data
                cell.gif?.startGif()

            })
//            cell.imageView?.af_setImage(withURL: URL(string: (data?.data.advertMiddle[index].image)!)!)
            return cell
        } else {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "bannerCell", at: index)
            cell.backgroundColor = .white
            cell.imageView?.af_setImage(withURL: URL(string: (data?.data.advertTop[index].image)!)!)
            return cell
        }

    }
}

