//
//  BalanceChongViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/17.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class BalanceChongViewController: UIViewController {

    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var input: UITextField!
    var data: ChongzhiPage? = nil
    var selectIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension

        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true

        tableView.register(UINib(nibName: "CreatOrderPayTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatOrderPayTypeTableViewCell")
//        hei.constant = 120
        loadData()
    }

    @IBAction func back(_ sender: Any) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func submit(_ sender: Any) {
        API.chongzhi(price: input.text ?? "1", payment_pfn: data?.data.payment[selectIndex].pfn ?? "").request { (result) in
            switch result {
            case .success(let data):
                print(data)
                if self.data?.data.payment[self.selectIndex].pfn == "WeChatPay" {
                    self.wechatPay()
                } else {
                    self.aliPay(str: data.data.plugin)
                }
            case .failure(let er):
                print(er)
            }
        }
    }

    func wechatPay() {
        let req = PayReq()
        req.nonceStr = ""
        req.partnerId = ""
        req.prepayId = ""
        req.timeStamp =  200000
        req.package = ""
        req.sign = ""
        WXApi.send(req) { (item) in
            print(item)
            if item {
                CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "充值成功", duration: 2)
            } else {
                CLProgressHUD.showError(in: self.view, delegate: self, title: "充值失败，请重试", duration: 2)
            }
        }
    }

    func aliPay(str: String) {
        AlipaySDK.defaultService()?.payOrder(str, fromScheme: "wojiayoupin", callback: { (reslt) in
            if reslt!["resultStatus"]as! String == "9000" {
                CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "充值成功", duration: 2)
            } else {
                CLProgressHUD.showError(in: self.view, delegate: self, title: "充值失败，请重试", duration: 2)
            }
        })
    }

    func loadData() {
        API.chongzhiPage().request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                print(data)
                self.tableView.reloadData()
            case .failure(let er):
                print(er)
            }
        }
    }
}
extension BalanceChongViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.data.payment.count ?? 0
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderPayTypeTableViewCell") as! CreatOrderPayTypeTableViewCell
            cell.name.text = data?.data.payment[indexPath.row].name ?? ""
            cell.img.af_setImage(withURL: URL(string: (data?.data.payment[indexPath.row].icon)!)!)
            if indexPath.row == selectIndex {
                cell.selectImg.image = UIImage(named: "选中")
            } else {
                cell.selectImg.image = UIImage(named: "未选择")
            }
            cell.contentView.backgroundColor = .white
            cell.selectionStyle = .none
            return cell
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectIndex = indexPath.row
            self.tableView.reloadData()
        }
}
