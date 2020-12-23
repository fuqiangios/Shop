//
//  StoreListViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/22.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class StoreListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var data: StoreList? = nil
    var longitude = 0.00
    var latitude = 0.00
    var shiop = ""
    var didSelectAddress: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "选择地点"
        setUp()
        loadData()
    }
    func setUp() {
        tableView.register(UINib(nibName: "StoreTableViewCell", bundle: nil), forCellReuseIdentifier: "StoreTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.white
//        tableView.separatorStyle = .none
        let vi = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        let l = UILabel(frame: CGRect(x: 16, y: 0, width: view.frame.width - 32, height: 60))
        l.text = "当前位置: \(shiop)"
        l.textColor = .black
        l.backgroundColor = .white
        vi.addSubview(l)
        tableView.tableHeaderView = vi
    }

    func loadData() {
        API.storeData(longitude: "\(longitude)", latitude: "\(latitude)").request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.tableView.reloadData()
            case .failure(let er):
                print(er)
            }
        }
    }
}
extension StoreListViewController: UITableViewDelegate,
UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.data[section].shops.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return data?.data.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTableViewCell") as! StoreTableViewCell
        cell.name.text = data?.data[indexPath.section].shops[indexPath.row].name
        cell.info.text = "距您\(data?.data[indexPath.section].shops[indexPath.row].distance ?? "0")"
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data?.data[section].name
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bg = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
        bg.backgroundColor = .white
        let lb = UILabel(frame: CGRect(x: 16, y: 0, width: 200, height: 30))
        lb.text = data?.data[section].name
        lb.textColor = .black
        lb.backgroundColor = .clear
        bg.backgroundColor = UIColor.lineColor
        bg.addSubview(lb)
        return bg
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let shop = data?.data[indexPath.section].shops[indexPath.row]{
            didSelectAddress?("\(data?.data[indexPath.section].name ?? "") \(shop.name)")
            self.navigationController?.popViewController(animated: true)
        }
    }
}
