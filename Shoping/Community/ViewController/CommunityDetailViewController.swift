//
//  CommunityDetailViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/20.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class CommunityDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "详情"
        tableView.register(UINib(nibName: "AddNewCommunityInputTableViewCell", bundle: nil), forCellReuseIdentifier: "AddNewCommunityInputTableViewCell")
        tableView.register(UINib(nibName: "AddNewCommunityImgTableViewCell", bundle: nil), forCellReuseIdentifier: "AddNewCommunityImgTableViewCell")
        tableView.register(UINib(nibName: "AddNewCommunityTextTableViewCell", bundle: nil), forCellReuseIdentifier: "AddNewCommunityTextTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
    }
}
extension CommunityDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewCommunityTextTableViewCell") as! AddNewCommunityTextTableViewCell
        cell.selectionStyle = .none
        return cell
    }


}
