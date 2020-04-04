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

    var data: [Datum] = []
    var addressInfo:AddressDatum? = nil
    var payList: PayList? = nil
    var quantity: String? = nil
    var product_id: String? = nil
    var product_option_union_id: String? = nil
    var settlement: OrderSettlement? = nil
    var discountIndex = 0
    var isUseRedpackeg: Bool = false
    var redPackegPrice: Double = 0.00
    var couponPrice: Double = 0.00
    var price: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "填写订单"
        setUp()
        loadData()
        loadPayListData()
        getPrice()
    }

    func setUp() {
        creatBtn.layer.cornerRadius = 5
        creatBtn.layer.masksToBounds = true
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
    }

    func loadPayListData() {
        API.payList(order_id: nil).request { (result) in
            switch result {
            case .success(let data):
                self.payList = data
            case .failure(let error):
                print(error)
                print(error.self)
                print(error.localizedDescription)
            }
        }
    }

    @IBAction func submitAction(_ sender: Any) {
        if storeSelect, store == nil {
            return
        }
         let selectPay = CreatOrderSelectPayTypeViewController()
        selectPay.data = data
        selectPay.order_type = storeSelect ? "2" : "1"
        selectPay.priceText = priceLable.text ?? ""
        selectPay.addressInfo = addressInfo
        selectPay.payList = payList
        selectPay.redpackgePrice = redPackegPrice
        selectPay.couponId = discountIndex == 0 ? "" : settlement?.data.coupons[discountIndex - 1].id
        selectPay.store = store
        selectPay.product_option_union_id = product_option_union_id
        selectPay.product_id = product_id
        selectPay.quantity = quantity
        selectPay.didPaySuccess = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        self.present(selectPay, animated: true, completion: nil)
    }

    func getPrice() {
        if isUseRedpackeg {
            redPackegPrice = Double(settlement?.data.redPackage ?? "0.00")!
        } else {
            redPackegPrice = 0.00
        }

        if discountIndex != 0 {
            couponPrice = Double(settlement?.data.coupons[discountIndex - 1].faceValue ?? "0.00")!
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
        numPrice = numPrice - redPackegPrice - couponPrice
        numPrice = numPrice + Double(settlement?.data.shippingFee ?? "0.00")!
        priceLable.text = "共\(data.count)件 合计:￥" + String(format: "%.2f", numPrice)
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
        if section == 2 {
            return settlement?.data.products.count ?? 0
        }
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderAddressTableViewCell") as! CreatOrderAddressTableViewCell
            if addressInfo != nil {
                cell.name.text = (addressInfo?.name ?? "") + "  " + (addressInfo?.telephone ?? "")
                cell.addressInfo.text = (addressInfo?.address ?? "") + (addressInfo?.detail ?? "")
             }
        cell.selectionStyle = .none
        return cell
        } else if indexPath.section == 1 {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderDiscountTableViewCell") as! CreatOrderDiscountTableViewCell
            cell.selectionStyle = .none
            cell.redPack.text = "剩余红包：￥\(settlement?.data.redPackage ?? "")"
            cell.discount.addTarget(self, action: #selector(selectDiscount), for: .touchUpInside)
            if discountIndex == 0 {
                cell.discount.setTitle("不使用", for: .normal)
            } else {
                cell.discount.setTitle(settlement?.data.coupons[discountIndex - 1].detail, for: .normal)
            }
            cell.sw.isOn = isUseRedpackeg
            cell.sw.addTarget(self, action: #selector(switchChange(switcah:)), for: .valueChanged)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderAccountTableViewCell") as! CreatOrderAccountTableViewCell
            cell.goodsPrice.text = "红包抵值 -￥\(redPackegPrice)"
            cell.redpackegPrice.text = "-\(couponPrice)"
            cell.shipingPrice.text = "+\(settlement?.data.shippingFee ?? "")"
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
            let store = CreatOrderSelectStoreViewController()
            store.didSelectStore = { store in
                if let store = store {
                    self.store = store
                    self.tableView.reloadData()
                }
            }
            store.settlement = settlement
            self.navigationController?.pushViewController(store, animated: true)
        }
    }

}
