//
//  IntegralViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/3/15.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class IntegralViewController: UIViewController {
    var data: Point? = nil
    @IBOutlet weak var pointLable: UILabel!
    @IBOutlet weak var toBtn: UIButton!
    @IBOutlet weak var priceLable: UILabel!

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        title = "积分"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "查看明细", style: .done, target: self, action: #selector(toDetail))
        toBtn.layer.borderColor = UIColor.white.cgColor
        toBtn.layer.borderWidth = 1
        toBtn.layer.cornerRadius = 25
        tableView.register(UINib(nibName: "IntegraDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "IntegraDetailTableViewCell")


        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        loadData()
    }

    @objc func toDetail() {
        let detail = IntegraDetailViewController()
        self.navigationController?.pushViewController(detail, animated: true)
    }

    func loadData() {
        API.pointInfo().request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.setUp()
                self.tableView.reloadData()
            case .failure(let er):
                print(er)
            }
        }
    }

    func setUp() {
        pointLable.text = "\(data?.data.points ?? 0)"
        priceLable.text = "\(data?.data.pointUnit ?? "0")"

    }
    @IBAction func toAction(_ sender: Any) {
        let pay = IntegraPayViewController()
        self.navigationController?.pushViewController(pay, animated: true)
    }
}
extension IntegralViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.data.points_list.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IntegraDetailTableViewCell") as! IntegraDetailTableViewCell
        cell.selectionStyle = .none
        let item = data?.data.points_list[indexPath.row]
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
