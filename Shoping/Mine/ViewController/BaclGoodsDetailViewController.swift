//
//  BaclGoodsDetailViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/27.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class BaclGoodsDetailViewController: UIViewController {

    @IBOutlet weak var typeLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!
    var id = ""
    var data: AfterDetail? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.register(UINib(nibName: "BaclGoodsDetailGoodsTableViewCell", bundle: nil), forCellReuseIdentifier: "BaclGoodsDetailGoodsTableViewCell")
        tableView.register(UINib(nibName: "BaclGoodsDetailinfoTableViewCell", bundle: nil), forCellReuseIdentifier: "BaclGoodsDetailinfoTableViewCell")
        tableView.register(UINib(nibName: "BaclGoodsDetailDateTableViewCell", bundle: nil), forCellReuseIdentifier: "BaclGoodsDetailDateTableViewCell")
        tableView.register(UINib(nibName: "BaclFinshTableViewCell", bundle: nil), forCellReuseIdentifier: "BaclFinshTableViewCell")
        tableView.register(UINib(nibName: "OrderFInshTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderFInshTableViewCell")
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.tableviewBackgroundColor
        loadData()
    }

    func loadData() {
        API.getAftersaleDetail(aftersale_id: id).request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.typeLabel.text = data.data.afterSale.statusName
                self.tableView.reloadData()
            case .failure(let er):
                print(er)
            }
        }
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension BaclGoodsDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return data == nil ? 0 : 2
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 15
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
         let cell = tableView.dequeueReusableCell(withIdentifier: "BaclGoodsDetailGoodsTableViewCell") as! BaclGoodsDetailGoodsTableViewCell
        cell.selectionStyle = .none
            cell.img.af_setImage(withURL: URL(string: (data?.data.orderProduct.image)!)!)
            cell.name.text = data?.data.orderProduct.name ?? ""
            cell.price.text = "￥\(data?.data.orderProduct.price ?? "")"
            cell.num.text = data?.data.orderProduct.quantity

        return cell
        } else {
            if indexPath.row == 0 {
                 let cell = tableView.dequeueReusableCell(withIdentifier: "BaclGoodsDetailinfoTableViewCell") as! BaclGoodsDetailinfoTableViewCell
                cell.selectionStyle = .none
                cell.order.text = data?.data.orderProduct.orderID
                cell.date.text = data?.data.afterSale.created
                cell.type.text = data?.data.afterSale.aftersaleTypeName
                cell.info.text = data?.data.afterSale.aftersaleReasonName
                return cell
            } else {
                 let cell = tableView.dequeueReusableCell(withIdentifier: "BaclGoodsDetailDateTableViewCell") as! BaclGoodsDetailDateTableViewCell
                cell.address.text = data?.data.address.address
                cell.name.text = data?.data.address.userName
                cell.phone.text = data?.data.address.telephone
                cell.selectionStyle = .none

                return cell
            }
        }
    }
}
