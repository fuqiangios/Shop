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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    func setUp() {
        tableView.register(UINib(nibName: "StoreTableViewCell", bundle: nil), forCellReuseIdentifier: "StoreTableViewCell")
    }
}
extension StoreListViewController: UITableViewDelegate,
UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.data[section].cityStore.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return data?.data.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTableViewCell") as! StoreTableViewCell
        cell.name.text = data?.data[indexPath.section].cityStore[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data?.data[section].cityName
    }
}
