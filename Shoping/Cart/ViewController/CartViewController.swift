//
//  CartViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2019/12/25.
//  Copyright © 2019 付强. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var heig: NSLayoutConstraint!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var selectAll: UIButton!
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var settlementBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var data: CartList? = nil
    var selectIndex: [Int] = []
    var product_id: String? = ""
    var quantity: String? = ""
    var product_option_union_id: String? = ""
    var status: Stats? = nil
    var edit = false
    var deleteIndex: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let itme = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = itme
        self.navigationController?.navigationBar.isTranslucent = false
        setUp()
        setShadow(view: backView, sColor: UIColor.init(white: 0.8, alpha: 1), offset: CGSize(width: 0, height: 0), opacity: 1, radius: 5)
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
        if edit {
            var selectData: [String] = []
            for index in deleteIndex {
                if let item = data?.data.cart[index - 1] {
                    selectData.append(item.id)
                }
            }
            if selectData.count < 1 {
                CLProgressHUD.showError(in: view, delegate: self, title: "请选择商品", duration: 1)
                return

            }
            API.deleteCart(id: selectData).request { (result) in
                switch result {
                case .success( _):
                    self.loadData()
                case .failure(let er):
                    print(er)
                }
            }
            return
        }
        var selectData: [Cart] = []
        for index in selectIndex {
            if let item = data?.data.cart[index - 1] {
                selectData.append(item)
            }
        }
        if selectData.count < 1 {
            CLProgressHUD.showError(in: view, delegate: self, title: "请选择商品", duration: 1)
            return
        }
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
        tableView.register(UINib(nibName: "CartHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "CartHeaderTableViewCell")
        selectAll.imageView?.contentMode = .scaleAspectFit
        selectAll.addTarget(self, action: #selector(selectAllBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: .done, target: self, action: #selector(editAction))

    }

    @objc func editAction() {
        edit = !edit
        if edit {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(editAction))
            settlementBtn.backgroundColor = UIColor.gray
            settlementBtn.setTitle("删除", for: .normal)
            num.text = ""
            deleteIndex = []
            tableView.reloadData()
            setBotoomInfo()
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: .done, target: self, action: #selector(editAction))
            settlementBtn.backgroundColor = settlementBtn.tintColor
            setBotoomInfo()
            tableView.reloadData()
        }
    }

    @objc func selectAllBtn() {
        if edit {
            if deleteIndex.count == data?.data.cart.count {
                        deleteIndex = []
                    } else {
                        deleteIndex = []
                        for index in 0..<(data?.data.cart.count ?? 0) {
                            deleteIndex.append(index + 1)
                        }
                    }
                    tableView.reloadData()
            setBotoomInfo()
        } else {
        if selectIndex.count == data?.data.cart.count {
            selectIndex = []
            var selectData: [String] = []
            for item in data?.data.cart ?? [] {
//                if let item = data?.data.cart[index - 1] {
                    selectData.append(item.id)
//                }
            }
            statusCart(str: "c", ids: selectData)
        } else {
            selectIndex = []
            for index in 0..<(data?.data.cart.count ?? 0) {
                selectIndex.append(index + 1)
            }
            var selectData: [String] = []
            for index in selectIndex {
                if let item = data?.data.cart[index - 1] {
                    selectData.append(item.id)
                }
            }
            statusCart(str: "s", ids: selectData)
        }
        tableView.reloadData()
        setBotoomInfo()
        }
    }

    func statusCart(str: String, ids: [String]) {
        API.cartStatsChange(status: str, ids: ids).request { (result) in
            switch result {
            case .success(let data):
                self.status = data.data.stats
                self.tableView.reloadData()
                self.setBotoomInfo()
            case .failure(let er):
                print(er)
            }
        }
    }

    func loadData() {
        API.cartList().request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.status = data.data.stats
                if data.data.cart.count == 0 {
                    self.heig.constant = 0
                    self.tableView.isHidden = true
                } else {
                    self.heig.constant = CGFloat(156*data.data.cart.count) + 50
                    self.tableView.isHidden = false
                }
                self.tableView.reloadData()
//                self.selectAllBtn()
//                if self.selectIndex.count == 0 {
//                    self.selectAllBtn()
//                }

                self.selectIndex = []
                for index in 0..<(data.data.cart.count) {
                    if data.data.cart[index].checkedFlag == "1" {
                    self.selectIndex.append(index + 1)
                    }
                }
//                if self.selectIndex.count == data.data.cart.count {
                    self.setBotoomInfo()
//                }


                self.setShadow(view: self.tableView, sColor: UIColor.init(white: 0.8, alpha: 1), offset: CGSize(width: 0, height: 0), opacity: 1, radius: 5)
            case .failure(let error):
                self.data = nil
                self.heig.constant = 0
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
        return (data?.data.cart.count != nil && data?.data.cart.count ?? 0 > 0) ? (data?.data.cart.count ?? 0) + 1 : 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartHeaderTableViewCell") as! CartHeaderTableViewCell
            cell.selectionStyle = .none
            if selectIndex.count == data?.data.cart.count {
                cell.img.setImage(UIImage(named: "ic_gouwu"), for: .normal)
            } else {
                cell.img.setImage(UIImage(named: "ic_zhifu"), for: .normal)
            }
            cell.name.text = status?.feeMsgContent ?? ""
            if status?.feeMsgContent ?? "" == "" {
                cell.btn.isHidden = true
            } else {
                cell.btn.isHidden = false
            }
            if edit {
                cell.img.setImage(UIImage(named: "ic_zhifu"), for: .normal)
            }
            cell.btn.addTarget(self, action: #selector(toCollectBills), for: .touchUpInside)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardListTableViewCell") as! CardListTableViewCell
        let item = data?.data.cart[indexPath.row - 1]
        cell.img.af_setImage(withURL: URL(string: item!.image)!)
        cell.name.text = item?.name
        cell.detail.text = item?.optionUnionName
        cell.textField.text = item?.quantity
        cell.price.text = "￥\(item?.price ?? "0")"
        var select = -1
        if edit {
            for index in 0..<deleteIndex.count {
                if indexPath.row == deleteIndex[index] {
                    select = index
                }
            }
        } else {
        for index in 0..<selectIndex.count {
            if indexPath.row == selectIndex[index] {
                select = index
            }
        }
        }
        cell.addBtn.tag = indexPath.row - 1
        cell.reduceBtn.tag = indexPath.row - 1 + 1000
        cell.addBtn.addTarget(self, action: #selector(addNum(btn:)), for: .touchUpInside)
        cell.reduceBtn.addTarget(self, action: #selector(jianNum(btn:)), for: .touchUpInside)
        cell.setSelect(select: select == -1 ? false : true)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {return 50}
        return 156
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if edit {
            var select = -1
            for index in 0..<deleteIndex.count {
                if indexPath.row == deleteIndex[index] {
                    select = index
                }
            }
            if select < 0 {
                deleteIndex.append(indexPath.row)
            } else {
                deleteIndex.remove(at: select)
            }
            tableView.reloadData()
            setBotoomInfo()
            return
        }
        if indexPath.row == 0 {
            selectAllBtn()
            return
        }
        var select = -1
        for index in 0..<selectIndex.count {
            if indexPath.row == selectIndex[index] {
                select = index
            }
        }
        if select < 0 {
            selectIndex.append(indexPath.row)
            statusCart(str: "s", ids: [(data?.data.cart[indexPath.row - 1].id ?? "")])
        } else {
            selectIndex.remove(at: select)
            statusCart(str: "c", ids: [data?.data.cart[indexPath.row - 1].id ?? ""])
        }
        tableView.reloadData()
        if indexPath.row != 0 {
            setBotoomInfo()
        }

    }

    @objc func addNum(btn: UIButton) {
        let id = data?.data.cart[btn.tag].id ?? ""
        let num = (Int(data?.data.cart[btn.tag].quantity ?? "0") ?? 0) + 1

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
        let id = data?.data.cart[btn.tag - 1000].id ?? ""
        let num = (Int(data?.data.cart[btn.tag - 1000].quantity ?? "0") ?? 0) - 1
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

    func setShadow(view:UIView,sColor:UIColor,offset:CGSize,
                   opacity:Float,radius:CGFloat) {
        //设置阴影颜色
        view.layer.shadowColor = sColor.cgColor
        //设置透明度
        view.layer.shadowOpacity = opacity
        //设置阴影半径
        view.layer.shadowRadius = radius
        //设置阴影偏移量
        view.layer.shadowOffset = offset
    }

    func setBotoomInfo() {
        if edit {
            if deleteIndex.count == data?.data.cart.count, data?.data.cart.count != 0 {
                selectAll.setImage(UIImage(named: "ic_gouwu"), for: .normal)
            } else {
                selectAll.setImage(UIImage(named: "ic_zhifu"), for: .normal)
            }
        } else {
        if selectIndex.count == data?.data.cart.count, data?.data.cart.count != 0 {
            selectAll.setImage(UIImage(named: "ic_gouwu"), for: .normal)
        } else {
            selectAll.setImage(UIImage(named: "ic_zhifu"), for: .normal)
        }
        if selectIndex.count == 0 {
            settlementBtn.setTitle("立即购买", for: .normal)
        } else {
            settlementBtn.setTitle("立即购买", for: .normal)
        }
        var numPrice:Double = 0.00

            for index in selectIndex {
                let item = data?.data.cart[index - 1]
                let price = Double(item?.price ?? "0")
                let numCnt = Double(item?.quantity ?? "0")
                let p = (price ?? 0.00)*(numCnt ?? 0.00)
                numPrice = numPrice + p
            }
        num.text = "合计:￥\(status?.total ?? "0")"
        }
    }

    @objc func toCollectBills() {
        let collect = CartCollectBillsViewController()
        collect.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(collect, animated: true)
    }
}
