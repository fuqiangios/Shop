//
//  AddNewCommunityViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/19.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class AddNewCommunityViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "新发布"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .done, target: self, action: #selector(submit))
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
    @objc func submit() {

    }
}
extension AddNewCommunityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row <= 1 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewCommunityInputTableViewCell") as! AddNewCommunityInputTableViewCell
        cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.title.text = "标题"
                cell.input.placeholder = "输入标题"
                cell.img.isHidden = true
            } else {
                cell.title.text = "选择分类"
                cell.input.placeholder = "选择分类"
                cell.img.isHidden = true
            }
        return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewCommunityImgTableViewCell") as! AddNewCommunityImgTableViewCell
            cell.updateTableView = { () in
                tableView.reloadData()
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewCommunityTextTableViewCell") as! AddNewCommunityTextTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
   
}
