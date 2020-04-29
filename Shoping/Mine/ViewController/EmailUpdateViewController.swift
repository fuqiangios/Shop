//
//  EmailUpdateViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/27.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class EmailUpdateViewController: UIViewController {

    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var input: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(submit), for: .touchUpInside)
        title = "修改邮箱"
    }

    @objc func submit() {
        if let text = input.text {
            API.bindEmail(email: text).request { (result) in
                switch result {
                case .success(_):
                    self.navigationController?.popViewController(animated: true)
                case .failure(let er):
                    print(er)
                }
            }
        }
    }
}
