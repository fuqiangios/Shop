//
//  RgisterViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/17.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class RgisterViewController: UIViewController {

    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var code: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var surePassword: UITextField!
    @IBOutlet weak var codeName: UILabel!

    @IBOutlet weak var yaoqing: UITextField!
    @IBOutlet weak var yaoqingName: UILabel!

    @IBOutlet weak var getCodeBtn: UIButton!
    @IBOutlet weak var surepassrordName: UILabel!
    @IBOutlet weak var passwordName: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var line: UILabel!
    @IBOutlet weak var sureBtn: UIButton!
    var type: String = "1"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        setShadow(view: backGroundView, sColor: UIColor.init(white: 0.8, alpha: 1), offset: CGSize(width: 1, height: 1), opacity: 1, radius: 5)
        backGroundView.layer.cornerRadius = 10
        backGroundView.layer.masksToBounds = true
        sureBtn.setImage(UIImage(named: "未选择矩形"), for: .normal)
        sureBtn.setImage(UIImage(named: "选中_矩形"), for: .selected)
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    func setShadow(view:UIView,sColor:UIColor,offset:CGSize,
                   opacity:Float,radius:CGFloat) {
        //设置阴影颜色
        view.layer.shadowColor = sColor.cgColor
        //设置透明度
        view.layer.shadowOpacity = opacity
        //设置阴影半径
        view.layer.shadowRadius = radius
        //设置阴影偏移量
        view.layer.shadowOffset = offset
    }

    @IBAction func getCodeAction(_ sender: UIButton) {
        if phoneNumber.text?.count == 11 {
            API.getCode(telephone: phoneNumber.text ?? "").request { (result) in
                switch result {
                case .success:
                    print("success")
                    self.timeChange(btn: sender)
                case .failure(let error):
                    CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "获取验证码失败，请重试", duration: 1)
                    print(error)
                    print(error.self)
                    print(error.localizedDescription)
                }
            }
        } else {
            CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "请输入手机号", duration: 1)
        }
    }


    @IBAction func sureAction(_ sender: UIButton) {
        sureBtn.isSelected = !sureBtn.isSelected
    }

    @IBAction func xieyiAction(_ sender: Any) {
        let web = WebViewController()
        web.uri = "https://app.necesstore.com/html/legal.html"
        web.title = "用户协议"
        self.navigationController?.pushViewController(web, animated: true)
    }


    @IBAction func typeAction(_ sender: UIButton) {
        line.center = CGPoint(x: sender.center.x, y: sender.center.y + 18)
        type = "\(sender.tag)"
        password.isSecureTextEntry = false
        surePassword.isSecureTextEntry = false
        code.isSecureTextEntry = false
        password.isSecureTextEntry = false
        if type == "1" {

            phone.text = "手机号"
            phoneNumber.placeholder = "请输入手机号码"
            codeName.text = "验证码"
            code.placeholder = "请输入验证码"
            getCodeBtn.isHidden = false
            passwordName.text = "密码"
            password.placeholder = "请输入密码"
            password.isSecureTextEntry = true
            surePassword.isSecureTextEntry = true
            surepassrordName.text = "确认密码"
            yaoqing.isHidden = false
            yaoqingName.isHidden = false
            surePassword.placeholder = "请再次输入密码"
            phoneNumber.text = ""
            code.text = ""
            password.text = ""
            surePassword.text = ""
            yaoqing.text = ""
            yaoqing.placeholder = "输入邀请码"
            yaoqingName.text = "邀请码"
        } else {
            phone.text = "邮箱"
            phoneNumber.placeholder = "请输入邮箱"
            phoneNumber.text = ""
            codeName.text = "密码"
            code.placeholder = "请输入密码"
            code.isSecureTextEntry = true
            password.isSecureTextEntry = true
            code.text = ""
            password.text = ""
            surePassword.text = ""
            getCodeBtn.isHidden = true
            passwordName.text = "确认密码"
            password.placeholder = "请再次输入密码"
            surepassrordName.text = "邀请码"
            yaoqing.isHidden = true
            yaoqingName.isHidden = true
            surePassword.placeholder = "输入邀请码"
            yaoqing.text = ""
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
                    btn.setTitle("\(time)", for: .normal)
                }

            }

            codeTimer.activate()

    }

    @IBAction func registerAction(_ sender: Any) {
        if type == "1" {
            if phoneNumber.text?.count == 11, sureBtn.isSelected, !(code.text?.isEmpty ?? true), password.text == surePassword.text {
                API.register(type: "1", password: password.text ?? "", telephone: phoneNumber.text, code: code.text, email: nil, yaoqing: yaoqing.text ?? "").request { (result) in
                    switch result {
                    case .success(let data):
                        JPUSHService.setAlias(data.data.id, completion: { (i, o, u) in

                        }, seq: 1)
                        UserSetting.default.activeUserToken = data.data.user_token
                        self.navigationController?.popToRootViewController(animated: true)
                    case .failure(let error):
                        CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "注册失败，请重试", duration: 1)
                        print(error)
                        print(error.self)
                        print(error.localizedDescription)
                    }
                }
            } else {
                CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "请输入注册信息", duration: 1)
            }
        } else {
            if !(phoneNumber.text?.isEmpty ?? true), sureBtn.isSelected, !(code.text?.isEmpty ?? true),
                password.text == code.text {
                API.register(type: "2", password: code.text ?? "", telephone: "",
                             code: "", email: phoneNumber.text ?? "", yaoqing: surePassword.text ?? "").request { (result) in
                    switch result {
                    case .success(let data):
                        JPUSHService.setAlias(data.data.id, completion: { (i, o, u) in

                                         }, seq: 1)
                        UserSetting.default.activeUserToken = data.data.user_token
                        self.navigationController?.popToRootViewController(animated: true)
                    case .failure(let error):
                        CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "注册失败，请重试", duration: 1)
                        print(error)
                        print(error.self)
                        print(error.localizedDescription)
                    }
                }
            } else {
                CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "请输入注册信息", duration: 1)
            }
        }
    }
}
