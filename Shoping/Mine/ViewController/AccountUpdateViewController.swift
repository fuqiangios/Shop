//
//  AccountUpdateViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/12.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class AccountUpdateViewController: UIViewController {
    var uploadType = ""
    var uploadProgress = 1
    var oldPhone  = ""

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var left: UIButton!
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var CodeInput: UITextField!
    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var getCode: UIButton!
    @IBOutlet weak var phoneInput: UITextField!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var right: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(submit), for: .touchUpInside)

        setUpUI()
    }

    func setUpUI() {
        if uploadProgress == 1 {
            title = "验证身份"
            img.image = UIImage(named: "绑定手机1")
            phone.text = ""
            phoneInput.isEnabled = false
            phoneInput.text = oldPhone
            getCode.addTarget(self, action: #selector(getCodeAction), for: .touchUpInside)
        } else {
            title = "绑定新手机"
            phone.text = "手机号"
            phoneInput.text = ""
            phoneInput.isEnabled = true
            phoneInput.placeholder = "请输入手机号码"
            CodeInput.text = ""
            img.image = UIImage(named: "绑定手机2")
            getCode.addTarget(self, action: #selector(getCodeAction), for: .touchUpInside)
        }
    }

    @objc func submit() {
        if uploadProgress == 1 {
            if CodeInput.text?.isEmpty ?? true {return}
            API.verfiPhoneCode(telephone: oldPhone, code: CodeInput.text ?? "").request { (result) in
                switch result {
                case .success(_):
                    let i = AccountUpdateViewController()
                    i.uploadProgress = 2
                    self.navigationController?.pushViewController(i, animated: true)
                case .failure(let er):
                    print(er)
                }
            }
        } else {
            if phoneInput.text?.isEmpty ?? true {return}
            if CodeInput.text?.isEmpty ?? true {return}
            API.bindPhoneCode(telephone: phoneInput.text ?? "", code: CodeInput.text ?? "").request { (result) in
                switch result {
                case .success(_):
                    let nav = self.navigationController?.viewControllers[1]
                    self.navigationController?.popToViewController(nav!, animated: true)
                case .failure(let er):
                    print(er)
                }
            }
        }
    }

    @objc func getCodeAction() {
        if phoneInput.text?.isEmpty ?? true {return}
        API.getCode(telephone: phoneInput.text ?? "").request { (result) in
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
