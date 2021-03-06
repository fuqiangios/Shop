//
//  BalanceChongViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/17.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class BalanceChongViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var input: UITextField!
    var data: ChongzhiPage? = nil
    var selectIndex = 0
    
    @IBOutlet weak var hei: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction(noti:)), name: NSNotification.Name(rawValue: "weixinpaymethod"), object: nil)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .white
        input.delegate = self
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true

        tableView.register(UINib(nibName: "CreatOrderPayTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatOrderPayTypeTableViewCell")
//        hei.constant = 120
        loadData()
    }

    deinit {
           NotificationCenter.default.removeObserver(self)
       }
       @objc private func notificationAction(noti: Notification) {
           let isRet = noti.object as! String

           if isRet == "1" {
               //支付成功
              CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "充值成功", duration: 2)
            self.navigationController?.popViewController(animated: true)
           } else {
               //支付失败
               CLProgressHUD.showError(in: self.view, delegate: self, title: "充值失败，请重试", duration: 2)
           }
       }

    func textField(_ textField:UITextField, shouldChangeCharactersIn range:NSRange, replacementString string:String) ->Bool{



               let futureString:NSMutableString=NSMutableString(string: textField.text!)



               futureString.insert(string, at: range.location)

               var flag = 0;



               let limited = 2;//小数点后需要限制的个数



               if !futureString.isEqual(to:"") {

                   for i in stride(from: futureString.length-1,through:0, by:-1) {



                       let char = Character(UnicodeScalar(futureString.character(at: i))!)

                       if char=="." {

                           if flag>limited {

                               return false

                           }

                           break

                       }

                       flag+=1

                   }

               }



               return true

           }

    @IBAction func back(_ sender: Any) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func submit(_ sender: Any) {
        let oneChar = (input.text ?? "")[(input.text ?? "").startIndex]
        if oneChar == "." {
            CLProgressHUD.showError(in: self.view, delegate: self, title: "请输入正确充值金额", duration: 2)
            return
        }
        API.chongzhi(price: input.text ?? "1", payment_pfn: data?.data.payment[selectIndex].pfn ?? "").request { (result) in
            switch result {
            case .success(let data):
                print(data)
                if data.data.plugin?.isEmpty ?? true {
                    return
                }
                if self.data?.data.payment[self.selectIndex].pfn == "WeChatPay" {
                    self.wechatPay(data: data)
                } else {
                    self.aliPay(str: data.data.plugin ?? "")
                }
            case .failure(let er):
                print(er)
            }
        }
    }

    func wechatPay(data: Chongzhi) {
        let array : Array = (data.data.plugin ?? "").components(separatedBy: ",")
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
                CLProgressHUD.showError(in: self.view, delegate: self, title: "充值失败，请重试", duration: 2)
            }
        }
    }

    

    func aliPay(str: String) {
        AlipaySDK.defaultService()?.payOrder(str, fromScheme: "wojiayoupin", callback: { (reslt) in
            if reslt!["resultStatus"]as! String == "9000" {
                CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "充值成功", duration: 2)
                self.navigationController?.popViewController(animated: true)
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
                self.hei.constant = CGFloat(60*data.data.payment.count)
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
