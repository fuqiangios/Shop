//
//  IntegraPayViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/16.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class IntegraPayViewController: UIViewController, UITextFieldDelegate {
    var data: PointPut? = nil

    @IBOutlet weak var hei: NSLayoutConstraint!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var point: UILabel!
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pointUnt: UILabel!
    var amount = "0"
    var selectIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(UINib(nibName: "CreatOrderPayTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatOrderPayTypeTableViewCell")
        hei.constant = 120
        input.delegate = self
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        loadData()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        amount = textField.text ?? ""
    }

    func loadData() {
        API.amountPut(type: "1").request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.pointUnt.text = data.data.pointUnit
                self.amount = data.data.amount
                self.point.text = data.data.amount
                self.hei.constant = CGFloat(60*data.data.payment.count)
                self.tableView.reloadData()
            case .failure(let er):
                print(er)
            }
        }
    }

    @IBAction func allAction(_ sender: Any) {
        input.text = data?.data.amount ?? "0"
    }

    @IBAction func payAction(_ sender: Any) {
        API.pointPay(amount: input.text ?? "0", type: "1", payment_pfn: data?.data.payment[selectIndex].pfn ?? "").request { (result) in
            switch result{
            case .success(let data):
               print(data)
               CLProgressHUD.showError(in: self.view, delegate: self, title: data.message, duration: 1)
               self.loadData()
//               self.navigationController?.popViewController(animated: true)
            case .failure(let er):
                print(er)
            }
        }
    }
    @IBAction func bbackAction(_ sender: Any) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.popViewController(animated: true)
    }
}
extension IntegraPayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.data.payment.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderPayTypeTableViewCell") as! CreatOrderPayTypeTableViewCell
        cell.contentView.backgroundColor = .white
        cell.name.text = data?.data.payment[indexPath.row].name
        cell.img.af_setImage(withURL: URL(string: data?.data.payment[indexPath.row].icon ?? "")!)
        if indexPath.row == selectIndex {
            cell.selectImg.image = UIImage(named: "选中")
        } else {
            cell.selectImg.image = UIImage(named: "未选择")
        }
        cell.bindBtn.isHidden = false
        cell.bindBtn.tag = indexPath.row + 200
        cell.bindBtn.addTarget(self, action: #selector(bindAction(btn:)), for: .touchUpInside)
        if (data?.data.payment[indexPath.row].binding_flag ?? false) {
            cell.bindBtn.setTitle("修改", for: .normal)
        }
        cell.selectionStyle = .none
        return cell
    }

    @objc func bindAction(btn: UIButton) {
        if (data?.data.payment[btn.tag - 200].pfn ?? "false") == "WeChatPay" {
            CLProgressHUD.show(in: self.view, delegate: self, tag: 55, title: "")
                               UMSocialManager.default()?.getUserInfo(with: .wechatSession, currentViewController: nil, completion: { (result, er) in
                                   print(result)
                                   print(er)

                                   if er == nil {
                                        let e = result as! UMSocialUserInfoResponse
                                       API.bindWechat(name: e.name, openid: e.openid).request { (e) in
                                           CLProgressHUD.dismiss(byTag: 55, delegate: self, in: self.view)
                                           switch e {
                                           case .success:
                                               self.loadData()
                                               CLProgressHUD.showError(in: self.view, delegate: self, title: "绑定成功", duration: 1)
                                           case .failure:
                                               CLProgressHUD.showError(in: self.view, delegate: self, title: "绑定失败", duration: 1)
                                           }
                                       }
                                   }
                               })
        } else {
            let ali = BindAliPayViewController()
            self.navigationController?.pushViewController(ali, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !(data?.data.payment[indexPath.row].binding_flag ?? false) {
            let ali = BindAliPayViewController()
            self.navigationController?.pushViewController(ali, animated: true)
        } else {
            selectIndex = indexPath.row
            self.tableView.reloadData()
        }
    }

}
