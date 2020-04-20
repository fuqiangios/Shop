//
//  RedHistoryViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/17.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class RedHistoryViewController: UIViewController {
    @IBOutlet weak var line: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var type = "1"
    var data: Redpackge? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "红包明细"
        tableView.register(UINib(nibName: "RedPackgeTableViewCell", bundle: nil), forCellReuseIdentifier: "RedPackgeTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        loadData()
    }

    func loadData() {
        API.redpackgeList(type: type).request { (result) in
            switch result{
            case .success(let data):
                self.data = data
                self.tableView.reloadData()
            case .failure:
                print("error")
            }
        }
    }
    @IBAction func shouru(_ sender: UIButton) {
        type = "1"
        line.center = CGPoint(x: sender.center.x, y: sender.center.y + 15)
        loadData()
    }
    @IBAction func zhichu(_ sender: UIButton) {
        type = "2"
        line.center = CGPoint(x: sender.center.x, y: sender.center.y + 15)
        loadData()
    }
    @IBAction func guoqi(_ sender: UIButton) {
        type = "3"
        line.center = CGPoint(x: sender.center.x, y: sender.center.y + 15)
        loadData()
    }
    
}
extension RedHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.data.redPackageList.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RedPackgeTableViewCell") as! RedPackgeTableViewCell
        let item = data?.data.redPackageList[indexPath.row]
        cell.price.text = "\(item?.value ?? "")"
        cell.info.text = item?.method ?? ""
        cell.shiyong.text = "\(item?.created ?? "")"
        cell.youxian.text = "\(item?.endDate ?? "")"
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89

    }
}
