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
        tableView.register(UINib(nibName: "CommunityDetailHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "CommunityDetailHeaderTableViewCell")
        tableView.register(UINib(nibName: "CommunityDetailImgTableViewCell", bundle: nil), forCellReuseIdentifier: "CommunityDetailImgTableViewCell")
        tableView.register(UINib(nibName: "CommunityDetailTextTableViewCell", bundle: nil), forCellReuseIdentifier: "CommunityDetailTextTableViewCell")

        tableView.register(UINib(nibName: "CommunityDetailReadNumTableViewCell", bundle: nil), forCellReuseIdentifier: "CommunityDetailReadNumTableViewCell")
        tableView.register(UINib(nibName: "CommunityTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "CommunityTitleTableViewCell")
        tableView.register(UINib(nibName: "CommunityEvaluateTableViewCell", bundle: nil), forCellReuseIdentifier: "CommunityEvaluateTableViewCell")
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
        if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityDetailHeaderTableViewCell") as! CommunityDetailHeaderTableViewCell
        cell.selectionStyle = .none
        return cell
        } else if indexPath.row <= 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityDetailImgTableViewCell") as! CommunityDetailImgTableViewCell
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 1 + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityDetailTextTableViewCell") as! CommunityDetailTextTableViewCell
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 1 + 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityDetailReadNumTableViewCell") as! CommunityDetailReadNumTableViewCell
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 1 + 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityTitleTableViewCell") as! CommunityTitleTableViewCell
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityEvaluateTableViewCell") as! CommunityEvaluateTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
}
