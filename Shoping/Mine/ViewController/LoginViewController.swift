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

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var phoneNumber: UITextField!

    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
//        setShadow(view: backGroupView, sColor: UIColor.init(white: 0.8, alpha: 1), offset: CGSize(width: 1, height: 1), opacity: 1, radius: 5)
        loginBtn.layer.cornerRadius = 54/2
        loginBtn.layer.masksToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        API.login(telephone: phoneNumber.text, login_type: "1", email: nil, password: password.text, wx_openid: nil, name: nil, image: nil).request { (result) in
            switch result {
            case .success(let token):
                UserSetting.default.activeUserToken = token.data.user_token
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print(error)
                print(error.self)
                print(error.localizedDescription)
            }
        }
    }
}
