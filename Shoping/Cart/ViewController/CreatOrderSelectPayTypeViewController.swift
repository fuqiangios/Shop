//
//  CreatOrderSelectPayTypeViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/1/31.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class CreatOrderSelectPayTypeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var bottomLayout: NSLayoutConstraint!
    @IBOutlet weak var floatView: UIView!
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var price: UILabel!
    var priceText: String = ""
    var data: [Datum] = []
    var addressInfo:AddressDatum? = nil
    var order_type: String = ""
    var selectIndex: Int = -1
    var payList: PayList? = nil
    var redpackgePrice: Double? = 0.00
    var couponId: String? = ""
    var store: Store? = nil
    var product_id: String? = ""
    var quantity: String? = ""
    var product_option_union_id: String? = ""

    var didPaySuccess: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        price.text = priceText
        submitBtn.addTarget(self, action: #selector(submitAction(_:)), for: .touchUpInside)
        setUp()
    }

    override func viewDidAppear(_ animated: Bool) {
    }

    override func viewWillDisappear(_ animated: Bool) {
        view.backgroundColor = .clear
    }

    func setUp() {
        bottomLayout.constant = 0
        floatView.layer.cornerRadius = 5
        floatView.layer.masksToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(UINib(nibName: "CreatOrderPayTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatOrderPayTypeTableViewCell")
        tableView.reloadData()
    }

    @objc func submitAction(_ sender: Any) {
        var all: [String] = []
        for item in data {
            all.append(item.id ?? "")
        }
        API.createOrder(order_type: order_type, shopping_cart_ids: all, product_id: product_id, quantity: quantity, product_option_union_id: product_option_union_id, red_packet: "\(redpackgePrice ?? 0.00)", customer_coupon_id: couponId, address_id: addressInfo?.id, self_store_id: store != nil ? store?.id : "").request { (result) in
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
                    self.didPaySuccess?()
                    self.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    print(error)
                    print(error.self)
                    print(error.localizedDescription)
            }
        }
    }
}
extension CreatOrderSelectPayTypeViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payList?.data.payment.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderPayTypeTableViewCell") as! CreatOrderPayTypeTableViewCell
        cell.name.text = payList?.data.payment[indexPath.row].name ?? ""
        cell.img.af_setImage(withURL: URL(string: (payList?.data.payment[indexPath.row].getIcon())!)!)
        if indexPath.row == selectIndex {
            cell.selectImg.image = UIImage(named: "ic_fu")
        } else {
            cell.selectImg.image = UIImage(named: "ic_ellipse")
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        tableView.reloadData()
    }
}
