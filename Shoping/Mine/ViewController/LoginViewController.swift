//
//  LoginViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/17.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var backGroupView: UIView!

    @IBOutlet weak var tipc: UILabel!
    @IBOutlet weak var wechatLoginLabel: UILabel!
    @IBOutlet weak var wechatLoginBtn: UIButton!
    @IBOutlet weak var getCodeBtn: UIButton!
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var phoneNumber: UITextField!

    @IBOutlet weak var password: UITextField!
    var type = "2"
    override func viewDidLoad() {
        super.viewDidLoad()
        getCodeBtn.layer.cornerRadius = 5
        getCodeBtn.layer.masksToBounds = true
        phoneNumber.setValue(UIColor.black, forKeyPath: "placeholderLabel.textColor")
        password.setValue(UIColor.black, forKeyPath: "placeholderLabel.textColor")
        API.getUStatus().request { (result) in
            switch result {
            case .success(let data):
                if data.data.code != "0" {
                    self.wechatLoginLabel.isHidden = false
                    self.wechatLoginBtn.isHidden = false
                }
            case .failure(let er):
                print(er)
            }
        }

        loginBtn.layer.cornerRadius = 54/2
        loginBtn.layer.masksToBounds = true
        password.isSecureTextEntry = true
        if type == "2" {
        setUpUI()
        }else{
            phoneNumber.placeholder = "请输入账号"
            loginBtn.setTitle("登录", for: .normal)
            tipc.isHidden = true
        }
    }

    func setUpUI() {
        getCodeBtn.isHidden = false
        password.placeholder = "请输入验证码"
        password.isSecureTextEntry = false
        typeBtn.setTitle("账号密码登录", for: .normal)
        loginBtn.setTitle("注册/登录", for: .normal)
        tipc.isHidden = false
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func typeAction(_ sender: Any) {
        if type == "1" {
            self.navigationController?.popViewController(animated: true)
            return
        }
        let login = LoginViewController()
        login.type = "1"
        self.navigationController?.pushViewController(login, animated: true)
    }

    @IBAction func wechatLoginAction(_ sender: Any) {
        UMSocialManager.default()?.getUserInfo(with: .wechatSession, currentViewController: nil, completion: { (result, er) in
            print(result)
            print(er)

            if er == nil {
                 let e = result as! UMSocialUserInfoResponse
                API.login(telephone: "", login_type: "3", email: nil, password: nil, wx_openid: e.openid, name: nil, image: nil,wx_unionid: e.unionId,wx_image: e.iconurl,wx_name: e.name,wx_sex: e.gender == "男" ? "2":"1").request { (result) in
                    switch result {
                    case .success(let token):
                        if token.data.user_token?.isEmpty ?? true {
                            CLProgressHUD.showError(in: self.view, delegate: self, title: token.message, duration: 1)
                        } else {
                            print("wk,\(token.data.telephone)")
                            if token.data.telephone == nil || (token.data.telephone?.isEmpty ?? true){
                                let bind = BindPhoneViewController()
                                bind.token = token.data
                                self.navigationController?.pushViewController(bind, animated: true)
                            }else{
                            JPUSHService.setAlias(token.data.id, completion: { (i, o, u) in

                            }, seq: 1)
                        UserSetting.default.activeUserToken = token.data.user_token
                        self.navigationController?.popToRootViewController(animated: true)
                            }
                        }
                    case .failure(let error):
                        CLProgressHUD.showError(in: self.view, delegate: self, title: "登录失败,请重试", duration: 1)
                        print(error)
                        print(error.self)
                        print(error.localizedDescription)
                    }
                }
            }
        })
    }

    @IBAction func getCodeAction(_ sender: UIButton) {
        if phoneNumber.text?.count == 11 {
            API.getCode(telephone: phoneNumber.text ?? "").request { (result) in
                switch result {
                case .success:
                    print("success")
                    self.timeChange(btn: sender)
                case .failure(let error):
                    CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "登录失败，请重试", duration: 1)
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
                    btn.setTitle("\(time)", for: .normal)
                }

            }

            codeTimer.activate()

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
    @IBAction func signUpAction(_ sender: Any) {
        let register = RgisterViewController()
        self.navigationController?.pushViewController(register, animated: true)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        API.login(telephone: phoneNumber.text, login_type: type, email: nil, password: password.text, wx_openid: password.text ?? "", name: nil, image: nil,wx_unionid: nil,wx_image: nil,wx_name: nil,wx_sex: nil).request { (result) in
            switch result {
            case .success(let token):
                if token.data.user_token?.isEmpty ?? true {
                    CLProgressHUD.showError(in: self.view, delegate: self, title: token.message, duration: 1)
                } else {
                    JPUSHService.setAlias(token.data.id, completion: { (i, o, u) in

                    }, seq: 1)
                UserSetting.default.activeUserToken = token.data.user_token
                self.navigationController?.popToRootViewController(animated: true)
                }
            case .failure(let error):
                CLProgressHUD.showError(in: self.view, delegate: self, title: "登录失败,请重试", duration: 1)
                print(error)
                print(error.self)
                print(error.localizedDescription)
            }
        }
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
