//
//  FavoriteViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/17.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var page = 1
    var data:FavoriteList? = nil
    var edid = false
    var selectIndex: [Int] = []
    @IBOutlet weak var bottom: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "收藏"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: .done, target: self, action: #selector(edit))
        tableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.tableviewBackgroundColor
        tableView.separatorStyle = .none
        bottom.constant = 0
        
        loadData()
    }

    @objc func edit() {
        edid = !edid
        if edid {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(edit))
            bottom.constant = 62
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: .done, target: self, action: #selector(edit))
            bottom.constant = 0
        }
        tableView.reloadData()
    }

    func loadData() {
        API.favoriteList(page: "\(page)").request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.tableView.reloadData()
            case .failure(let er):
                print(er)
            }
        }
    }

//    @IBAction func delete(_ sender: Any) {
//
//    }
    @IBAction func all(_ sender: Any) {
        if selectIndex.count == data?.data.count {
                   selectIndex = []
               } else {
                   selectIndex = []
                   for index in 0..<(data?.data.count ?? 0) {
                       selectIndex.append(index)
                   }
               }
               tableView.reloadData()
    }
}
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.data.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell") as! FavoriteTableViewCell
        cell.selectionStyle = .none
        let item = data?.data[indexPath.row]
        if !(item?.image.isEmpty ?? true) {
        cell.img.af_setImage(withURL: URL(string: item?.image ?? "")!)
        }
        cell.name.text = item?.name
        cell.info.text = item?.name
        cell.price.text = "￥\(item?.price ?? "")"
        var select = -1
        for index in 0..<selectIndex.count {
            if indexPath.row == selectIndex[index] {
                select = index
            }
        }
        if -1 != select {
            cell.select.image = UIImage(named: "未选择")
        } else {
            cell.select.image = UIImage(named: "选中")
        }
        if !edid {
            cell.select.isHidden = true
            cell.left.constant = 0
            cell.width.constant = 0
            cell.right.constant = 16
        } else {
            cell.select.isHidden = false
            cell.left.constant = 15
            cell.width.constant = 25
            cell.right.constant = 0
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var select = -1
        for index in 0..<selectIndex.count {
            if indexPath.row == selectIndex[index] {
                select = index
            }
        }
        if select < 0 {
            selectIndex.append(indexPath.row)
        } else {
            selectIndex.remove(at: select)
        }
        tableView.reloadData()
    }
}
