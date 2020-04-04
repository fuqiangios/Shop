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
        setSearBar()
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

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200))
        tableView.tableHeaderView = headerView

        fsPagerView = FSPagerView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200))
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
        bugBtn.layer.cornerRadius = 5
        bugBtn.layer.masksToBounds = true

        addCartBtn.layer.borderColor = bugBtn.backgroundColor?.cgColor
        addCartBtn.layer.borderWidth = 1
        addCartBtn.layer.cornerRadius = 5
        addCartBtn.layer.masksToBounds = true
        addCartBtn.addTarget(self, action: #selector(addCartAction), for: .touchUpInside)
        bugBtn.addTarget(self, action: #selector(addCartAction), for: .touchUpInside)
//        floatView.layer.cornerRadius = 5
//        floatView.layer.masksToBounds = true
    }

    @objc func addCartAction() {
        if UserSetting.default.activeUserToken == nil {
        let login = LoginViewController()
        self.navigationController?.pushViewController(login, animated: true)
            return
        }

        let type = SelectTypeViewController()
        type.modalPresentationStyle = .pageSheet
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
        if section == 1 || section == 5 || section == 3 {
            return 2
        } else if section == 4 {
            return (data?.data.productEvaluate.count ?? 0) + 1
        }
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return data == nil ? 0 : 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsHeaderTableViewCell") as! GoodsHeaderTableViewCell
            cell.price_sort.text = "￥\(data?.data.product.mixPrice ?? "0")-\(data?.data.product.maxPrice ?? "0")"
            cell.price.text = "价格￥\(data?.data.product.oldPrice ?? "0")"
            cell.name.text = data?.data.product.name
            cell.zan.setTitle(" \(data?.data.product.zanCnt ?? "0")", for: .normal)
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsAddressTableViewCell") as! GoodsAddressTableViewCell
                cell.sale.text = "月销\(data?.data.product.saleCnt ?? "0")"
                cell.selectionStyle = .none
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsActiveTableViewCell") as! GoodsActiveTableViewCell
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsTranslateTableViewCell") as! GoodsTranslateTableViewCell
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsTypeTableViewCell") as! GoodsTypeTableViewCell
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
                cell.typeName.text = "选择 \(data?.data.getProductOptionGroup()[0].name ?? "")\(data?.data.getProductOptionGroup()[1].name ?? "")"
                var index = 1
                var num = 0
                for option in data?.data.getProductOptionGroup() ?? []{
                    for item in option.productOption   {
                        num = num + 1
                        if !item.image.isEmpty {
                            switch index {
                            case 1:
                                cell.img1.af_setImage(withURL: URL(string: item.image)!)
                                break
                            case 2:
                                cell.img2.af_setImage(withURL: URL(string: item.image)!)
                                break
                            case 3:
                                cell.img3.af_setImage(withURL: URL(string: item.image)!)
                                break
                            case 4:
                                cell.img4.af_setImage(withURL: URL(string: item.image)!)
                                break
                            default:
                                break
                            }
                            index = index + 1
                        }
                    }
                }
                cell.numType.text = "共\(num)种\(data?.data.getProductOptionGroup()[0].name ?? "")\(data?.data.getProductOptionGroup()[1].name ?? "")可选"
            return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsBrandTableViewCell") as! GoodsBrandTableViewCell
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .none
                return cell
            }
        } else if indexPath.section == 4 {
            if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsEvaluateHeaderTableViewCell") as! GoodsEvaluateHeaderTableViewCell
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
                    cell.imgLayout.isActive = false
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
        } else if indexPath.section == 5 {
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
        return 15
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
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
        type.modalPresentationStyle = .pageSheet
        type.data = data
            type.didToBuy = { (num,optin) in
                let creat = CreatOrderViewController()
                creat.product_id = self.data?.data.product.id
                creat.quantity = num
                creat.product_option_union_id = optin
                self.navigationController?.pushViewController(creat, animated: true)
            }
        self.present(type, animated: true, completion: nil)
        } else if indexPath.section == 1, indexPath.row == 1 {
            if (data?.data.coupon.count ?? 0) < 1 { return }
            let popUp = GoodsPopUpViewController(popUpType: GoodsPopUpViewController.PopUpType.translate(data: (data?.data.coupon)!))
                popUp.modalPresentationStyle = .custom
            self.present(popUp, animated: false, completion: nil)
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
