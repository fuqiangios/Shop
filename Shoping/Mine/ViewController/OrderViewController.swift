//
//  OrderViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/28.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import MJRefresh

class OrderViewController: UIViewController {
    @IBOutlet weak var topBgView: UIView!

    @IBOutlet weak var line: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var tab_status: String = "1"
    var page = 1
    var data: Order? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "全部订单"
        self.setUp()
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page = self.page + 1
            self.loadDataMore()
        })
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            self.loadData()
        })

    }

    override func viewDidAppear(_ animated: Bool) {
        let btn = view.viewWithTag((Int(tab_status) ?? 1) + 1)as!UIButton

        self.updateBtn(btn: btn)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        loadData()
    }

    @IBAction func typeAction(_ sender: UIButton) {
        tab_status = "\(sender.tag - 1)"
        updateBtn(btn: sender)
        loadData()
    }

    func updateBtn(btn: UIButton) {
        for index in 1...5 {
            let bt = view.viewWithTag(index)as!UIButton
//            bt.setTitleColor(bt.tintColor, for: .selected)
            bt.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            bt.setTitleColor(UIColor.init(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1), for: .normal)
            bt.isSelected = false
        }
        btn.isSelected = true
        btn.titleLabel?.font = UIFont(name: "Bold", size: 15)
        btn.setTitleColor(UIColor.init(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1), for: .normal)
        line.center = CGPoint(x: btn.center.x, y: btn.center.y + 15)
    }

    func setUp() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        tableView.register(UINib(nibName: "OrderNewGoodsTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderNewGoodsTableViewCell")
        tableView.register(UINib(nibName: "CreatOrderGoodsTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatOrderGoodsTableViewCell")
        tableView.register(UINib(nibName: "OrderBottomTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderBottomTableViewCell")
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
//        setShadow(view: topBgView, sColor: UIColor.init(white: 0.8, alpha: 1), offset: CGSize(width: 0, height: 0), opacity: 1, radius: 5)
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

    func loadData() {
        page = 1
        API.orderList(tab_status: tab_status, page: "\(page)").request { (result) in
            self.tableView.mj_header?.endRefreshing()
            switch result {
            case .success(let data):
                self.data = data
                self.tableView.reloadData()
            case .failure:
                self.data = nil
                self.tableView.reloadData()
            }
        }
    }

    func loadDataMore() {
        API.orderList(tab_status: tab_status, page: "\(page)").request { (result) in
            self.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let data):
                var ar = self.data?.data ?? []
                ar = ar + data.data
                self.data = Order(result: true, message: "", status: 200, data: ar)
                self.tableView.reloadData()
            case .failure:
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func allAction(_ sender: Any) {
        
    }

    @IBAction func payAction(_ sender: Any) {

    }
    @IBAction func deliverAction(_ sender: Any) {

    }
    @IBAction func receivingAction(_ sender: Any) {

    }

    @IBAction func finshAction(_ sender: Any) {

    }

    func updateOrderStatus(id: String, type: String) {
        API.orderUpdateStatus(orderId: id, button_type: type).request { (result) in
            switch result {
            case .success(let data):
                CLProgressHUD.showError(in: self.view, delegate: self, title: data.message, duration: 1)

                self.page = 1
                self.loadData()
            case .failure:
                CLProgressHUD.showError(in: self.view, delegate: self, title: "订单状态无法删除", duration: 1)
            }

        }
    }
}
extension OrderViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.data.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderNewGoodsTableViewCell") as! OrderNewGoodsTableViewCell
        cell.selectionStyle = .none
        let item = data?.data[indexPath.row]
        cell.orderId.text = "订单号: \(item?.orderCode ?? "")"
        cell.num.text = "共\(item?.products.count ?? 0)件"
        cell.status.text = item?.statusName
        let co = UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1)
        if item?.statusName == "交易成功" {
            cell.status.textColor = UIColor(red: 164.0/255.0, green: 214.0/255.0, blue: 78.0/255.0, alpha: 1)
        } else {
            cell.status.textColor = .black
        }
        if item?.products.count ?? 0 >= 1 {
            cell.img0.af_setImage(withURL: URL(string: item?.products[0].image ?? "")!)
            cell.img0.layer.borderWidth = 1
            cell.img0.layer.borderColor = co.cgColor
            cell.img3.image = UIImage(named: "")
            cell.img1.image = UIImage(named: "")
            cell.img1.layer.borderWidth = 0
            cell.img3.layer.borderWidth = 0
        }
        if item?.products.count ?? 0 >= 2 {
            cell.img1.af_setImage(withURL: URL(string: item?.products[1].image ?? "")!)
            cell.img1.layer.borderWidth = 1
            cell.img1.layer.borderColor = co.cgColor
            cell.img3.image = UIImage(named: "")
            cell.img3.layer.borderWidth = 0
        }
        if item?.products.count ?? 0 >= 3 {
            cell.img3.layer.borderWidth = 1
            cell.img3.layer.borderColor = co.cgColor
            cell.img3.af_setImage(withURL: URL(string: item?.products[2].image ?? "")!)
        }
        if item?.products.count ?? 0 == 0 {
            cell.img3.image = UIImage(named: "")
            cell.img0.layer.borderWidth = 0
            cell.img0.layer.borderColor = co.cgColor
            cell.img1.layer.borderWidth = 0
            cell.img3.layer.borderWidth = 0
            cell.img3.layer.borderColor = co.cgColor
            cell.img1.layer.borderColor = co.cgColor
            cell.img0.image = UIImage(named: "")
            cell.img1.image = UIImage(named: "")
        }
        cell.leftBtn.addTarget(self, action: #selector(updateOrder(btn:)), for: .touchUpInside)
        cell.leftBtn.tag = (indexPath.row * 100) + 1
        cell.rightBtn.tag = (indexPath.row * 100) + 2
        cell.rightBtn.addTarget(self, action: #selector(updateOrder(btn:)), for: .touchUpInside)
        cell.deleteBtn.tag = indexPath.row + 999999
        cell.deleteBtn.addTarget(self, action: #selector(deletea(btn:)), for: .touchUpInside)
        cell.setBtn(tag: Int(item?.orderStatus ?? "0") ?? 0)
//            cell.name.text = item?.statusName
        return cell
    }

    @objc func deletea(btn: UIButton) {
        let tag = btn.tag - 999999
        updateOrderStatus(id: data?.data[tag].id ?? "", type: "delete")
    }

    @objc func updateOrder(btn: UIButton) {
        let tag = btn.tag / 100
        if btn.titleLabel?.text == "付款" {
            let pay = OrderPayViewController()
            pay.order_id = data?.data[tag].id ?? ""
            self.navigationController?.pushViewController(pay, animated: true)
        } else if btn.titleLabel?.text == "确认收货" {
            updateOrderStatus(id: data?.data[tag].id ?? "", type: "confirm")
        } else if btn.titleLabel?.text == "删除" {
            updateOrderStatus(id: data?.data[tag].id ?? "", type: "delete")
        } else if btn.titleLabel?.text == "查看物流" {
            let lg = LogisticsViewController()
            lg.order_id = data?.data[tag].id ?? ""
            self.navigationController?.pushViewController(lg, animated: true)
        } else if btn.titleLabel?.text == "评论" {
            let addeva = EvaluateManagerViewController()
            self.navigationController?.pushViewController(addeva, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 193
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = OederDetailViewController()
        detail.order_id = data?.data[indexPath.row].id ?? ""
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
