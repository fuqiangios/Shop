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
    
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var guoqi: UIButton!
    @IBOutlet weak var noUse: UIButton!
    var type = "1"
    var data: Redpackge? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "GoodsPopUpTransateTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsPopUpTransateTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        loadData()
    }

    @IBAction func shouruAction(_ sender: UIButton) {
        updateBtnStatus()
        sender.setTitleColor(sender.tintColor, for: .normal)
        type = "1"
        loadData()
    }

    @IBAction func zhichuAction(_ sender: UIButton) {
        updateBtnStatus()
        sender.setTitleColor(sender.tintColor, for: .normal)
        type = "2"
        loadData()
    }

    func updateBtnStatus() {
        for index in 100...101 {
            let btn = view.viewWithTag(index)as!UIButton
            btn.setTitleColor(.black, for: .normal)
        }
    }

    func loadData() {
        API.redpackgeList(type: type).request { (result) in
            switch result{
            case .success(let data):
                self.data = data
//                self.price.text = data.data.redPackage
                self.tableView.reloadData()
            case .failure:
                print("error")
            }
        }
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension DiscountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsPopUpTransateTableViewCell") as! GoodsPopUpTransateTableViewCell
            cell.selectionStyle = .none
//            cell.price.text = data[indexPath.row].faceValue
//            cell.info.text = data[indexPath.row].name
//            if data[indexPath.row].hasReceive {
//                cell.bbtn.backgroundColor = UIColor.init(red: 178.0/255.0, green: 169.0/255.0, blue: 168.0/255.0, alpha: 1)
//                cell.bbtn.setTitle("已领取", for: .normal)
//                cell.bbtn.ixsUserInteractionEnabled = false
//            }
//            cell.bbtn.tag = indexPath.row + 10000
//            cell.bbtn.addTarget(self, action: #selector(getCopun(btn:)), for: .touchUpInside)
            return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
