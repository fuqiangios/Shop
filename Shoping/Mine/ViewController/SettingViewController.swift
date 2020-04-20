//
//  SettingViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/18.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        tableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
        tableView.register(UINib(nibName: "LogOutTableViewCell", bundle: nil), forCellReuseIdentifier: "LogOutTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
//        tableView.backgroundColor = UIColor.tableviewBackgroundColor
        tableView.separatorStyle = .none
    }
}
extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogOutTableViewCell") as! LogOutTableViewCell
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell") as! SettingTableViewCell
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.title.text = "消息推送"
            cell.info.text = "去设置"
        } else if indexPath.row == 1 {
            cell.title.text = "清楚缓存"
            cell.info.text = "290M"
        } else {
            cell.title.text = "关于我家用品"
            cell.info.text = ""
        }
        if indexPath.row == 1 {
            cell.imgWidth.constant = 0
            cell.img.isHidden = true
            cell.infoRight.constant = 0
        } else {
            cell.imgWidth.constant = 16
            cell.img.isHidden = false
            cell.infoRight.constant = 4
        }
        return cell
    }


}
