//
//  LogisticsViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/5/22.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class LogisticsViewController: UIViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var vo: UIView!
    @IBOutlet weak var btn: UIButton!
    var data: Logis? = nil
    var order_id = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "查看物流"
        tableView.register(UINib(nibName: "LogisticsTableViewCell", bundle: nil), forCellReuseIdentifier: "LogisticsTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.tableviewBackgroundColor
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = .white
        vo.layer.cornerRadius = 10
        vo.layer.masksToBounds = true
        loadData()
    }

    @IBAction func copyAction(_ sender: Any) {
        let pastboard = UIPasteboard.general
        pastboard.string = self.data?.data.number
        CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "复制成功", duration: 1)
    }
    func loadData() {
        API.getLogis(order_id: order_id).request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.name.text = data.data.expName
                self.number.text = data.data.number
                self.tableView.reloadData()
            case .failure(let er):
                print(er)
            }
        }
    }
}

extension LogisticsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.data.list.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogisticsTableViewCell") as! LogisticsTableViewCell
        cell.selectionStyle = .none
        let item = data?.data.list[indexPath.row]
        cell.name.text = item?.status
        cell.date.text = item?.time
        if indexPath.row == 0 {
            cell.top.isHidden = true
            cell.dian.image = UIImage(named: "实时位置")
        } else {
            cell.top.isHidden = false
            cell.dian.image = UIImage(named: "已到达")
        }
        if indexPath.row == (self.data?.data.list.count ?? 0) - 1 {
            cell.bottom.isHidden = true
        } else {
            cell.bottom.isHidden = false
        }
        return cell
    }
}
