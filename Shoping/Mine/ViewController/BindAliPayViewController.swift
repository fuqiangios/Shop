//
//  BindAliPayViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/28.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class BindAliPayViewController: UIViewController {
    @IBOutlet weak var accountInpu: UITextField!

    @IBOutlet weak var nameInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        title = "绑定支付宝"
    }

    @IBAction func bindAction(_ sender: Any) {
        API.bindAlipay(alipay_name: nameInput.text ?? "", alipay_identity: accountInpu.text ?? "").request { (result) in
            self.navigationController?.popViewController(animated: true)
        }
    }

}
