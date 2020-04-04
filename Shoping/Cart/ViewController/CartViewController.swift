//
//  CartViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2019/12/25.
//  Copyright © 2019 付强. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var selectAll: UIButton!
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var settlementBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var data: CartList? = nil
    var selectIndex: [Int] = []
    var product_id: String? = ""
    var quantity: String? = ""
    var product_option_union_id: String? = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setBotoomInfo()
        settlementBtn.addTarget(self, action: #selector(creatOrder), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationCreatOrder(nofi:)), name: NSNotification.Name(rawValue:"notificationCreatOrder"), object: nil)
        self.navigationController?.navigationBar.tintColor = .black
    }

    override func viewWillAppear(_ animated: Bool) {
         loadData()
    }

    @objc func notificationCreatOrder(nofi : Notification){
        selectIndex = []
        setBotoomInfo()
    }


    @objc func creatOrder() {
        var selectData: [Datum] = []
        for index in selectIndex {
            if let item = data?.data[index] {
                selectData.append(item)
            }
        }
        if selectData.count < 1 { return }
        let creat = CreatOrderViewController()
        creat.data = selectData
        creat.order_type = "1"
        creat.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(creat, animated: true)
    }

    func setUp() {
        title = "购物车"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "CardListTableViewCell", bundle: nil), forCellReuseIdentifier: "CardListTableViewCell")

        selectAll.imageView?.contentMode = .scaleAspectFit
        selectAll.addTarget(self, action: #selector(selectAllBtn), for: .touchUpInside)

    }

    @objc func selectAllBtn() {
        if selectIndex.count == data?.data.count {
            selectIndex = []
        } else {
            selectIndex = []
            for index in 0..<(data?.data.count ?? 0) {
                selectIndex.append(index)
            }
        }
        tableView.reloadData()
        setBotoomInfo()
    }

    func loadData() {
        API.cartList().request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.tableView.reloadData()
            case .failure(let error):
                self.data = nil
                self.tableView.reloadData()
                print(error)
                print(error.self)
                print(error.localizedDescription)
            }
        }
    }
}

extension CartViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.data.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardListTableViewCell") as! CardListTableViewCell
        let item = data?.data[indexPath.row]
        cell.img.af_setImage(withURL: URL(string: item!.image)!)
        cell.name.text = item?.name
        cell.detail.text = item?.optionUnionName
        cell.textField.text = item?.quantity
        cell.price.text = "￥\(item?.price ?? "0")"
        var select = -1
        for index in 0..<selectIndex.count {
            if indexPath.row == selectIndex[index] {
                select = index
            }
        }
        cell.addBtn.tag = indexPath.row
        cell.reduceBtn.tag = indexPath.row + 1000
        cell.addBtn.addTarget(self, action: #selector(addNum(btn:)), for: .touchUpInside)
        cell.reduceBtn.addTarget(self, action: #selector(jianNum(btn:)), for: .touchUpInside)
        cell.setSelect(select: select == -1 ? false : true)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
        setBotoomInfo()
    }

    @objc func addNum(btn: UIButton) {
        let id = data?.data[btn.tag].id ?? ""
        let num = (Int(data?.data[btn.tag].quantity ?? "0") ?? 0) + 1

        API.cartNumChange(quantity: "\(num)", id: id).request { (result) in
            switch result {
            case .success:
                self.loadData()
            case .failure(let error):
                print(error)
                print(error.self)
                print(error.localizedDescription)
            }
        }
    }

    @objc func jianNum(btn: UIButton) {
        let id = data?.data[btn.tag - 1000].id ?? ""
        let num = (Int(data?.data[btn.tag].quantity ?? "0") ?? 0) - 1
        if num < 1 {
            return
        }
        API.cartNumChange(quantity: "\(num)", id: id).request { (result) in
            switch result {
            case .success:
                self.loadData()
            case .failure(let error):
                print(error)
                print(error.self)
                print(error.localizedDescription)
            }
        }
    }

    func setBotoomInfo() {
        if selectIndex.count == data?.data.count, data?.data.count != 0 {
            selectAll.setImage(UIImage(named: "ic_gouwu"), for: .normal)
        } else {
            selectAll.setImage(UIImage(named: "ic_zhifu"), for: .normal)
        }
        if selectIndex.count == 0 {
            settlementBtn.setTitle("结算", for: .normal)
        } else {
            settlementBtn.setTitle("结算(\(selectIndex.count))", for: .normal)
        }
        var numPrice:Double = 0.00

            for index in selectIndex {
                let item = data?.data[index]
                let price = Double(item?.price ?? "0")
                let numCnt = Double(item?.quantity ?? "0")
                let p = (price ?? 0.00)*(numCnt ?? 0.00)
                numPrice = numPrice + p
            }
        num.text = "不含运费 合计:￥\(numPrice)"
    }
}
