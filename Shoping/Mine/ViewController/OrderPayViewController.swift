//
//  OrderPayViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/3/6.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class OrderPayViewController: UIViewController {
    @IBOutlet weak var price: UILabel!

    @IBOutlet weak var payName: UILabel!
    @IBOutlet weak var tableVIewHeight: NSLayoutConstraint!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var metch: UILabel!
    var selectIndex: Int = 0
    var payList: PayList? = nil
    var order_id: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "待支付"
        setUp()
        loadPayListData()
    }

    func setUp() {
        tableVIew.register(UINib(nibName: "OrderPayTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderPayTableViewCell")
        tableVIew.delegate = self
        tableVIew.dataSource = self
        tableVIew.estimatedRowHeight = 150
        tableVIew.rowHeight = UITableView.automaticDimension
        tableVIew.separatorStyle = .none

        submitBtn.addTarget(self, action: #selector(amountPay), for: .touchUpInside)
    }

    func amountPayPassword() {
            let popUp = PayPasswordPopupViewController()
            popUp.modalPresentationStyle = .custom
            popUp.didCofirmPassword = { code in
                self.apiAction(code: code)
            }
            popUp.didToSet = {
                let payPassword = PayPasswordViewController()
                self.navigationController?.pushViewController(payPassword, animated: true)
            }
            self.present(popUp, animated: false, completion: nil)
        }

    func apiAction(code: String) {
         API.getOrderPay(order_id: order_id, payment_pfn: payList?.data.payment[selectIndex].pfn ?? "", pay_password: code).request { (result) in
             switch result {
             case .success(let data):
                 if data.status != 200 {
                     CLProgressHUD.showError(in: self.view, delegate: self, title: data.message, duration: 1)
                 } else {
                 if self.payList?.data.payment[self.selectIndex].pfn ?? "" == "Amount" {
                     self.navigationController?.popViewController(animated: true)
                 } else if self.payList?.data.payment[self.selectIndex].pfn ?? "" == "WeChatPay" {
                     self.wechatPay(data: data.data.plugin ?? "")
                 } else {
                     self.aliPay(str: data.data.plugin ?? "")
                 }
                 }
                 print(data)
             case .failure(let er):
                 CLProgressHUD.showError(in: self.view, delegate: self, title: "支付失败，请重试", duration: 1)
             }
         }
    }

    @objc func amountPay() {
        if (payList?.data.payment[selectIndex].pfn ?? "") == "Amount" {
            amountPayPassword()
            return
        }
        API.getOrderPay(order_id: order_id, payment_pfn: payList?.data.payment[selectIndex].pfn ?? "", pay_password: "").request { (result) in
            switch result {
            case .success(let data):
                if data.status != 200 {
                    CLProgressHUD.showError(in: self.view, delegate: self, title: data.message, duration: 1)
                } else {
                if self.payList?.data.payment[self.selectIndex].pfn ?? "" == "Amount" {
                    self.navigationController?.popViewController(animated: true)
                } else if self.payList?.data.payment[self.selectIndex].pfn ?? "" == "WeChatPay" {
                    self.wechatPay(data: data.data.plugin ?? "")
                } else {
                    self.aliPay(str: data.data.plugin ?? "")
                }
                }
                print(data)
            case .failure(let er):
                CLProgressHUD.showError(in: self.view, delegate: self, title: "支付失败，请重试", duration: 1)
            }
        }
    }

    func wechatPay(data: String) {
        let array : Array = data.components(separatedBy: ",")
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
                self.navigationController?.popViewController(animated: true)
            } else {
                CLProgressHUD.showError(in: self.view, delegate: self, title: "支付失败，请重试", duration: 2)
            }
        }
    }

    func aliPay(str: String) {
        AlipaySDK.defaultService()?.payOrder(str, fromScheme: "wojiayoupin", callback: { (reslt) in
            if reslt!["resultStatus"]as! String == "9000" {
                self.navigationController?.popViewController(animated: true)
            } else {
                CLProgressHUD.showError(in: self.view, delegate: self, title: "支付失败，请重试", duration: 2)
            }
        })
    }

    func loadPayListData() {
        API.payList(order_id: order_id).request { (result) in
            switch result {
            case .success(let data):
                self.payList = data
                self.tableVIew.reloadData()
                self.price.text = data.data.price
                self.payName.text = self.payList?.data.payment[self.selectIndex].name
                self.tableVIewHeight.constant = CGFloat(82 * data.data.payment.count)
            case .failure(let error):
                print(error)
                print(error.self)
                print(error.localizedDescription)
            }
        }
    }

}
extension OrderPayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payList?.data.payment.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPayTableViewCell") as! OrderPayTableViewCell
        cell.name.text = payList?.data.payment[indexPath.row].name ?? ""
        cell.img.af_setImage(withURL: URL(string: (payList?.data.payment[indexPath.row].getIcon())!)!)
        if indexPath.row == selectIndex {
            cell.selectImg.image = UIImage(named: "ic_fu")
        } else {
            cell.selectImg.image = UIImage(named: "ic_ellipse")
        }
        cell.contentView.backgroundColor = .white
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        self.payName.text = self.payList?.data.payment[self.selectIndex].name
        tableView.reloadData()
    }

}
