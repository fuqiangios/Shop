//
//  CreatOrderViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/1/30.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class CreatOrderViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var creatBtn: UIButton!

    @IBOutlet weak var priceLable: UILabel!
    var store: Store? = nil
    var storeSelect: Bool = false
    var orderId = ""

    var order_type: String = ""
    var selectIndex: Int = 0
    var goodsNum: Double = 0.00
    var data: [Cart] = []
    var addressInfo:AddressDatum? = nil
    var payList: [SettlePayment] = []
    var quantity: String? = nil
    var product_id: String? = nil
    var product_option_union_id: String? = nil
    var settlement: OrderSettlement? = nil
    var discountIndex = -1
    var isUseRedpackeg: Bool = false
    var redPackegPrice: Double = 0.00
    var couponPrice: Double = 0.00
    var price: String? = nil
    var useRedpackg: Bool = false
    var usepiao: Bool = false
    var invoice_id = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "填写订单"
        setUp()
        loadData()
        loadPayListData()
        getPrice()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction(noti:)), name: NSNotification.Name(rawValue: "weixinpaymethod"), object: nil)
    }

    func setUp() {
//        creatBtn.layer.cornerRadius = 5
//        creatBtn.layer.masksToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "CreatOrderAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatOrderAddressTableViewCell")
        tableView.register(UINib(nibName: "CreatOrderShopSelfMentionTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatOrderShopSelfMentionTableViewCell")
        tableView.register(UINib(nibName: "CreatOrderGoodsTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatOrderGoodsTableViewCell")
        tableView.register(UINib(nibName: "CreatOrderDiscountTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatOrderDiscountTableViewCell")
        tableView.register(UINib(nibName: "CreatOrderAccountTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatOrderAccountTableViewCell")
        tableView.register(UINib(nibName: "CreatOrderPayTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatOrderPayTypeTableViewCell")
        tableView.register(UINib(nibName: "CreatOrderMoreGoodsTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatOrderMoreGoodsTableViewCell")
        tableView.register(UINib(nibName: "CreateOrderYuiTableViewCell", bundle: nil), forCellReuseIdentifier: "CreateOrderYuiTableViewCell")
        tableView.register(UINib(nibName: "CreatOrderRedTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatOrderRedTableViewCell")
    }

    func amountPayPassword() {
        let popUp = PayPasswordPopupViewController()
        popUp.modalPresentationStyle = .custom
        popUp.didCofirmPassword = { code in
            self.apiAction(code: code)
        }
        popUp.didToSet = {
            if UserSetting.default.activeUserPhone != nil {
                                let payPassword = PayPasswordViewController()
                self.navigationController?.pushViewController(payPassword, animated: true)
            } else {
                let payPassword = MailPayPasswordViewController()
                self.navigationController?.pushViewController(payPassword, animated: true)
            }
        }
        self.present(popUp, animated: false, completion: nil)
    }

    func apiAction(code: String) {
        if selectIndex < 0 {
            return
        }
        var all: [String] = []
        for item in data {
            all.append(item.id)
        }
        if addressInfo?.id?.isEmpty ?? true {
            CLProgressHUD.showError(in: view, delegate: self, title: "请选择收货地址", duration: 1)
            return
        }
        API.createOrder(order_type: order_type, shopping_cart_ids: all, product_id: product_id, quantity: quantity, product_option_union_id: product_option_union_id, red_packet: "\(redPackegPrice)", customer_coupon_id: discountIndex == -1 ? "" : settlement?.data.coupons[discountIndex].id, address_id: addressInfo?.id, self_store_id: store != nil ? store?.id : "", store_id: settlement?.data.store_id ?? "", payment_pfn: payList[selectIndex].pfn , payment_method: payList[selectIndex].name , invoice_id: usepiao ? invoice_id : "", pay_password: code).request { (result) in
                switch result {
                case .success(let data):
                    if data.status != 200 {
                        CLProgressHUD.showError(in: self.view, delegate: self, title: data.message, duration: 1)
                        return
                    }
                    print("success")
                    if self.payList[self.selectIndex].pfn == "Amount" {
//                                       let detail = OederDetailViewController()
//                        detail.order_id = data.data.order_id
//                        detail.backType = "cart"
//                         self.navigationController?.pushViewController(detail, animated: true)
                        let or = OrderViewController()
                        or.tab_status = "0"
                        or.backType = "cart"
                        self.navigationController?.pushViewController(or, animated: true)

                    } else if self.payList[self.selectIndex].pfn == "WeChatPay" {
                        self.orderId = data.data.order_id
                        self.wechatPay(data: data)
                    } else {
                        if data.data.plugin == "" {
                            let or = OrderViewController()
                            or.backType = "cart"
                            or.tab_status = "0"
                            self.navigationController?.pushViewController(or, animated: true)
//                            let detail = OederDetailViewController()
//                            detail.order_id = data.data.order_id
//                            detail.backType = "cart"
//                             self.navigationController?.pushViewController(detail, animated: true)
                        } else {
                            self.aliPay(str: data.data.plugin,id: data.data.order_id)
                        }
                    }
                    if self.order_type == "1" {
                        NotificationCenter.default.post(name: NSNotification.Name("notificationCreatOrder"), object: self, userInfo: [:])
                    }
                    self.checkPlanLuck()
                case .failure(let error):
                    print(error)
                    print(error.self)
                    print(error.localizedDescription)
                    CLProgressHUD.showError(in: self.view, delegate: self, title: "支付失败，请重试", duration: 1)
            }
        }
    }

    @objc func submitA() {
        if selectIndex < 0 {
            return
        }
        var all: [String] = []
        for item in data {
            all.append(item.id)
        }
        if addressInfo?.id?.isEmpty ?? true {
            CLProgressHUD.showError(in: view, delegate: self, title: "请选择收货地址", duration: 1)
            return
        }
        if self.payList[self.selectIndex].pfn == "Amount" {
            amountPayPassword()
            return
        }
        if redPackegPrice > 0 {
            amountPayPassword()
            return
        }
        API.createOrder(order_type: order_type, shopping_cart_ids: all, product_id: product_id, quantity: quantity, product_option_union_id: product_option_union_id, red_packet: "\(redPackegPrice)", customer_coupon_id: discountIndex == -1 ? "" : settlement?.data.coupons[discountIndex].id, address_id: addressInfo?.id, self_store_id: store != nil ? store?.id : "", store_id: settlement?.data.store_id ?? "", payment_pfn: payList[selectIndex].pfn , payment_method: payList[selectIndex].name , invoice_id: usepiao ? invoice_id : "", pay_password: "").request { (result) in
                switch result {
                case .success(let data):
                    if data.status != 200 {
                        CLProgressHUD.showError(in: self.view, delegate: self, title: data.message, duration: 1)
                        return
                    }
                    print("success")
                    if self.payList[self.selectIndex].pfn == "Amount" {
                        let or = OrderViewController()
                        or.backType = "cart"
                        or.tab_status = "0"
                        self.navigationController?.pushViewController(or, animated: true)
//                                       let detail = OederDetailViewController()
//                        detail.order_id = data.data.order_id
//                        detail.backType = "cart"
//                         self.navigationController?.pushViewController(detail, animated: true)
                    } else if self.payList[self.selectIndex].pfn == "WeChatPay" {
                        self.orderId = data.data.order_id
                        self.wechatPay(data: data)
                    } else {
                        if data.data.plugin == "" {
                            let or = OrderViewController()
                            or.backType = "cart"
                            or.tab_status = "0"
                            self.navigationController?.pushViewController(or, animated: true)
//                            let detail = OederDetailViewController()
//                            detail.order_id = data.data.order_id
//                            detail.backType = "cart"
//                             self.navigationController?.pushViewController(detail, animated: true)
                        } else {
                            self.aliPay(str: data.data.plugin,id: data.data.order_id)
                        }
                    }
                    if self.order_type == "1" {
                        NotificationCenter.default.post(name: NSNotification.Name("notificationCreatOrder"), object: self, userInfo: [:])
                    }
                    self.checkPlanLuck()
                case .failure(let error):
                    print(error)
                    print(error.self)
                    print(error.localizedDescription)
                    CLProgressHUD.showError(in: self.view, delegate: self, title: "支付失败，请重试", duration: 1)
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc private func notificationAction(noti: Notification) {
//        let isRet = noti.object as! String
//        let detail = OederDetailViewController()
//         detail.order_id = orderId
//         detail.backType = "cart"
//         self.navigationController?.pushViewController(detail, animated: true)
        let or = OrderViewController()
        or.backType = "cart"
        or.tab_status = "0"
        self.navigationController?.pushViewController(or, animated: true)
    }

    func wechatPay(data: PayOrder) {
        let array : Array = data.data.plugin.components(separatedBy: ",")
        let req = PayReq()
        req.nonceStr = array[1]
        req.partnerId = array[3]
        req.prepayId = array[4]
        req.timeStamp = UInt32(array[6]) ?? 100000
        req.package = array[2]
        req.sign = array[5]
        WXApi.send(req) { (item) in
            print(item)
            if item {

            } else {
                CLProgressHUD.showError(in: self.view, delegate: self, title: "支付失败，请重试", duration: 2)
            }
        }
    }

    func aliPay(str: String, id: String) {
        AlipaySDK.defaultService()?.payOrder(str, fromScheme: "wojiayoupin", callback: { (reslt) in
//            if reslt!["resultStatus"]as! String == "9000" {
//               let detail = OederDetailViewController()
//                detail.order_id = id
//                detail.backType = "cart"
//                self.navigationController?.pushViewController(detail, animated: true)
            let or = OrderViewController()
            or.backType = "cart"
            or.tab_status = "0"
            self.navigationController?.pushViewController(or, animated: true)

//            } else {
//                CLProgressHUD.showError(in: self.view, delegate: self, title: "支付失败，请重试", duration: 2)
//            }
        })
    }

    func amountPay(order_id: String) {
        API.orderPay(order_id: order_id, payment_pfn: payList[selectIndex].pfn ?? "", payment_method: payList[selectIndex].pfn ?? "").request { (result) in
            switch result {
                case .success:
                    print("success")
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print(error)
                    print(error.self)
                    print(error.localizedDescription)
            }
        }
    }

    func loadPayListData() {
        API.payList(order_id: nil).request { (result) in
            switch result {
            case .success(let data):
//                self.payList = data
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
                print(error.self)
                print(error.localizedDescription)
            }
        }
    }

    @IBAction func submitAction(_ sender: Any) {
        submitA()
//        if storeSelect, store == nil {
//            return
//        }
//         let selectPay = CreatOrderSelectPayTypeViewController()
//        selectPay.data = data
//        selectPay.order_type = storeSelect ? "2" : "1"
//        selectPay.priceText = priceLable.text ?? ""
//        selectPay.addressInfo = addressInfo
//        selectPay.payList = payList
//        selectPay.redpackgePrice = redPackegPrice
//        selectPay.couponId = discountIndex == 0 ? "" : settlement?.data.coupons[discountIndex - 1].id
//        selectPay.store = store
//        selectPay.product_option_union_id = product_option_union_id
//        selectPay.product_id = product_id
//        selectPay.quantity = quantity
//        selectPay.didPaySuccess = { [weak self] in
//            self?.navigationController?.popViewController(animated: true)
//        }
//        self.present(selectPay, animated: true, completion: nil)
    }

    func getPrice() {
        if useRedpackg {
            redPackegPrice = Double(settlement?.data.redPackage ?? "0.00")!
        } else {
            redPackegPrice = 0.00
        }


        if discountIndex != -1 {
            couponPrice = Double(settlement?.data.coupons[discountIndex ].faceValue ?? "0.00")!
        } else {
            couponPrice = 0.00
        }

        var numPrice:Double = 0.00
        for item in data {
            let price = Double(item.price)
            let numCnt = Double(item.quantity)
            let p = (price ?? 0.00)*(numCnt ?? 0.00)
            numPrice = numPrice + p
        }
        if data.count == 0 {
            let p = Double(settlement?.data.products[0].price ?? "0")
            let n = Double(settlement?.data.products[0].quantity ?? "0")
            numPrice = (p ?? 0)*(n ?? 0)
        }
        goodsNum = numPrice

        let ship = Double(settlement?.data.shippingFee ?? "0.00")
        if redPackegPrice >= (numPrice + (ship ?? 0.00) - couponPrice) {
            redPackegPrice = (numPrice + (ship ?? 0.00) - couponPrice)
        }
        numPrice = numPrice - redPackegPrice - couponPrice
        numPrice = numPrice + (Double(settlement?.data.shippingFee ?? "0.00") ?? 0.00)

        priceLable.text = "应付:￥" + String(format: "%.2f", numPrice)
    }

    func loadData() {
        var all: [String] = []
        for item in data {
            all.append(item.id)
        }
        API.orderSettlement(shopping_cart_ids: all, product_id: product_id, quantity: quantity, product_option_union_id: product_option_union_id, address_id: addressInfo?.id ?? "").request { (result) in
            switch result {
            case .success(let data):
                self.settlement = data
                self.payList = data.data.payment
                self.addressInfo = data.data.address
                self.getPrice()
                self.invoice_id = data.data.invoice.id ?? ""
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
extension CreatOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 20 {
            return settlement?.data.products.count ?? 0
        }
        if section == 1 {
            return payList.count
        }
        if section == 3 {
            return 3
        }
        if section == 2 {
            return 1
        }
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    @objc func useRedpackgActionn() {
        useRedpackg = !useRedpackg
        getPrice()
        tableView.reloadData()
    }

    @objc func usePiao() {
        usepiao = !usepiao
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderAddressTableViewCell") as! CreatOrderAddressTableViewCell
            if !(addressInfo?.telephone?.isEmpty ?? true) {
                if addressInfo?.isDefault == "1" {
                    cell.name.text = addressInfo?.address ?? ""
                    cell.defaultBg.isHidden = false
                    cell.defaultText.isHidden = false
                    cell.nna.constant = 16
                    cell.bbba.constant = 45
                } else {
                    cell.name.text = ""
                    cell.defaultBg.isHidden = true
                    cell.defaultText.isHidden = true
                    cell.nna.constant = 0
                    cell.bbba.constant = 20
                }

                cell.addressInfo.text = (addressInfo?.address ?? "") + (addressInfo?.detail ?? "")
                cell.phone.text = (addressInfo?.name ?? "") + " " + (addressInfo?.telephone ?? "")
             }
        cell.selectionStyle = .none
        return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderPayTypeTableViewCell") as! CreatOrderPayTypeTableViewCell
            cell.name.text = payList[indexPath.row].name
            cell.img.af_setImage(withURL: URL(string: (payList[indexPath.row].getIcon()))!)
            if indexPath.row == selectIndex {
                cell.selectImg.image = UIImage(named: "选中")
            } else {
                cell.selectImg.image = UIImage(named: "未选择")
            }
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderShopSelfMentionTableViewCell") as! CreatOrderShopSelfMentionTableViewCell
            cell.selectionStyle = .none
            if store != nil {
                cell.name.text = store?.name ?? ""
            } else {
                cell.name.text = ""
            }
            cell.sw.addTarget(self, action: #selector(storeSwitchChange(switcah:)), for: .valueChanged)
            cell.sw.isOn = storeSelect
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderMoreGoodsTableViewCell") as! CreatOrderMoreGoodsTableViewCell
            if settlement?.data.products.count ?? 0 > 0 {
                let item = settlement?.data.products[0]
                cell.img1.af_setImage(withURL: URL(string: item!.image)!)

            }
            if settlement?.data.products.count ?? 0 > 1 {
                let item1 = settlement?.data.products[1]
                cell.img2.af_setImage(withURL: URL(string: item1!.image)!)
            }
            if settlement?.data.products.count ?? 0 > 2 {
                let item1 = settlement?.data.products[2]
                cell.img3.af_setImage(withURL: URL(string: item1!.image)!)
            }
            if settlement?.data.products.count ?? 0 > 3 {
                let item1 = settlement?.data.products[3]
                cell.img4.af_setImage(withURL: URL(string: item1!.image)!)
            }
            cell.num.setTitle("共\(settlement?.data.products.count ?? 0)种", for: .normal)
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 20 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderGoodsTableViewCell") as! CreatOrderGoodsTableViewCell
            let item = settlement?.data.products[indexPath.row]
            cell.img.af_setImage(withURL: URL(string: item!.image)!)
            cell.name.text = item?.name ?? ""
            cell.price.text = "￥\(item?.price ?? "0")"
            cell.info.text = item?.optionUnionName ?? ""
            cell.num.text = "X\(item?.quantity ?? "0")"
            cell.selectionStyle = .none
            cell.shadow()
            return cell
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CreateOrderYuiTableViewCell") as! CreateOrderYuiTableViewCell
                if discountIndex == -1 {
                    if settlement?.data.coupons.count ?? 0 > 0 {
                        cell.name.text = "不使用"
                    }
                } else {
                cell.name.text = settlement?.data.coupons[discountIndex ].detail
                }
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderRedTableViewCell") as! CreatOrderRedTableViewCell
                if indexPath.row == 1 {
                    cell.name.text = "红包余额: \(settlement?.data.redPackage ?? "")"
                    cell.img.isHidden = true
                    cell.btn.addTarget(self, action: #selector(useRedpackgActionn), for: .touchUpInside)
                    if useRedpackg {
                        cell.select.image = UIImage(named: "选中_矩形")
                    } else {
                        cell.select.image = UIImage(named: "未选择矩形")
                    }
                } else {
                    cell.name.text = "我要开发票"
                    cell.img.isHidden = false
                    cell.btn.addTarget(self, action: #selector(usePiao), for: .touchUpInside)
                    if usepiao {
                        cell.select.image = UIImage(named: "选中_矩形")
                    } else {
                        cell.select.image = UIImage(named: "未选择矩形")
                    }
                }
                cell.selectionStyle = .none
                return cell
            }
        }
        else if indexPath.section == 30 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderDiscountTableViewCell") as! CreatOrderDiscountTableViewCell
            cell.selectionStyle = .none
            cell.redPack.text = "剩余红包：￥\(settlement?.data.redPackage ?? "")"
            cell.discount.addTarget(self, action: #selector(selectDiscount), for: .touchUpInside)
            if discountIndex == 0 {
                cell.discount.setTitle("不使用", for: .normal)
            } else {
                cell.discount.setTitle(settlement?.data.coupons[discountIndex].detail, for: .normal)
            }
            cell.sw.isOn = isUseRedpackeg
            cell.sw.addTarget(self, action: #selector(switchChange(switcah:)), for: .valueChanged)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderAccountTableViewCell") as! CreatOrderAccountTableViewCell
            cell.goodsPrice.text = String(format: "%.2f", goodsNum)
            cell.shipingPrice.text = "+\(settlement?.data.shippingFee ?? "")"
            cell.redpackegPrice.text = "-\(redPackegPrice)"
            cell.discount.text = "-\(couponPrice)"
            cell.selectionStyle = .none
            return cell
        }
    }

    func checkPlanLuck() {
        if UserSetting.default.activeUserToken == nil {
            return
        }
        API.checkPlanLuck(user_token: UserSetting.default.activeUserToken ?? "").request { (result) in
            switch result {
            case .success(let data):
                print("d-s-s-s-\(data.data.plan_luck_id)")
                if data.data.plan_luck_id != "0" {
                    let redPackRain = RedPackageRainViewController()
                    redPackRain.plan_luck_id = data.data.plan_luck_id
                    redPackRain.modalPresentationStyle = .custom
                    redPackRain.closeRedPackRainAndJumpHistory = { op in
                        if op == 1 {
                            let history = RedPackRainHistoryViewController()
                            let nav = UINavigationController.init(rootViewController: history)
                            nav.modalPresentationStyle = .custom
                            self.present(nav, animated: false, completion: nil)
                        }
                    }
                    self.present(redPackRain, animated: false, completion: nil)
                }
            case .failure(let er):
                print(er)

            }
        }
    }

    @objc func switchChange(switcah: UISwitch) {
        isUseRedpackeg = switcah.isOn
        getPrice()
        tableView.reloadData()
    }

    @objc func storeSwitchChange(switcah: UISwitch) {
        storeSelect = switcah.isOn
    }

    @objc func selectDiscount() {
        let selectDiscount = CreatOrderSelectDiscountViewController()
        selectDiscount.settlement = settlement
        selectDiscount.selectIndex = discountIndex
        selectDiscount.didSelectDiscount = { index in
            self.discountIndex = index
            self.getPrice()
            self.tableView.reloadData()
        }
        self.present(selectDiscount, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let address = AddressListViewController()
            address.didSelectAddress = { info in
                print("-=-=-=-=-=-=-=-=-\(info)")
                self.addressInfo = info
                self.loadData()
                tableView.reloadData()
            }
            self.navigationController?.pushViewController(address, animated: true)
        } else if indexPath.section == 1 {
            selectIndex = indexPath.row
            tableView.reloadData()
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                selectDiscount()
            } else if indexPath.row == 2 {
                let invoice = InvoiceViewController()
                invoice.price = "\(goodsNum)"
                self.navigationController?.pushViewController(invoice, animated: true)
            }

        }
    }

}
