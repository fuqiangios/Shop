//
//  MessageViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/26.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import MJRefresh

class MessageViewController: UIViewController {
    var data: Message? = nil
    var type = "0"
    var page = 1
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var line: UILabel!
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewDidLoad()
        title = "消息"
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "清空", style: .done, target: self, action: #selector(clearMessage))
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page = self.page + 1
            self.loadDataMore()
        })
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            self.loadData()
        })
        loadData()
    }

    @objc func clearMessage() {
        API.clearMessage().request { (_) in
            self.loadData()
        }
    }

    @IBAction func typeActionn(_ sender: UIButton) {
        type = "\(sender.tag - 1)"
        line.center = CGPoint(x: sender.center.x, y: sender.center.y + 18)
        loadData()
    }

    func loadData() {
        page = 1
        API.messageList(type: type, page: "1").request { (result) in
            self.tableView.mj_header?.endRefreshing()
            switch result {
            case .success(let data):
                self.data = data
                self.tableView.reloadData()
            case .failure(_):
                self.data = nil
                self.tableView.reloadData()
            }
        }
    }

    func loadDataMore() {
        API.messageList(type: type, page: "\(page)").request { (result) in
            self.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let data):
                var ar = self.data?.data ?? []
                ar = ar + data.data
                self.data = Message(result: true, message: "", status: 200, data: ar)
                self.tableView.reloadData()
            case .failure(_):
                self.data = nil
                self.tableView.reloadData()
            }
        }
    }
}
extension MessageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.data.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as! MessageTableViewCell
        let item = data?.data[indexPath.row]
        if item?.type == "1" {
            cell.img.image = UIImage(named: "系统消息")
        } else if item?.type == "2" {
            cell.img.image = UIImage(named: "商城消息")
        } else if item?.type == "3" {
            cell.img.image = UIImage(named: "资金消息")
        }
        cell.type.text = item?.typeName
        cell.date.text = item?.created
        cell.info.text = item?.content
        cell.selectionStyle = .none
        return cell
    }
}
