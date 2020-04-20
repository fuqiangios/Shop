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

    var order_type: String = ""
    var selectIndex: Int = -1
    var goodsNum: Double = 0.00
    var data: [Datum] = []
    var addressInfo:AddressDatum? = nil
    var payList: PayList? = nil
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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "填写订单"
        setUp()
        loadData()
        loadPayListData()
        getPrice()
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

    @objc func submitA() {
        if selectIndex < 0 {
            return
        }
        var all: [String] = []
        for item in data {
            all.append(item.id ?? "")
        }
        API.createOrder(order_type: order_type, shopping_cart_ids: all, product_id: product_id, quantity: quantity, product_option_union_id: product_option_union_id, red_packet: "\(redPackegPrice)", customer_coupon_id: discountIndex == -1 ? "" : settlement?.data.coupons[discountIndex].id, address_id: addressInfo?.id, self_store_id: store != nil ? store?.id : "").request { (result) in
                switch result {
                case .success(let data):
                    print("success")
                    if self.order_type == "1" {
                        NotificationCenter.default.post(name: NSNotification.Name("notificationCreatOrder"), object: self, userInfo: [:])
                    }
                    self.amountPay(order_id: data.data.order_id)
                case .failure(let error):
                    print(error)
                    print(error.self)
                    print(error.localizedDescription)
            }
        }
    }

    func amountPay(order_id: String) {
        API.orderPay(order_id: order_id, payment_pfn: payList?.data.payment[selectIndex].pfn ?? "", payment_method: payList?.data.payment[selectIndex].name ?? "").request { (result) in
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
                self.payList = data
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
        numPrice = numPrice + Double(settlement?.data.shippingFee ?? "0.00")!

        priceLable.text = "应付:￥" + String(format: "%.2f", numPrice)
    }

    func loadData() {
        var all: [String] = []
        for item in data {
            all.append(item.id ?? "")
        }
        API.orderSettlement(shopping_cart_ids: all, product_id: product_id, quantity: quantity, product_option_union_id: product_option_union_id).request { (result) in
            switch result {
            case .success(let data):
                self.settlement = data
                self.self.addressInfo = data.data.address
                self.getPrice()
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
            return payList?.data.payment.count ?? 0
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
            if addressInfo != nil {
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
            cell.name.text = payList?.data.payment[indexPath.row].name ?? ""
            cell.img.af_setImage(withURL: URL(string: (payList?.data.payment[indexPath.row].getIcon())!)!)
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
            cell.num.setTitle("共\(settlement?.data.products.count ?? 0)件", for: .normal)
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
            cell.goodsPrice.text = "\(goodsNum)"
            cell.shipingPrice.text = "+\(settlement?.data.shippingFee ?? "")"
            cell.redpackegPrice.text = "-\(redPackegPrice)"
            cell.discount.text = "-\(couponPrice)"
            cell.selectionStyle = .none
            return cell
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
                self.addressInfo = info
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
                self.navigationController?.pushViewController(invoice, animated: true)
            }

        }
    }

}
