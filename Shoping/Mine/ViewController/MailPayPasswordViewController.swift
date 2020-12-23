//
//  PayPasswordViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/5/22.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class MailPayPasswordViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var password: UITextField!

    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var code: UITextField!
    @IBOutlet weak var surePassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置支付密码"
        submit.layer.cornerRadius = 10
        submit.layer.masksToBounds = true
        code.text = UserSetting.default.activeUserMail
        code.isEnabled = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func getCode(_ sender: UIButton) {
        let phoneStr = UserSetting.default.activeUserPhone ?? ""
        if phoneStr.count == 11 {
                  API.getCode(telephone: phoneStr).request { (result) in
                      switch result {
                      case .success:
                          print("success")
                          self.timeChange(btn: sender)
                      case .failure(let error):
                          CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "发送失败，请重试", duration: 1)
                          print(error)
                          print(error.self)
                          print(error.localizedDescription)
                      }
                  }
              }
          }

          func timeChange(btn: UIButton) {

                  var time = 120
                  let codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
                  codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))  //此处方法与Swift 3.0 不同
                  codeTimer.setEventHandler {

                      time = time - 1

                      DispatchQueue.main.async {
                          btn.isEnabled = false
                      }

                      if time < 0 {
                          codeTimer.cancel()
                          DispatchQueue.main.async {
                              btn.isEnabled = true
                              btn.setTitle("重新发送", for: .normal)
                          }
                          return
                      }

                      DispatchQueue.main.async {
                          btn.setTitle("\(time)秒", for: .normal)
                      }

                  }

                  codeTimer.activate()

          }

    @IBAction func submitAction(_ sender: Any) {
        if password.text?.count != 6 {
            CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "请输入6位数字密码", duration: 1)
            return
        }
        if password.text == surePassword.text, password.text?.count == 6 {
            API.mailPayPassword(email: UserSetting.default.activeUserMail ?? "", pay_password: password.text ?? "").request(completionHandle: { (result) in
                switch result {
                case .success(let data):
                    if data.status == 200 {
                    self.navigationController?.popViewController(animated: true)
                    CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "密码设置成功", duration: 1)
                    } else {
                        CLProgressHUD.showSuccess(in: self.view, delegate: self, title: data.message, duration: 1)
                    }
                case .failure(let er):
                    print(er)
                }
            })
        } else {
            CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "两次输入密码不一致", duration: 1)
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(string)
        return true
    }
}
