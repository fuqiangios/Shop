//
//  VipProductDetailViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/29.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VipProductDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var webViewHeight = 0.00
    var id: String = ""
    var data: VIPDataDetailDataClass? = nil
    var showpre = false
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的项目"
        tableView.register(UINib(nibName: "VipProductDetailHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "VipProductDetailHeaderTableViewCell")
        tableView.register(UINib(nibName: "VipProductDetailTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "VipProductDetailTitleTableViewCell")
        tableView.register(UINib(nibName: "VipProductDetailImageTableViewCell", bundle: nil), forCellReuseIdentifier: "VipProductDetailImageTableViewCell")
        tableView.register(UINib(nibName: "VipProductDetailInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "VipProductDetailInfoTableViewCell")
        tableView.register(UINib(nibName: "VipProductAmountTableViewCell", bundle: nil), forCellReuseIdentifier: "VipProductAmountTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
                tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none

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
//        tableView.tableFooterView = footer
        getDetailData()
    }

    func getDetailData() {
        API.getProductDetail(id: id).request { (result) in
            switch result {
            case .success(let data):
                self.data = data.data
                self.tableView.reloadData()
            case .failure(let er):
                print(er)
            }
        }
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
                self.getDetailData()
            case .failure(let er):
                print(er)
            }
        }
    }

    @objc func playVideo(btn: UIButton) {
        if data?.video == "" {return}
        if let url = URL(string: urlEncode(str: data?.video ?? "https://app.necesstore.com/upload/video/091138340.png")) {
             let player = AVPlayer(url: url)
             let playerViewController = AVPlayerViewController()
             playerViewController.player = player
             self.present(playerViewController, animated:true, completion: nil)
        }
    }

    @objc func joinAction () {
        if data?.showPerformance == "0" {
            loadData()

        } else {
            showpre = true
            self.tableView.reloadData()
        }
    }

    func urlEncode(str: String) -> String {
         return str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://app.necesstore.com/upload/video/091138340.png"
    }
}
extension VipProductDetailViewController: UITableViewDelegate,UITableViewDataSource, UIWebViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data == nil ? 0 : 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VipProductDetailHeaderTableViewCell") as! VipProductDetailHeaderTableViewCell
        cell.selectionStyle = .none
            cell.img.af_setImage(withURL: URL(string: data?.infoImage == "" ? data!.image : data!.infoImage)!)
            cell.name.text = data?.name
            cell.info.text = data?.intro
            cell.allPeopleNum.text = "总人数: \(data?.target ?? "0")"
            cell.jointPeopleNum.text = "已参与: \(data?.support ?? "0")"
            cell.allAmount.text = "总金额: \(data?.amount ?? "0")"
            cell.finshAmount.text = "已完成: \(data?.completedAmount ?? "0")"
            cell.startDate.text = "项目开始时间: \(data?.startTime ?? "")"
            cell.endDate.text = "项目截止时间: \(data?.endTime ?? "")"
        return cell
        } else if indexPath.row == 1 {
            if showpre {
                let cell = tableView.dequeueReusableCell(withIdentifier: "VipProductAmountTableViewCell") as! VipProductAmountTableViewCell
                cell.allAmount.text = data?.totalPerformance
                cell.jiAmount.text = data?.quarterlyPerformance
                cell.lastAmount.text = data?.monthPerformance
                cell.selectionStyle = .none
                return cell
            } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VipProductDetailTitleTableViewCell") as! VipProductDetailTitleTableViewCell
            cell.btn.addTarget(self, action: #selector(joinAction), for: .touchUpInside)
            if data?.showPerformance == "1" {
                cell.btn.setTitle("财务查询", for: .normal)
            } else {
                cell.btn.setTitle("参与项目", for: .normal)
            }
            cell.selectionStyle = .none
            return cell
            }
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VipProductDetailImageTableViewCell") as! VipProductDetailImageTableViewCell
            cell.selectionStyle = .none
            cell.img.af_setImage(withURL: URL(string: data!.image)!)
            cell.btn.addTarget(self, action: #selector(playVideo(btn:)), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VipProductDetailInfoTableViewCell") as! VipProductDetailInfoTableViewCell
            cell.selectionStyle = .none
            if webViewHeight < 10 {
                cell.web.loadHTMLString((data?.content)!, baseURL: URL(string: urlheadr)!)
                cell.web.delegate = self
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return CGFloat(webViewHeight + 100)
        }
        return UITableView.automaticDimension
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        webViewHeight = Double(webView.scrollView.contentSize.height)
        self.tableView.reloadData()
    }
}
