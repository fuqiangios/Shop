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
import AVKit
import AVFoundation

class GoodsDeatilViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var favorite: UIButton!
    @IBOutlet weak var bottomTagListView: TagListView!
    @IBOutlet weak var topTagListView: TagListView!
    var img1: UIImageView!
    var img2: UIImageView!
    var img3: UIImageView!
    var pageLabel: UILabel!
    
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var floatView: UIView!

    @IBOutlet weak var bugBtn: UIButton!
    @IBOutlet weak var addCartBtn: UIButton!
    var data: GoodsDetail? = nil
    var product_id: String = ""
    var fsPagerView: FSPagerView!
    var webViewHeight = 0.0
    var addressStr = ""
    var option = ""
    var section1 = 3
    var relationHeight = 0

    override func viewDidLoad() {
        view.backgroundColor = .white
        topView.backgroundColor = .clear
        back.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        back.layer.cornerRadius = 15
        back.layer.masksToBounds = true
        share.layer.cornerRadius = 15
        share.layer.masksToBounds = true
        setTableView()
        setUp()
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(shouldPopup), name: NSNotification.Name(rawValue: "popup"), object: nil)
    }

    @objc func shouldPopup() {
        self.navigationController?.popToRootViewController(animated: true)
    }

    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.white
        tableView.register(UINib(nibName: "GoodsHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsHeaderTableViewCell")
        tableView.register(UINib(nibName: "GoodsAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsAddressTableViewCell")
        tableView.register(UINib(nibName: "GoodsActiveTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsActiveTableViewCell")
        tableView.register(UINib(nibName: "GoodsTranslateTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsTranslateTableViewCell")
        tableView.register(UINib(nibName: "GoodsTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsTypeTableViewCell")
        tableView.register(UINib(nibName: "GoodsBrandTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsBrandTableViewCell")
        tableView.register(UINib(nibName: "GoodsRelationTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsRelationTableViewCell")

        tableView.register(UINib(nibName: "GoodsEvaluateHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsEvaluateHeaderTableViewCell")
        tableView.register(UINib(nibName: "GoodsEvaluateTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsEvaluateTableViewCell")
        tableView.register(UINib(nibName: "GoodsDetailHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsDetailHeaderTableViewCell")
        tableView.register(UINib(nibName: "GoodsDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsDetailTableViewCell")
        tableView.register(UINib(nibName: "GoodsTipsTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsTipsTableViewCell")

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        tableView.tableHeaderView = headerView

        fsPagerView = FSPagerView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
//        fsPagerView.register(DetailPageCollectionViewCell.self, forCellWithReuseIdentifier: "bannerCell")
        fsPagerView.register(UINib(nibName: "DetailPageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "bannerCell")
        fsPagerView.delegate = self
        fsPagerView.dataSource = self
        fsPagerView.isInfinite = true
        let hi = UIScreen.main.bounds.width
        pageLabel = UILabel(frame: CGRect(x: hi - 70, y: view.frame.size.width - 40, width: 50, height: 20))
        pageLabel.backgroundColor = .black
        pageLabel.layer.cornerRadius = 10
        pageLabel.layer.masksToBounds = true
        pageLabel.textColor = .white
        pageLabel.textAlignment = .center
        pageLabel.text = "0/0"
        pageLabel.font = UIFont.systemFont(ofSize: 13)



        img1 = UIImageView(frame: CGRect(x: 10, y: 10, width: 80, height: 80))
        fsPagerView.addSubview(img1)

        img2 = UIImageView(frame: CGRect(x: hi - 100, y: hi - 180, width: 90, height: 90))
        fsPagerView.addSubview(img2)

        img3 = UIImageView(frame: CGRect(x: 0, y: view.frame.size.width - 70, width: hi, height: 70))
        fsPagerView.addSubview(img3)
        fsPagerView.addSubview(pageLabel)
        tableView.backgroundColor = .white
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

                if data.data.product.hasCollection {
                    self.favorite.setImage(UIImage(named: "收藏"), for: .normal)
                } else {
                    self.favorite.setImage(UIImage(named: "收藏-1"), for: .normal)
                }
                if data.data.coupon.count < 1 {
                    self.section1 = 2
                } else {
                    self.section1 = 3
                }
                let yu = (data.data.product_relation.count%2)
                var i = 0
                if yu <= 0 {
                    i = 0
                } else {
                    i = 1
                }
                self.relationHeight = (data.data.product_relation.count/2 + i)*310 + 20
                self.tableView.reloadData()
                self.addressStr = data.data.address.address ?? ""
                self.fsPagerView.reloadData()
                self.setPageLabel(str: "1/\(data.data.productImage.count ?? 0)")
                if data.data.product.activity_flag == "1" {
                    if data.data.product.activity_image_1 != "" {
                        self.img1.af_setImage(withURL: URL(string: data.data.product.activity_image_1)!)
                    }
                    if data.data.product.activity_image_2 != "" {
                        self.img2.af_setImage(withURL: URL(string: data.data.product.activity_image_2)!)
                    }
                    if data.data.product.activity_image_3 != "" {
                        self.img3.af_setImage(withURL: URL(string: data.data.product.activity_image_3)!)
                    }
                }
            case .failure(let error):
                print(error)
                print(error.self)
                print(error.localizedDescription)
                CLProgressHUD.showError(in: self.view, delegate: self, title: "网络错误或商品已删除", duration: 1)
            }
        }
    }

    func setPageLabel(str: String) {
        pageLabel.text = str
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

    @IBAction func shareAction(_ sender: Any) {
        UMSocialUIManager.setPreDefinePlatforms([NSNumber(integerLiteral:UMSocialPlatformType.wechatSession.rawValue),NSNumber(integerLiteral:UMSocialPlatformType.wechatTimeLine.rawValue)])
        UMSocialUIManager.addCustomPlatformWithoutFilted(UMSocialPlatformType(rawValue: UMSocialPlatformType.userDefine_Begin.rawValue+2)!, withPlatformIcon: UIImage(named: "qrcode"), withPlatformName: "图片分享")
        UMSocialShareUIConfig.shareInstance()?.sharePageGroupViewConfig.sharePageGroupViewPostionType = .bottom
        UMSocialShareUIConfig.shareInstance()?.sharePageScrollViewConfig.shareScrollViewPageItemStyleType = .iconAndBGRoundAndSuperRadius
        UMSocialUIManager.showShareMenuViewInWindow { (type, info) in
            if (type == UMSocialPlatformType(rawValue: UMSocialPlatformType.userDefine_Begin.rawValue+2)) {
                API.shareGoods(product_id: self.product_id, invite_code: self.data?.data.invite_code ?? "").request { (result) in
                    switch result{
                    case .success(let data):
                        print(data)
                        let shareVc = ShareGoodsViewController()
                        shareVc.data = data
                        shareVc.modalPresentationStyle = .custom
                        shareVc.qrcodeUri = "\(urlheadr)/html/share.html?id=\(self.product_id )&invite_code=\(self.data?.data.invite_code ?? "")"
                        self.present(shareVc, animated: false, completion: nil)
                    case .failure(let er):
                        print(er)
                    }
                }
                return
            }
            let t = type as! UMSocialPlatformType

            let m = UMSocialMessageObject()
                    let s = UMShareWebpageObject.shareObject(withTitle: "时时分享有收益，天天购物有大奖，月月消费送医保，晚年免费来养老~", descr: "注册我家用品APP，免费红包送到手软~", thumImage: UIImage(named: "27211590459319_.pic_hd"))
            s?.webpageUrl = "\(urlheadr)/html/share.html?id=\(self.product_id )&invite_code=\(self.data?.data.invite_code ?? "")"
                    m.shareObject = s
                    UMSocialManager.default()?.share(to: t, messageObject: m, currentViewController: self, completion: { (le, er) in
                        print(er)
                        print(le)
                    })
        }
    }


    @objc func favoriteAction() {
        if UserSetting.default.activeUserToken == nil {
        let login = LoginViewController()
        self.navigationController?.pushViewController(login, animated: true)
            return
        }
        API.favorite(product_id: data?.data.product.id ?? "", product_option_union_id: option).request { (result) in
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
        type.didColse = { (option) in
            self.option = option
            self.tableView.reloadData()
        }
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

    @IBAction func cart(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.selectedIndex = 2
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
            return section1
        }

        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return data == nil ? 0 : 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsRelationTableViewCell") as! GoodsRelationTableViewCell
                cell.selectionStyle = .none
            cell.didSelect = { id in
                                    let detail = GoodsDeatilViewController()

                detail.product_id = id
                self.navigationController?.pushViewController(detail, animated: true)
            }
            cell.setData(data: data?.data.product_relation ?? [])
                return cell
        }
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsTipsTableViewCell") as! GoodsTipsTableViewCell
                cell.selectionStyle = .none
                cell.discount.text = data?.data.product.returncontent
                cell.content.text = data?.data.product.recommendcontent
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsHeaderTableViewCell") as! GoodsHeaderTableViewCell
//            cell.price_sort.text = "￥\(data?.data.product.maxPrice ?? "0")"
            cell.setPri(str: "￥\(data?.data.product.maxPrice ?? "0")")
            cell.name.text = data?.data.product.name
            cell.shippingContent.text = "  \(data?.data.product.shippingcontent ?? "") "
            cell.xiao.text = data?.data.product.saleCnt ?? ""
            cell.hao.text = "\(data?.data.product.evaluate_good_per ?? "")"
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 1 {
            if indexPath.row == section1 - 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsTypeTableViewCell") as! GoodsTypeTableViewCell
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
                if option == "" {
                cell.typeName.text = "选择 \(data?.data.getProductOptionGroup()[0].name ?? "")\(data?.data.getProductOptionGroup()[1].name ?? "")"
                } else {
                    for item in data?.data.union ?? [] {
                        if item.productUnion == option {
                            cell.typeName.text = item.productUnionName
                        }
                    }
                }
            return cell
            } else if indexPath.row == section1 - 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsActiveTableViewCell") as! GoodsActiveTableViewCell
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .none
                if data?.data.coupon.count == 0 {
                    cell.bg.isHidden = true
                    cell.info.text = "暂无优惠券"
                } else {
                    cell.bg.isHidden = false
                    cell.info.text = data?.data.coupon.first?.detail ?? ""
                }
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsBrandTableViewCell") as! GoodsBrandTableViewCell
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .none
                cell.name.text = "至 \(addressStr)"
                return cell
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsEvaluateHeaderTableViewCell") as! GoodsEvaluateHeaderTableViewCell
                cell.accessoryType = .disclosureIndicator
                cell.getMoreBtn.addTarget(self, action: #selector(runEvaluateList), for: .touchUpInside)
                cell.lv.text = "\(data?.data.product.evaluate_good_per ?? "")"
                cell.count.text = "用户评价(\(data?.data.product.evaluate_count ?? 0))"
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
                if webViewHeight < 10 { cell.web.loadHTMLString((data?.data.product.productDescription)!, baseURL: URL(string: urlheadr)!)
                cell.web.delegate = self
                }
                cell.selectionStyle = .none
                return cell
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsAddressTableViewCell") as! GoodsAddressTableViewCell
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3, indexPath.row == 1 {
            return CGFloat(webViewHeight + 30)
        }
        if indexPath.section == 4 {
            return CGFloat(relationHeight)
        }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else if section == 2 {
            return 15
        } else if section == 3 {
            return 1
        }
        return 15
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.tableviewBackgroundColor
        if section == 2 {
            let lab = UILabel(frame: CGRect(x: 16, y: 0, width: 300, height: 15))
            lab.text = ""
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
        if indexPath.section == 1, indexPath.row == 2 {

            let addres = AddressListViewController()
            addres.didSelectAddress = {(ad) in
                self.addressStr = ad?.address ?? ""
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(addres, animated: true)
        }
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
            type.didColse = { (option) in
                self.option = option
                self.tableView.reloadData()
            }
            type.didToBuy = { (num,optin) in
                let creat = CreatOrderViewController()
                creat.product_id = self.data?.data.product.id
                creat.quantity = num
                creat.product_option_union_id = optin
                self.navigationController?.pushViewController(creat, animated: true)
            }
        self.present(type, animated: true, completion: nil)
        } else if indexPath.section == 1, indexPath.row == 0 {
            if (data?.data.coupon.count ?? 0) < 1 {
                let type = SelectTypeViewController()
                type.modalPresentationStyle = .custom
                type.data = data
                type.didColse = { (option) in
                    self.option = option
                    self.tableView.reloadData()
                }
                type.didToBuy = { (num,optin) in
                    let creat = CreatOrderViewController()
                    creat.product_id = self.data?.data.product.id
                    creat.quantity = num
                    creat.product_option_union_id = optin
                    self.navigationController?.pushViewController(creat, animated: true)
                }
                self.present(type, animated: true, completion: nil)
                return
            }
            if (data?.data.coupon.count ?? 0) < 1 { return }
            let popUp = GoodsPopUpViewController(popUpType: GoodsPopUpViewController.PopUpType.translate(data: (data?.data.coupon)!))
                popUp.modalPresentationStyle = .custom
            self.present(popUp, animated: false, completion: nil)
        } else if indexPath.section == 1, indexPath.row == 1 {
            if (data?.data.coupon.count ?? 0) < 1 {
                let addres = AddressListViewController()
                addres.didSelectAddress = {(ad) in
                    self.addressStr = ad?.address ?? ""
                    self.tableView.reloadData()
                }
                self.navigationController?.pushViewController(addres, animated: true)
                return
            }
            let type = SelectTypeViewController()
            type.modalPresentationStyle = .custom
            type.data = data
            type.didColse = { (option) in
                self.option = option
                self.tableView.reloadData()
            }
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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 64 {
            topView.backgroundColor = .white
        } else {
            topView.backgroundColor = .white
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

    @objc func playVideo() {
        if let url = URL(string: urlEncode(str: data?.data.product.video ?? "https://app.necesstore.com/upload/video/091138340.png")) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated:true, completion: nil)
        }
    }

    func urlEncode(str: String) -> String {
        return str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://app.necesstore.com/upload/video/091138340.png"

    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "bannerCell", at: index) as! DetailPageCollectionViewCell
        cell.img.af_setImage(withURL: URL(string: (data?.data.productImage[index].image)!)!)

        if !(data?.data.product.video.isEmpty ?? true) {
            if index == 0 {
                cell.btn.isHidden = false
                cell.btn.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
            } else {
                cell.btn.isHidden = true
            }
        } else {
            cell.btn.isHidden = true
        }
        return cell
    }
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        self.setPageLabel(str: "\(pagerView.currentIndex + 1)/\(data?.data.productImage.count ?? 0)")
    }
}
extension GoodsDeatilViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webViewHeight = Double(webView.scrollView.contentSize.height)
        self.tableView.reloadData()
    }
}
