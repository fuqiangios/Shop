//
//  PayPasswordPopupViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/5/22.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class PayPasswordPopupViewController: UIViewController {
    @IBOutlet weak var textView: UIView!

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var submit: UIButton!
    private let payPwdView = HBInputPayPassWordView()
    var code = ""
    var didCofirmPassword: ((String) -> Void)?
    var didToSet: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        bgView.layer.cornerRadius = 5
        bgView.layer.masksToBounds = true
        submit.layer.cornerRadius = 5
        submit.layer.masksToBounds = true
    }

    @IBAction func submitAction(_ sender: Any) {
        if code.count != 6 {
            return
        }
        self.dismiss(animated: false, completion: nil)
        didCofirmPassword!(code)
    }
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func toSet(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        didToSet?()
    }

    override func viewDidAppear(_ animated: Bool) {
        textView.addSubview(payPwdView)
        payPwdView.inputPwdIsClipherText = true
        payPwdView.frame = CGRect(x: 0, y: 0, width: textView.frame.width, height: textView.frame.height)
        payPwdView.inputPwdNumber = 6
        payPwdView.payPassWordHandler = { [weak self] passwd in
            print("passWord = \(passwd)")
            if passwd.count == 6 {
                self?.code = passwd
                self?.view.endEditing(true)
            }
        }
    }

}
