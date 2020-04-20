//
//  GoodsDeatilViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/1/7.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import TagListView
import FSPagerView

class GoodsDeatilViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var favorite: UIButton!
    @IBOutlet weak var bottomTagListView: TagListView!
    @IBOutlet weak var topTagListView: TagListView!
    
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var floatView: UIView!

    @IBOutlet weak var bugBtn: UIButton!
    @IBOutlet weak var addCartBtn: UIButton!
    var data: GoodsDetail? = nil
    var product_id: String = ""
    var fsPagerView: FSPagerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setRightItem()
//        setSearBar()
        setTableView()
        setUp()
        loadData()
    }

    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.register(UINib(nibName: "GoodsHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsHeaderTableViewCell")
        tableView.register(UINib(nibName: "GoodsAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsAddressTableViewCell")
        tableView.register(UINib(nibName: "GoodsActiveTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsActiveTableViewCell")
        tableView.register(UINib(nibName: "GoodsTranslateTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsTranslateTableViewCell")
        tableView.register(UINib(nibName: "GoodsTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsTypeTableViewCell")
        tableView.register(UINib(nibName: "GoodsBrandTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsBrandTableViewCell")
        tableView.register(UINib(nibName: "GoodsEvaluateHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsEvaluateHeaderTableViewCell")
        tableView.register(UINib(nibName: "GoodsEvaluateTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsEvaluateTableViewCell")
        tableView.register(UINib(nibName: "GoodsDetailHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsDetailHeaderTableViewCell")
        tableView.register(UINib(nibName: "GoodsDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsDetailTableViewCell")
        tableView.register(UINib(nibName: "GoodsTipsTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsTipsTableViewCell")

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 300))
        tableView.tableHeaderView = headerView

        fsPagerView = FSPagerView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 300))
        fsPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "bannerCell")
        fsPagerView.delegate = self
        fsPagerView.dataSource = self
        fsPagerView.isInfinite = true
        tableView.tableHeaderView = fsPagerView
        NotificationCenter.default.addObserver(self, selector: #selector(notificationUpdate(nofi:)), name: NSNotification.Name(rawValue:"updateGoodsInfo"), object: nil)
    }

    @objc func notificationUpdate(nofi : Notification){
        loadData()
    }

    func loadData() {
        API.goodsDetailData(product_id: product_id).request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.tableView.reloadData()
//                if data.data.product.categoryID
                self.fsPagerView.reloadData()
            case .failure(let error):
                print(error)
                print(error.self)
                print(error.localizedDescription)
            }
        }
    }

    func setRightItem() {
        let rightBtn = UIButton(type: .custom)
        rightBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightBtn.setImage(UIImage(named: "Oval_normal"), for: .normal)
        rightBtn.contentHorizontalAlignment = .right

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
    }

    func setSearBar() {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        titleView.layer.borderColor = UIColor.black.cgColor
        titleView.layer.borderWidth = 0.5
        titleView.layer.masksToBounds = true
        titleView.layer.cornerRadius = 15

        let seachText = UITextField(frame: CGRect(x: 10, y: 0, width: titleView.frame.size.width, height: 30))
        seachText.placeholder = "搜索商品"
        seachText.font = UIFont.systemFont(ofSize: 14)
        titleView.addSubview(seachText)

        self.navigationItem.titleView = titleView

    }

    func setUp() {
//        bugBtn.layer.cornerRadius = 5
//        bugBtn.layer.masksToBounds = true
//
//        addCartBtn.layer.borderColor = bugBtn.backgroundColor?.cgColor
//        addCartBtn.layer.borderWidth = 1
//        addCartBtn.layer.cornerRadius = 5
//        addCartBtn.layer.masksToBounds = true
        addCartBtn.addTarget(self, action: #selector(addCartAction), for: .touchUpInside)
        bugBtn.addTarget(self, action: #selector(addCartAction), for: .touchUpInside)
        favorite.addTarget(self, action: #selector(favoriteAction), for: .touchUpInside)
//        floatView.layer.cornerRadius = 5
//        floatView.layer.masksToBounds = true
    }

    @objc func favoriteAction() {
        API.favorite(product_id: data?.data.product.id ?? "").request { (result) in
            switch result {
            case .success(let data):
                if data.data.hasCollection {
                    self.favorite.setImage(UIImage(named: "收藏"), for: .normal)
                } else {
                    self.favorite.setImage(UIImage(named: "收藏-1"), for: .normal)
                }
                print(data)
            case .failure(let er):
                print(er)
            }
        }
    }

    @objc func addCartAction() {
        if UserSetting.default.activeUserToken == nil {
        let login = LoginViewController()
        self.navigationController?.pushViewController(login, animated: true)
            return
        }

        let type = SelectTypeViewController()
        type.modalPresentationStyle = .custom
        type.data = data
        type.didToBuy = { (num,optin) in
            let creat = CreatOrderViewController()
            creat.product_id = self.data?.data.product.id
            creat.quantity = num
            creat.product_option_union_id = optin
            self.navigationController?.pushViewController(creat, animated: true)
        }
        self.present(type, animated: true, completion: nil)
    }

    @objc func runEvaluateList() {
        let evaluate = EvaluateListViewController()
        evaluate.product_id = data?.data.product.id ?? ""
        evaluate.goodsData = data
        self.navigationController?.pushViewController(evaluate, animated: true)
    }
}
extension GoodsDeatilViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 5 || section == 3 {
            return 2
        } else if section == 2 {
            return (data?.data.productEvaluate.count ?? 0) + 1
        } else if section == 0 {
            return 2
        } else if section == 1 {
            return 3
        }

        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return data == nil ? 0 : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsTipsTableViewCell") as! GoodsTipsTableViewCell
                cell.selectionStyle = .none
                cell.discount.text = data?.data.product.returncontent
                cell.content.text = data?.data.product.recommendcontent
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsHeaderTableViewCell") as! GoodsHeaderTableViewCell
            cell.price_sort.text = "￥\(data?.data.product.maxPrice ?? "0")"
            cell.name.text = data?.data.product.name
            cell.shippingContent.text = "  \(data?.data.product.shippingcontent ?? "") "
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 1 {
            if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsTypeTableViewCell") as! GoodsTypeTableViewCell
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
                cell.typeName.text = "选择 \(data?.data.getProductOptionGroup()[0].name ?? "")\(data?.data.getProductOptionGroup()[1].name ?? "")"
            return cell
            } else if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsActiveTableViewCell") as! GoodsActiveTableViewCell
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .none
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsBrandTableViewCell") as! GoodsBrandTableViewCell
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .none
                return cell
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsEvaluateHeaderTableViewCell") as! GoodsEvaluateHeaderTableViewCell
                cell.accessoryType = .disclosureIndicator
                cell.getMoreBtn.addTarget(self, action: #selector(runEvaluateList), for: .touchUpInside)
                cell.selectionStyle = .none
            return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsEvaluateTableViewCell") as! GoodsEvaluateTableViewCell
                let info = data?.data.productEvaluate ?? []
                cell.userName.text = info[indexPath.row - 1].userName
                cell.userImage.af_setImage(withURL: URL(string: info[indexPath.row - 1].getUserImage())!)
                cell.detail.text = info[indexPath.row - 1].content
                cell.date.text = info[indexPath.row - 1].created
                if info[indexPath.row-1].evaluateImage.count == 0 {

                    cell.imgLayout.constant = 0

                } else {
                    cell.imgLayout.constant = 50
                }
                for index in 0..<info[indexPath.row-1].evaluateImage.count {
                    let item = info[indexPath.row-1].evaluateImage[index]

                    if index == 0 {
                        cell.img1.af_setImage(withURL: URL(string: item)!)
                    } else if index == 1 {
                        cell.img2.af_setImage(withURL: URL(string: item)!)
                    } else if index == 2 {
                        cell.img3.af_setImage(withURL: URL(string: item)!)
                    } else if index == 3 {
                        cell.img4.af_setImage(withURL: URL(string: item)!)
                    } else if index == 4 {
                        cell.img5.af_setImage(withURL: URL(string: item)!)
                    }
                }
                cell.selectionStyle = .none
                return cell
            }
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsDetailHeaderTableViewCell") as! GoodsDetailHeaderTableViewCell
                cell.selectionStyle = .none
            return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsDetailTableViewCell") as! GoodsDetailTableViewCell
                cell.web.loadHTMLString((data?.data.product.productDescription)!, baseURL: URL(string: urlheadr)!)
                cell.selectionStyle = .none
                return cell
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsAddressTableViewCell") as! GoodsAddressTableViewCell
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else if section == 2 {
            return 40
        } else if section == 3 {
            return 1
        }
        return 15
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.tableviewBackgroundColor
        if section == 2 {
            let lab = UILabel(frame: CGRect(x: 16, y: 0, width: 300, height: 40))
            lab.text = "假一罚十·极速退款·退货运费险"
            lab.font = UIFont.PingFangSCLightFont15
            lab.textColor = UIColor.lightGray
            view.addSubview(lab)
        }
        return view
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            if indexPath.row == 1 {
                if data?.data.productModel != nil {
                let popUp = GoodsPopUpViewController(popUpType: GoodsPopUpViewController.PopUpType.brand(data: (data?.data.productModel)!))
                    popUp.modalPresentationStyle = .custom
                self.present(popUp, animated: false, completion: nil)
                }
                return
            }
        if UserSetting.default.activeUserToken == nil {
        let login = LoginViewController()
        self.navigationController?.pushViewController(login, animated: true)
            return
        }

        let type = SelectTypeViewController()
        type.modalPresentationStyle = .custom
        type.data = data
            type.didToBuy = { (num,optin) in
                let creat = CreatOrderViewController()
                creat.product_id = self.data?.data.product.id
                creat.quantity = num
                creat.product_option_union_id = optin
                self.navigationController?.pushViewController(creat, animated: true)
            }
        self.present(type, animated: true, completion: nil)
        } else if indexPath.section == 1, indexPath.row == 0 {
            if (data?.data.coupon.count ?? 0) < 1 { return }
            let popUp = GoodsPopUpViewController(popUpType: GoodsPopUpViewController.PopUpType.translate(data: (data?.data.coupon)!))
                popUp.modalPresentationStyle = .custom
            self.present(popUp, animated: false, completion: nil)
        } else if indexPath.section == 1, indexPath.row == 1 {
            let type = SelectTypeViewController()
            type.modalPresentationStyle = .custom
            type.data = data
            type.didToBuy = { (num,optin) in
                let creat = CreatOrderViewController()
                creat.product_id = self.data?.data.product.id
                creat.quantity = num
                creat.product_option_union_id = optin
                self.navigationController?.pushViewController(creat, animated: true)
            }
            self.present(type, animated: true, completion: nil)
        }
    }
    
}

extension GoodsDeatilViewController: TagListViewDelegate{
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
    }

    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }

}

extension GoodsDeatilViewController: FSPagerViewDelegate,FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return data?.data.productImage.count ?? 0
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "bannerCell", at: index)
        cell.imageView?.af_setImage(withURL: URL(string: (data?.data.productImage[index].image)!)!)
        return cell
    }

}
