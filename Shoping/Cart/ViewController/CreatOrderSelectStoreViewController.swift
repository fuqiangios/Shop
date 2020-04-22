////
////  CreatOrderSelectStoreViewController.swift
////  Shoping
////
////  Created by qiang.c.fu on 2020/3/5.
////  Copyright © 2020 付强. All rights reserved.
////
//
//import UIKit
//
//class CreatOrderSelectStoreViewController: UIViewController {
//    @IBOutlet weak var tableView: UITableView!
//    var settlement: OrderSettlement? = nil
//    var selectIndex: Int = 0
//    var didSelectStore: ((Store?)->Void)?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "门店自提"
//        setUp()
//    }
//
//    func setUp() {
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.separatorStyle = .none
//        tableView.estimatedRowHeight = 150
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.register(UINib(nibName: "CreaOrderStoreTableViewCell", bundle: nil), forCellReuseIdentifier: "CreaOrderStoreTableViewCell")
//        tableView.register(UINib(nibName: "CreatOrderSubmitTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatOrderSubmitTableViewCell")
//    }
//
//}
//extension CreatOrderSelectStoreViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (settlement?.data.stores.count ?? -1) + 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == settlement?.data.stores.count {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderSubmitTableViewCell") as! CreatOrderSubmitTableViewCell
//            cell.selectionStyle = .none
//            return cell
//        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CreaOrderStoreTableViewCell") as! CreaOrderStoreTableViewCell
//        cell.selectionStyle = .none
//        let item = settlement?.data.stores[indexPath.row]
//        cell.name.text = item?.name ?? ""
//        cell.phone.text = "电话：\(item?.telephone ?? "")"
//        cell.address.text = "地址：\(item?.detail ?? "")"
//        cell.time.text = "营业时间：\(item?.openTime ?? "")"
//        if selectIndex == indexPath.row {
//            cell.selectImg.image = UIImage(named: "ic_gouwu")
//        } else {
//            cell.selectImg.image = UIImage(named: "ic_zhifu")
//        }
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        didSelectStore?(settlement?.data.stores[selectIndex])
//        self.navigationController?.popViewController(animated: true)
//    }
//}
