//
//  OrderPayViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/3/6.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class OrderPayViewController: UIViewController {
    @IBOutlet weak var price: UILabel!

    @IBOutlet weak var tableVIewHeight: NSLayoutConstraint!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var metch: UILabel!
    var selectIndex: Int = -1
    var payList: PayList? = nil
    var order_id: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setUp()
        loadPayListData()
    }

    func setUp() {
        tableVIew.register(UINib(nibName: "OrderPayTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderPayTableViewCell")
        tableVIew.delegate = self
        tableVIew.dataSource = self
        tableVIew.estimatedRowHeight = 150
        tableVIew.rowHeight = UITableView.automaticDimension
        tableVIew.separatorStyle = .none

        submitBtn.addTarget(self, action: #selector(amountPay), for: .touchUpInside)
    }

    @objc func amountPay() {
        API.orderPay(order_id: order_id, payment_pfn: payList?.data.payment[selectIndex].pfn ?? "", payment_method: payList?.data.payment[selectIndex].name ?? "").request { (result) in
            switch result {
                case .success:
                    print("success")
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print(error)
                    print(error.self)
                    print(error.localizedDescription)
            }
        }
    }

    func loadPayListData() {
        API.payList(order_id: order_id).request { (result) in
            switch result {
            case .success(let data):
                self.payList = data
                self.tableVIew.reloadData()
                self.tableVIewHeight.constant = CGFloat(82 * data.data.payment.count)
            case .failure(let error):
                print(error)
                print(error.self)
                print(error.localizedDescription)
            }
        }
    }

}
extension OrderPayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payList?.data.payment.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPayTableViewCell") as! OrderPayTableViewCell
        cell.name.text = payList?.data.payment[indexPath.row].name ?? ""
        cell.img.af_setImage(withURL: URL(string: (payList?.data.payment[indexPath.row].getIcon())!)!)
        if indexPath.row == selectIndex {
            cell.selectImg.image = UIImage(named: "ic_fu")
        } else {
            cell.selectImg.image = UIImage(named: "ic_ellipse")
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        tableView.reloadData()
    }

}
