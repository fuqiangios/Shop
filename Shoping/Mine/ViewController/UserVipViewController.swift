//
//  UserVipViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/17.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class UserVipViewController: UIViewController {
    @IBOutlet weak var fensi: UILabel!
    @IBOutlet weak var UserView: UIView!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var orderBtn: UIButton!
    @IBOutlet weak var yue: UILabel!
    @IBOutlet weak var jifen: UILabel!
    @IBOutlet weak var hongbao: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var userFensi: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var check: UIButton!
    @IBOutlet weak var phoneInput: UITextField!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var xinzeng: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "会员信息"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        scrollView.contentSize = CGSize(width: 0, height: 720)
        nameView.layer.cornerRadius = 25
        nameView.layer.masksToBounds = true
        phoneView.layer.cornerRadius = 25
        phoneView.layer.masksToBounds = true
        check.layer.cornerRadius = 25
        check.layer.masksToBounds = true
//        UserView.isHidden = true
        UserView.layer.cornerRadius = 5
        UserView.layer.borderWidth = 1
        UserView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        UserView.layer.masksToBounds = true
    }

    @IBAction func checkAction(_ sender: Any) {
    }
    @IBAction func orderAction(_ sender: Any) {
        let detail = UserVipDetailViewController()
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
