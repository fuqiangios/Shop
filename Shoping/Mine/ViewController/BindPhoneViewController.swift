//
//  BindPhoneViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/12/18.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class BindPhoneViewController: UIViewController {
    @IBOutlet weak var phone: UITextField!

    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var getCode: UIButton!
    @IBOutlet weak var code: UITextField!
    var token: TokenDataClass? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        phone.setValue(UIColor.black, forKeyPath: "placeholderLabel.textColor")
        code.setValue(UIColor.black, forKeyPath: "placeholderLabel.textColor")
        title = "绑定手机号"
        submit.layer.cornerRadius = 5
        submit.layer.masksToBounds = true
    }


    @IBAction func submitAction(_ sender: Any) {
        if phone.text?.isEmpty ?? true {return}
        if code.text?.isEmpty ?? true {return}
        API.bindPhoneCode(telephone: phone.text ?? "", code: code.text ?? "", user_token: token?.user_token ?? "").request { (result) in
            switch result {
            case .success(let data):
                if data.result == true {
                    JPUSHService.setAlias(self.token?.id, completion: { (i, o, u) in

                    }, seq: 1)
                    UserSetting.default.activeUserToken = self.token?.user_token
                    self.navigationController?.popToRootViewController(animated: true)
                }else{
                    CLProgressHUD.showError(in: self.view, delegate: self, title: data.message, duration: 1)
                }

            case .failure(let er):
                print(er)
            }
        }
    }
    
    @IBAction func getCodeAction(_ sender: Any) {
        if phone.text?.isEmpty ?? true {return}
        API.getCode(telephone: phone.text ?? "").request { (result) in
            switch result {
            case .success(let data):
                print(data)
                self.timeChange()
            case .failure(let er):
                print(er)
            }
        }
    }

    func timeChange() {

            var time = 120
            let codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
            codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))  //此处方法与Swift 3.0 不同
            codeTimer.setEventHandler {

                time = time - 1

                DispatchQueue.main.async {
                    self.getCode.isEnabled = false
                }

                if time < 0 {
                    codeTimer.cancel()
                    DispatchQueue.main.async {
                        self.getCode.isEnabled = true
                        self.getCode.setTitle("重新发送", for: .normal)
                    }
                    return
                }

                DispatchQueue.main.async {
                    self.getCode.setTitle("\(time)", for: .normal)
                }

            }

            codeTimer.activate()

    }
    
}
