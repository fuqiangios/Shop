//
//  CreatOrderSelectDiscountViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/22.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class CreatOrderSelectDiscountViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn: UIButton!
    var settlement: OrderSettlement? = nil
    var selectIndex: Int = 0
    var didSelectDiscount: ((Int) -> Void)?
    var reson: [Reason]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    func setUp() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "CreatOrderSelectDiscountTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatOrderSelectDiscountTableViewCell")
        tableView.backgroundColor = .white
    }

    @IBAction func finshSelectAction(_ sender: Any) {
        didSelectDiscount?(-1)
        self.dismiss(animated: true, completion: nil)
    }
}
extension CreatOrderSelectDiscountViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reson !=  nil {
            return reson?.count ?? 0
        }
        return (settlement?.data.coupons.count ?? 0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderSelectDiscountTableViewCell") as! CreatOrderSelectDiscountTableViewCell

                if reson != nil {
                    cell.name.text = reson?[indexPath.row].name ?? ""
                    cell.info.text = ""
                    if selectIndex == indexPath.row {
                        cell.img.image = UIImage(named: "优惠券选中")
                    } else {
                        cell.img.image = UIImage(named: "")
                    }
                    cell.selectionStyle = .none
                    return cell
                }
                    cell.name.text = settlement?.data.coupons[indexPath.row].detail ?? ""
        cell.price.text =  settlement?.data.coupons[indexPath.row].faceValue
                    cell.date.text = "有限期至\(settlement?.data.coupons[indexPath.row].end_time ?? "")\n"
        cell.info.text = "满\(settlement?.data.coupons[indexPath.row].useableValue ?? "0")元可以使用"
                if selectIndex == indexPath.row {
                    cell.img.image = UIImage(named: "优惠券选中")
                } else {
                    cell.img.image = UIImage(named: "")
                }
//        if reson != nil {
//            cell.name.text = reson?[indexPath.row].name ?? ""
//            cell.info.text = ""
//            if selectIndex == indexPath.row {
//                cell.img.image = UIImage(named: "ic_gouwu")
//            } else {
//                cell.img.image = UIImage(named: "ic_ellipse")
//            }
//            cell.selectionStyle = .none
//            return cell
//        }
//        if indexPath.row == 0 {
//            cell.name.text = "不使用"
//            cell.info.text = ""
//        } else {
//            cell.name.text = settlement?.data.coupons[indexPath.row - 1].detail ?? ""
//            cell.info.text = "有限期至\(settlement?.data.coupons[indexPath.row - 1].end_time ?? "")\n满\(settlement?.data.coupons[indexPath.row - 1].useableValue ?? "0")元可以使用"
//        }
//        if selectIndex == indexPath.row {
//            cell.img.image = UIImage(named: "ic_gouwu")
//        } else {
//            cell.img.image = UIImage(named: "ic_ellipse")
//        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        tableView.reloadData()
        didSelectDiscount?(selectIndex)
        self.dismiss(animated: true, completion: nil)
    }
}
