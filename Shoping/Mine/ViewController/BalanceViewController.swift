//
//  BalanceViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/3/15.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class BalanceViewController: UIViewController {

    @IBOutlet weak var zhanngdan: UIButton!
    @IBOutlet weak var chonngzhi: UIButton!

    @IBOutlet weak var sendAmount: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tixian: UIButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var info: UITextView!
    var data: Amount? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        API.getUStatus().request { (result) in
            switch result {
            case .success(let data):
                if data.data.code == "1" {
                    self.tixian.isHidden = false
                } else {
                    self.tixian.isHidden = true
                }
            case .failure(let er):
                self.tixian.isHidden = true
                print(er)
            }
        }
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        title = "余额"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "查看明细", style: .done, target: self, action: #selector(toDetail))
        tixian.layer.borderColor = UIColor.white.cgColor
         tixian.layer.borderWidth = 1
         tixian.layer.cornerRadius = 20
        sendAmount.layer.borderColor = UIColor.white.cgColor
         sendAmount.layer.borderWidth = 1
         sendAmount.layer.cornerRadius = 20
        chonngzhi.layer.borderColor = UIColor.white.cgColor
         chonngzhi.layer.borderWidth = 1
         chonngzhi.layer.cornerRadius = 20
        tableView.register(UINib(nibName: "IntegraDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "IntegraDetailTableViewCell")


          tableView.estimatedRowHeight = 150
          tableView.rowHeight = UITableView.automaticDimension
          tableView.delegate = self
          tableView.dataSource = self
          tableView.separatorStyle = .none
          tableView.backgroundColor = UIColor.tableviewBackgroundColor
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        loadData()
    }

    @objc func toDetail() {
        let detail = BalanceListViewController()
        self.navigationController?.pushViewController(detail, animated: true)
    }

    func loadData() {
        API.amountInfo().request { (result) in
            switch result{
            case .success(let data):
                self.price.text = data.data.amount
                self.data = data
                self.tableView.reloadData()
            case .failure:
                print("error")
            }
        }
    }

    @IBAction func sendAmointAction(_ sender: Any) {
        let sendAmount = SendAmountViewController()
        sendAmount.amountI = data?.data.amount ?? "0.00"
        self.navigationController?.pushViewController(sendAmount, animated: true)
    }
    @IBAction func chongzhiAction(_ sender: Any) {
        let chong = BalanceChongViewController()
        self.navigationController?.pushViewController(chong, animated: true)
    }
    @IBAction func tixianAction(_ sender: Any) {
        let tixian = BalancePayViewController()
        self.navigationController?.pushViewController(tixian, animated: true)
    }
//    func loadList() {
//        API.amountList(start_date: "", end_date: "", page: "1").request { (result) in
//            switch result {
//            case .success(let data):
//                self.data = data
//                self.tableView.reloadData()
//            case .failure(let er):
//                print(er)
//            }
//        }
//    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension BalanceViewController: UITableViewDataSource, UITableViewDelegate {
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
