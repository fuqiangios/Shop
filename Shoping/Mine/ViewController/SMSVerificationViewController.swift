//
//  SMSVerificationViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/5/20.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class SMSVerificationViewController: UIViewController {
    @IBOutlet weak var phone: UITextField!

    @IBOutlet weak var zPassword: UITextField!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var getCode: UIButton!
    @IBOutlet weak var code: UITextField!

    var phoneStr = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "密码修改"
        submit.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        getCode.addTarget(self, action: #selector(getCodeAction(sender:)), for: .touchUpInside)
    }

    @objc func submitAction() {
        if phone.text == zPassword.text, (phone.text?.count ?? 0) > 0, (code.text?.count ?? 0) == 4 {
            API.forgetPassword(telephone: phoneStr, code: code.text ?? "", password: phone.text ?? "").request { (result) in
                switch result {
                case .success(_):
                    CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "密码修改成功", duration: 1)
                case .failure(let er):
                    print(er)
                }
            }
        }
    }

    @objc func getCodeAction(sender: UIButton) {
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
}
