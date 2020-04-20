//
//  IntegraPayViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/16.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class IntegraPayViewController: UIViewController {
    var data: PointPayPage? = nil

    @IBOutlet weak var hei: NSLayoutConstraint!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var point: UILabel!
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pointUnt: UILabel!
    var selectIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(UINib(nibName: "CreatOrderPayTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatOrderPayTypeTableViewCell")
        hei.constant = 120
        loadData()
    }

    func loadData() {
        API.pointPayPage().request { (result) in
            switch result{
            case .success(let data):
                self.data = data
                self.pointUnt.text = data.data.pointUnit
                self.point.text = data.data.shortPoints
            case .failure(let er):
                print(er)
            }
        }
    }

    @IBAction func allAction(_ sender: Any) {
        input.text = data?.data.shortPoints ?? "0"
    }

    @IBAction func payAction(_ sender: Any) {
        API.pointPay(point: input.text ?? "0", type: "").request { (result) in
            switch result{
            case .success:
                self.navigationController?.popViewController(animated: true)
            case .failure(let er):
                print(er)
            }
        }
    }
    @IBAction func bbackAction(_ sender: Any) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.popViewController(animated: true)
    }
}
extension IntegraPayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderPayTypeTableViewCell") as! CreatOrderPayTypeTableViewCell
//        cell.name.text = payList?.data.payment[indexPath.row].name ?? ""
//        cell.img.af_setImage(withURL: URL(string: (payList?.data.payment[indexPath.row].getIcon())!)!)
        if indexPath.row == selectIndex {
            cell.selectImg.image = UIImage(named: "选中")
        } else {
            cell.selectImg.image = UIImage(named: "未选择")
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        self.tableView.reloadData()
    }

}
