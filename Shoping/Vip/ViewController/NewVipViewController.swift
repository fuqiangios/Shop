//
//  NewVipViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/29.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class NewVipViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var data: VIPData? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        title = "VIP"
        let itme = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = itme
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.isTranslucent = false
        tableView.register(UINib(nibName: "VipLeavelTableViewCell", bundle: nil), forCellReuseIdentifier: "VipLeavelTableViewCell")
        tableView.register(UINib(nibName: "CrowdfundingTableViewCell", bundle: nil), forCellReuseIdentifier: "CrowdfundingTableViewCell")
        tableView.register(UINib(nibName: "VipProductTableViewCell", bundle: nil), forCellReuseIdentifier: "VipProductTableViewCell")
        tableView.register(UINib(nibName: "VipVideoTableViewCell", bundle: nil), forCellReuseIdentifier: "VipVideoTableViewCell")


        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
                tableView.backgroundColor = UIColor.tableviewBackgroundColor
        tableView.separatorStyle = .none
        let vi = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        let headerImg = UIImageView(frame: CGRect(x: 50, y: 0, width: self.view.frame.width-100, height: 100))
        headerImg.image = UIImage(named: "会员权益与奖励")
        headerImg.contentMode = .scaleAspectFit
        vi.addSubview(headerImg)
        tableView.tableHeaderView = vi
        loadData()
    }

    func loadData() {
        API.getVipData().request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.tableView.reloadData()
            case .failure(let er):
                print(er)
            }
        }
    }

}
extension NewVipViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return data?.data.member.count ?? 0
        } else if section == 1 {
            return data?.data.shareholder.count ?? 0
        } else if section == 2 {
            return data?.data.crowdfunding.count ?? 0
        } else if section == 3 {
            return 1
        }
        else {
            return data?.data.project.count ?? 0
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return data == nil ? 0 : 5
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

            let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
            header.backgroundColor = .clear
            let ti = UIImageView(frame: CGRect(x: 50, y: 0, width: self.view.frame.width - 100, height: 80))
            if section == 2 {
                ti.image = UIImage(named: "__国泰与秘鲁 _")
            } else if section == 4 {
                ti.image = UIImage(named: "__项目参与 _")
            } else if section == 1 {
                ti.image = UIImage(named: "__星级股东 _")
            } else if section == 3 {
                ti.image = UIImage(named: "__视频专栏 _备份")
            }
            else {
                ti.image = UIImage(named: "__会员卡 _")
            }
            ti.contentMode = .scaleAspectFit
            header.addSubview(ti)
            return header

    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 1 {
            return 80
        }
        return 80
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VipLeavelTableViewCell") as! VipLeavelTableViewCell
            cell.selectionStyle = .none
            cell.img.image = UIImage(named: "会员卡")
            let item = data?.data.member[indexPath.row]
            cell.name.text = item?.name
            cell.info.text = item?.memo
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VipLeavelTableViewCell") as! VipLeavelTableViewCell
            cell.selectionStyle = .none
            cell.name.textColor = .black
            let item = data?.data.shareholder[indexPath.row]
            cell.name.text = item?.name
            cell.info.text = item?.memo
            if indexPath.row == 0 {
                cell.img.image = UIImage(named: "星级")

            } else if indexPath.row == 1 {
                cell.img.image = UIImage(named: "星级2")

            } else if indexPath.row == 2 {
                cell.img.image = UIImage(named: "星级3")
            } else {
                 cell.img.image = UIImage(named: "星级3")
            }
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CrowdfundingTableViewCell") as! CrowdfundingTableViewCell
            cell.selectionStyle = .none
            let item = data?.data.crowdfunding[indexPath.row]
            cell.name.text = item?.name
            cell.title.text = item?.title
            cell.info.text = item?.content
            cell.jindu.text = "\(item?.value ?? "0")%"
            let lv: CGFloat = CGFloat(CGFloat(Int(item?.value ?? "0") ?? 0)/100.00)
            cell.img.frame = CGRect(x: 0, y: 0, width: cell.bg.frame.width*lv, height: 8)
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VipVideoTableViewCell") as! VipVideoTableViewCell
            cell.selectionStyle = .none
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VipProductTableViewCell") as! VipProductTableViewCell
            cell.selectionStyle = .none
            let item = data?.data.project[indexPath.row]
            cell.img.af_setImage(withURL: URL(string: item!.image)!)
            cell.name.text = item?.name
            cell.info.text = item?.intro
            cell.zhichi.text = "支持 \(item?.support ?? "0")"
            cell.yichou.text = "已筹 \(item?.raise ?? "0")"
            cell.dacheng.text = "达成 \(item?.reach ?? "0")"
            let lv: CGFloat = CGFloat(CGFloat(Int(item?.reach ?? "0") ?? 0)/100.0)
            cell.line.frame = CGRect(x: 1, y: 1, width: cell.bg.frame.width*lv, height: 6)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 4 {
            let detail = VipProductDetailViewController()
            detail.hidesBottomBarWhenPushed = true
            detail.data = data?.data.project[indexPath.row]
            self.navigationController?.pushViewController(detail, animated: true)
        } else if indexPath.section == 2 {
            let web = WebViewController()
            web.uri = "https://app.necesstore.com/html/peru/index.html"
            web.title = "国泰与秘鲁"
            web.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(web, animated: true)
        } else if indexPath.section == 3 {
            let web = WebViewController()
            web.uri = "https://app.necesstore.com/html/video.html"
            web.title = "视频专栏"
            web.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(web, animated: true)
        }
    }
}
