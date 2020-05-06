//
//  UserVipViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/17.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class UserVipViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var fensi: UILabel!
    @IBOutlet weak var UserView: UIView!
    var data: FansData? = nil

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
        nameInput.delegate = self
        nameInput.tag = 100
        phoneInput.delegate = self
        phoneInput.tag = 200
        loadData()
    }

    @IBAction func checkAction(_ sender: Any) {
        if nameInput.text?.isEmpty ??

            true , phoneInput.text?.isEmpty ?? true {
            CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "请输入查询信息", duration: 1)
        }
        loadData()
    }
    @IBAction func orderAction(_ sender: Any) {
        let detail = UserVipDetailViewController()
        detail.token = data?.data.inviteList.first?.user_token ?? ""
        self.navigationController?.pushViewController(detail, animated: true)
    }

    func loadData() {
        API.fansInfo(name: nameInput.text ?? "", telephone: phoneInput.text ?? "").request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.fensi.text = data.data.inviteCount
                self.xinzeng.text = data.data.todayInviteCount
                if data.data.inviteList.count == 0 {
                    self.UserView.isHidden = true
                } else {
                    self.UserView.isHidden = false

                    let item = data.data.inviteList.first
                    self.name.text = item?.name
                    self.date.text = item?.created ?? ""
                    self.userFensi.text = item?.inviteCount ?? ""
                    self.hongbao.text = item?.redPackage ?? ""
                    self.jifen.text = item?.points ?? ""
                    self.yue.text = item?.amount ?? ""
                }
            case .failure(let er):
                print(er)
            }
        }
    }
}
