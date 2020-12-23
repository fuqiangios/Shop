//
//  DiscountViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/3/15.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class DiscountViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var line: UILabel!
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var guoqi: UIButton!
    @IBOutlet weak var noUse: UIButton!
    var type = "1"
    var data: CouponList? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "优惠券"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        tableView.register(UINib(nibName: "GoodsPopUpTransateTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsPopUpTransateTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        loadData()
    }

    @IBAction func shouruAction(_ sender: UIButton) {
        updateBtnStatus()
//        sender.setTitleColor(sender.tintColor, for: .normal)
        type = "1"
        line.center = CGPoint(x: sender.center.x, y: sender.center.y + 20)
        loadData()
    }

    @IBAction func zhichuAction(_ sender: UIButton) {
        updateBtnStatus()
//        sender.setTitleColor(sender.tintColor, for: .normal)
        type = "2"
        line.center = CGPoint(x: sender.center.x, y: sender.center.y + 20)
        loadData()
    }
    @IBAction func shiyong(_ sender: UIButton) {
        type = "3"
        line.center = CGPoint(x: sender.center.x, y: sender.center.y + 20)
        loadData()
    }

    func updateBtnStatus() {
//        for index in 100...101 {
//            let btn = view.viewWithTag(index)as!UIButton
//            btn.setTitleColor(.black, for: .normal)
//        }
    }

    func loadData() {
        API.couponData(type: type).request { (result) in
            switch result{
            case .success(let data):
                self.data = data
//                self.price.text = data.data.redPackage
                self.tableView.reloadData()
            case .failure(let er):
                print(er)
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension DiscountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.data.couponList.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsPopUpTransateTableViewCell") as! GoodsPopUpTransateTableViewCell
                       cell.selectionStyle = .none
        if type == "1" {
            cell.backImg.image = UIImage(named: "优惠券底色")
        } else {
            cell.backImg.image = UIImage(named: "")
        }
        cell.price.text = "\(data?.data.couponList[indexPath.row].faceValue ?? "")  \(data?.data.couponList[indexPath.row].unit ?? "")"
                       cell.info.text = data?.data.couponList[indexPath.row].name
        cell.tips.text = data?.data.couponList[indexPath.row].detail
        cell.date.text = "\(data?.data.couponList[indexPath.row].startTime ?? "") 至\(data?.data.couponList[indexPath.row].endTime ?? "")"
        cell.bbtn.isHidden = true

                       return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
