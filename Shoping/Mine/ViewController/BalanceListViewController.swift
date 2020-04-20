//
//  BalanceListViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/17.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class BalanceListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var line: UILabel!
    var data: AmountList? = nil
    var type = "1"
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "余额明细"
        tableView.register(UINib(nibName: "IntegraDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "IntegraDetailTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        loadData()
    }
    @IBAction func tixian(_ sender: UIButton) {
        type = "1"
        line.center = CGPoint(x: sender.center.x, y: sender.center.y + 15)
        loadData()
    }
    
    @IBAction func chongzhi(_ sender: UIButton) {
        type = "2"
        line.center = CGPoint(x: sender.center.x, y: sender.center.y + 15)
        loadData()
    }

    func loadData() {
        API.amountList(start_date: "", end_date: "", page: "1").request { (result) in
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
extension BalanceListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.data.amountList.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IntegraDetailTableViewCell") as! IntegraDetailTableViewCell
        cell.selectionStyle = .none
        let item = data?.data.amountList[indexPath.row]
        cell.name.text = item?.method ?? ""
        cell.date.text = item?.created ?? ""
        cell.point.text = item?.value ?? ""
        if item?.incomeFlag ?? false {
            cell.point.textColor = .red
        } else {
            cell.point.textColor = cell.name.textColor
        }
        return cell
    }
}
