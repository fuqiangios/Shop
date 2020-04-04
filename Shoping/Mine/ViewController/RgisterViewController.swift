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
    var type: String = "1"
    override func viewDidLoad() {
        super.viewDidLoad()

        setShadow(view: backGroundView, sColor: UIColor.init(white: 0.8, alpha: 1), offset: CGSize(width: 1, height: 1), opacity: 1, radius: 5)
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

    @IBAction func getCodeAction(_ sender: Any) {
        if phoneNumber.text?.count == 11 {
            API.getCode(telephone: phoneNumber.text ?? "").request { (result) in
                switch result {
                case .success:
                    print("success")
                case .failure(let error):
                    print(error)
                    print(error.self)
                    print(error.localizedDescription)
                }
            }
        }
    }
    @IBAction func registerAction(_ sender: Any) {
        if type == "1" {
            if phoneNumber.text?.count == 11, !(code.text?.isEmpty ?? true), password.text == surePassword.text {
                API.register(type: "1", password: password.text ?? "", telephone: phoneNumber.text, code: code.text, email: nil).request { (result) in
                    switch result {
                    case .success:
                        self.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        print(error)
                        print(error.self)
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
