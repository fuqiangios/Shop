//
//  RedPackRainHistoryViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/12/11.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import MJRefresh

class RedPackRainHistoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var data: PlanLuckList? = nil
    var page: Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "中奖记录"
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", style: .done, target: self, action: #selector(backAction))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "back"), style: .plain, target: self, action:  #selector(backAction))
        self.navigationController?.navigationBar.tintColor = .black
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "RedPackRainHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "RedPackRainHistoryTableViewCell")
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page = self.page + 1
            self.loadDataMore()
        })
        getData()
    }

    @objc func backAction() {
        self.dismiss(animated: false, completion: nil)
    }

    func getData() {
        API.getPlanLuckHistory(user_token: UserSetting.default.activeUserToken ?? "", page: "\(page)").request { (result) in
            switch result{
            case .success(let data):
                print(data)
                self.data = data
                self.tableView.reloadData()
            case .failure(let er):
                print(er)
            }
        }
    }

    func loadDataMore() {
        API.getPlanLuckHistory(user_token: UserSetting.default.activeUserToken ?? "", page: "\(page)").request { (result) in
            self.tableView.mj_footer?.endRefreshing()
            switch result{
            case .success(let data):
                print(data)
                var ar = self.data?.data.couponList ?? []
                ar = ar + data.data.couponList
                self.data = PlanLuckList(result: true, message: "", status: 200, data: PlanLuckListDataClass(couponList: ar, count: data.data.count))
                self.tableView.reloadData()
            case .failure(let er):
                print(er)
            }
        }
    }
}
extension RedPackRainHistoryViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.data.couponList.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RedPackRainHistoryTableViewCell") as! RedPackRainHistoryTableViewCell
        cell.selectionStyle = .none
        let item = data?.data.couponList[indexPath.row]
        cell.title.text = item?.remarks
        cell.name.text = "由\(item?.source ?? "")获得的抽奖机会"
        cell.date.text = item?.luckDate
        cell.num.text = item?.price
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
                let view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .groupTableViewBackground
        } else {
            view.backgroundColor = .groupTableViewBackground
        }
        return view
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}
