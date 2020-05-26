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
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImg: UIImageView!

    @IBOutlet weak var jName: UILabel!
    @IBOutlet weak var fName: UILabel!
    @IBOutlet weak var tableVIew: UITableView!
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
        tableVIew.register(UINib(nibName: "UserVipTableViewCell", bundle: nil), forCellReuseIdentifier: "UserVipTableViewCell")
        tableVIew.delegate = self
        tableVIew.dataSource = self
        tableVIew.estimatedRowHeight = 150
        tableVIew.rowHeight = UITableView.automaticDimension
        tableVIew.backgroundColor = UIColor.tableviewBackgroundColor
        tableVIew.separatorStyle = .none
        let hd = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 527))
        hd.addSubview(headerImg)
        hd.addSubview(headerView)
        hd.addSubview(fensi)
        hd.addSubview(fName)
        hd.addSubview(jName)
        hd.addSubview(xinzeng)
        tableVIew.tableHeaderView = hd
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

    @objc func toDetail(btn: UIButton) {
        let detail = UserVipDetailViewController()
        detail.token = data?.data.inviteList[btn.tag - 100].user_token ?? ""
        self.navigationController?.pushViewController(detail, animated: true)
    }

    func loadData() {
        API.fansInfo(name: nameInput.text ?? "", telephone: phoneInput.text ?? "").request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.fensi.text = data.data.inviteCount
                self.xinzeng.text = data.data.todayInviteCount
                self.tableVIew.reloadData()
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
extension UserVipViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.data.inviteList.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserVipTableViewCell") as! UserVipTableViewCell
        cell.selectionStyle = .none
        let item = data?.data.inviteList[indexPath.row]
        cell.name.text = item?.name
        cell.fensi.text = item?.inviteCount
        cell.date.text = item?.created
        cell.hongbao.text = item?.redPackage
        cell.jifen.text = item?.points
        cell.yue.text = item?.amount
        cell.btn.tag = indexPath.row + 100
        cell.btn.addTarget(self, action: #selector(self.toDetail(btn:)), for: .touchUpInside)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }

}
