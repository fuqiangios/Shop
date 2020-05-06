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

    @IBOutlet weak var getCodeBtn: UIButton!
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var phoneNumber: UITextField!

    @IBOutlet weak var password: UITextField!
    var type = "1"
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius = 54/2
        loginBtn.layer.masksToBounds = true
        if type == "2" {
        setUpUI()
        }
    }

    func setUpUI() {
        getCodeBtn.isHidden = false
        password.placeholder = "请输入验证码"
        typeBtn.setTitle("密码登录", for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func typeAction(_ sender: Any) {
        if type == "2" {
            self.navigationController?.popViewController(animated: true)
            return
        }
        let login = LoginViewController()
        login.type = "2"
        self.navigationController?.pushViewController(login, animated: true)
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
        API.login(telephone: phoneNumber.text, login_type: type, email: nil, password: password.text, wx_openid: password.text ?? "", name: nil, image: nil).request { (result) in
            switch result {
            case .success(let token):
                UserSetting.default.activeUserToken = token.data.user_token
                self.navigationController?.popToRootViewController(animated: true)
            case .failure(let error):
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
