//
//  OrderViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/28.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    @IBOutlet weak var topBgView: UIView!

    @IBOutlet weak var tableView: UITableView!
    var tab_status: String = "1"
    let page = 1
    var data: Order? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "订单管理"
        self.setUp()
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
            bt.setTitleColor(bt.tintColor, for: .selected)
            bt.isSelected = false
        }
        btn.isSelected = true
    }

    func setUp() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
        tableView.register(UINib(nibName: "CreatOrderGoodsTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatOrderGoodsTableViewCell")
        tableView.register(UINib(nibName: "OrderBottomTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderBottomTableViewCell")
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        setShadow(view: topBgView, sColor: UIColor.init(white: 0.8, alpha: 1), offset: CGSize(width: 0, height: 0), opacity: 1, radius: 5)
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
        API.orderList(tab_status: tab_status, page: "\(page)").request { (result) in
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
            self.loadData()
        }
    }
}
extension OrderViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (data?.data[section].products.count ?? 0) + 2
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return data?.data.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell") as! OrderTableViewCell
            cell.selectionStyle = .none
            let item = data?.data[indexPath.section]
            cell.name.text = item?.statusName
            return cell
        } else if indexPath.row < (data?.data[indexPath.section].products.count ?? 0) + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderGoodsTableViewCell") as! CreatOrderGoodsTableViewCell
            let item = data?.data[indexPath.section].products[indexPath.row - 1]
            cell.img.af_setImage(withURL: URL(string: item!.image)!)
            cell.name.text = item?.name ?? ""
            cell.price.text = "￥\(item?.price ?? "0")"
            cell.info.text = item?.optionUnionName ?? ""
            cell.num.text = "X\(item?.quantity ?? "0")"
            cell.selectionStyle = .none
            cell.shadowsLeftRight()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderBottomTableViewCell") as! OrderBottomTableViewCell
            cell.selectionStyle = .none
            let item = data?.data[indexPath.section]
            cell.price.text = "共\(item?.products.count ?? 0)件商品  合计: ￥\(item?.price ?? "0.00")"
            cell.setBtn(tag: Int(item?.orderStatus ?? "0") ?? 0)
            cell.leftBtn.addTarget(self, action: #selector(updateOrder(btn:)), for: .touchUpInside)
            cell.leftBtn.tag = (indexPath.section * 100) + 1
            cell.rightBtn.tag = (indexPath.section * 100) + 2
            cell.rightBtn.addTarget(self, action: #selector(updateOrder(btn:)), for: .touchUpInside)

            return cell
        }
    }

    @objc func updateOrder(btn: UIButton) {
        let tag = btn.tag / 100
        if btn.titleLabel?.text == "付款" {
            let pay = OrderPayViewController()
            pay.order_id = data?.data[tag].id ?? ""
            self.navigationController?.pushViewController(pay, animated: true)
        } else if btn.titleLabel?.text == "确认收货" {
            updateOrderStatus(id: data?.data[tag].id ?? "", type: "confirm")
        } else if btn.titleLabel?.text == "删除订单" {
            updateOrderStatus(id: data?.data[tag].id ?? "", type: "delete")
        } else if btn.titleLabel?.text == "查看物流" {

        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        } else if indexPath.row < (data?.data[indexPath.section].products.count ?? 0) + 1 {
            return 106
        } else {
            let item = data?.data[indexPath.section]
            if item?.orderStatus == "2" || item?.orderStatus == "3" {
                return 60
            }
            return 86
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = OederDetailViewController()
        detail.order_id = data?.data[indexPath.section].id ?? ""
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
