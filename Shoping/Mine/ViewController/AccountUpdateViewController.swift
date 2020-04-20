//
//  AccountUpdateViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/12.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class AccountUpdateViewController: UIViewController {
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
        title = "验证身份"
    }
}
