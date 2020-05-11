//
//  FavoriteViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/17.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import MJRefresh

class FavoriteViewController: UIViewController {

    @IBOutlet weak var selectAllBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
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
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page = self.page + 1
            self.loadDataMore()
        })
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            self.loadData()
        })
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
            self.tableView.mj_header?.endRefreshing()
            switch result {
            case .success(let data):
                self.data = data
                self.tableView.reloadData()
            case .failure(let er):
                print(er)
            }
        }
    }

    func loadDataMore() {
        API.favoriteList(page: "\(page)").request { (result) in
            self.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let data):
                var ar = self.data?.data ?? []
                ar = ar + data.data
                self.data = FavoriteList(result: true, message: "", status: 200, data: ar)
                self.tableView.reloadData()
            case .failure(let er):
                print(er)
            }
        }
    }

    @IBAction func deleteActionn(_ sender: Any) {
        var selectData: [String] = []
        for index in selectIndex {
            if let item = data?.data[index] {
                selectData.append(item.id)
            }
        }
        if selectData.count < 1 { return }
        API.deleteFavorite(ids: selectData).request { (result) in
            switch result {
            case .success(_):
                CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "删除成功", duration: 1)
            case .failure(let er):
                CLProgressHUD.showError(in: self.view, delegate: self, title: "删除失败", duration: 1)
                print(er)
            }
        }
    }
    @IBAction func all(_ sender: UIButton) {
        if selectIndex.count == data?.data.count {
                   selectIndex = []
            selectAllBtn.setImage(UIImage(named: "未选择"), for: .normal)
               } else {
                   selectIndex = []
                   for index in 0..<(data?.data.count ?? 0) {
                       selectIndex.append(index)
                   }
            selectAllBtn.setImage(UIImage(named: "选中"), for: .normal)
               }
               tableView.reloadData()
    }

    @objc func addCart(btn: UIButton) {
        API.addCart(product_id: data?.data[btn.tag - 100].productID
            ?? "", quantity: "1", product_option_union_id: data?.data[btn.tag - 100].product_option_union_id
            ?? "").request { (result) in
            switch result {
            case .success:
                NotificationCenter.default.post(name: NSNotification.Name("notificationCreatOrder"), object: self, userInfo: [:])
                CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "加入购物车成功", duration: 1)
            case .failure(let error):
                CLProgressHUD.showError(in: self.view, delegate: self, title: "库存不足", duration: 1)
                print(error)
            }
        }
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
        cell.info.text = item?.union_option_name
        cell.price.text = "￥\(item?.price ?? "")"
        var select = -1
        for index in 0..<selectIndex.count {
            if indexPath.row == selectIndex[index] {
                select = index
            }
        }
        if -1 == select {
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
        cell.addCart.tag = indexPath.row + 100
        cell.addCart.addTarget(self, action: #selector(addCart(btn:)), for: .touchUpInside)
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
        if selectIndex.count == data?.data.count ?? 0 {
            selectAllBtn.setImage(UIImage(named: "选中"), for: .normal)
        } else {
            selectAllBtn.setImage(UIImage(named: "未选择"), for: .normal)
        }
        tableView.reloadData()
    }
}
