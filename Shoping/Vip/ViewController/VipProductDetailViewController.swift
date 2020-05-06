//
//  VipProductDetailViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/29.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class VipProductDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var webViewHeight = 0.00
    var id: String = ""
    var data: Project? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "VipProductDetailHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "VipProductDetailHeaderTableViewCell")
        tableView.register(UINib(nibName: "VipProductDetailTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "VipProductDetailTitleTableViewCell")
        tableView.register(UINib(nibName: "VipProductDetailImageTableViewCell", bundle: nil), forCellReuseIdentifier: "VipProductDetailImageTableViewCell")
        tableView.register(UINib(nibName: "VipProductDetailInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "VipProductDetailInfoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
                tableView.backgroundColor = UIColor.tableviewBackgroundColor
        tableView.separatorStyle = .none
        title = data?.name
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 40, width: 150, height: 50)
        btn.backgroundColor = tableView.tintColor
//        btn.setBackgroundImage(UIImage(named: "默认底色"), for: .normal)
        btn.layer.cornerRadius = 25
        btn.layer.masksToBounds = true
        btn.setTitle("立即参与", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        footer.addSubview(btn)
        btn.center = CGPoint(x: view.center.x, y: 50)
        btn.addTarget(self, action: #selector(loadData), for: .touchUpInside)
        tableView.tableFooterView = footer
    }

    @objc func loadData() {
        if UserSetting.default.activeUserToken == nil {
        let login = LoginViewController()
        self.navigationController?.pushViewController(login, animated: true)
            return
        }
        API.submitProduct(id: data?.id ?? "").request { (result) in
            switch result {
            case .success(let data):
                print(data)
                CLProgressHUD.showSuccess(in: self.view, delegate: self, title: data.message, duration: 2)
            case .failure(let er):
                print(er)
            }
        }
    }
}
extension VipProductDetailViewController: UITableViewDelegate,UITableViewDataSource, UIWebViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VipProductDetailHeaderTableViewCell") as! VipProductDetailHeaderTableViewCell
        cell.selectionStyle = .none
            cell.img.af_setImage(withURL: URL(string: data!.initiatorImage)!)
            cell.name.text = data?.initiatorName
            cell.date.text = data?.created
        return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VipProductDetailTitleTableViewCell") as! VipProductDetailTitleTableViewCell
            cell.selectionStyle = .none
            cell.name.text = data?.name
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VipProductDetailImageTableViewCell") as! VipProductDetailImageTableViewCell
            cell.selectionStyle = .none
            cell.img.af_setImage(withURL: URL(string: data!.image)!)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VipProductDetailInfoTableViewCell") as! VipProductDetailInfoTableViewCell
            cell.selectionStyle = .none
            cell.zhichi.text = "支持 \(data?.support ?? "0")"
            cell.yichou.text = "已筹 \(data?.raise ?? "0")"
            cell.dacheng.text = "达成 \(data?.reach ?? "0")"
            let lv: CGFloat = CGFloat(CGFloat(Int(data?.reach ?? "0") ?? 0)/100.0)
            cell.img.frame = CGRect(x: 1, y: 1, width: cell.bg.frame.width*lv, height: 6)
            if webViewHeight < 10 {
                cell.web.loadHTMLString((data?.content)!, baseURL: URL(string: urlheadr)!)
                cell.web.delegate = self
            }
            cell.webHei.constant = CGFloat(webViewHeight)
            return cell
        }
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webViewHeight = Double(webView.scrollView.contentSize.height)
        self.tableView.reloadData()
    }
}
