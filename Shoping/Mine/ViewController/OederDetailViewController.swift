//
//  OederDetailViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/3/3.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class OederDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    var addressInfo:AddressDatum? = nil
    var data: OrderDetail? = nil
    var order_id = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        loadData()
    }

    func loadData() {
        API.orderDetail(orderId: order_id).request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.title = data.data.statusName
                self.tableView.reloadData()
                self.setBtn(tag: Int(data.data.orderStatus) ?? 0)
            case .failure(let error):
                print(error)
            }
        }
    }

    func setUp() {
        tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CreatOrderAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatOrderAddressTableViewCell")
        tableView.register(UINib(nibName: "CreatOrderGoodsTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatOrderGoodsTableViewCell")
        tableView.register(UINib(nibName: "OrderDetailGoodsTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderDetailGoodsTableViewCell")
        tableView.register(UINib(nibName: "OrderDetailNumTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderDetailNumTableViewCell")
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }

    func setBtn(tag: Int) {
        leftBtn.addTarget(self, action: #selector(updateOrder(btn:)), for: .touchUpInside)
        rightBtn.addTarget(self, action: #selector(updateOrder(btn:)), for: .touchUpInside)
        // 1待付款 2待发货 3待收货 4待评价 5完成
        switch tag {
        case 1:
            leftBtn.isHidden = true
            rightBtn.isHidden = false
            rightBtn.layer.borderColor = rightBtn.tintColor.cgColor
            rightBtn.layer.borderWidth = 1
            rightBtn.layer.cornerRadius = 5
            rightBtn.layer.masksToBounds = true
            rightBtn.setTitle("付款", for: .normal)
            rightBtn.setTitleColor(rightBtn.tintColor, for: .normal)
        case 2:
            leftBtn.isHidden = true
            rightBtn.isHidden = true
        case 3:
            leftBtn.isHidden = false
            leftBtn.layer.borderColor = UIColor.black.cgColor
            leftBtn.layer.borderWidth = 1
            leftBtn.layer.cornerRadius = 5
            leftBtn.layer.masksToBounds = true
            leftBtn.setTitleColor(.black, for: .normal)
            leftBtn.setTitle("查看物流", for: .normal)

            rightBtn.isHidden = false
            rightBtn.layer.borderColor = rightBtn.tintColor.cgColor
            rightBtn.layer.borderWidth = 1
            rightBtn.layer.cornerRadius = 5
            rightBtn.layer.masksToBounds = true
            rightBtn.setTitle("确认收货", for: .normal)
            rightBtn.setTitleColor(rightBtn.tintColor, for: .normal)
        case 4:
            leftBtn.isHidden = false
            leftBtn.layer.borderColor = UIColor.black.cgColor
            leftBtn.layer.borderWidth = 1
            leftBtn.layer.cornerRadius = 5
            leftBtn.layer.masksToBounds = true
            leftBtn.setTitleColor(.black, for: .normal)
            leftBtn.setTitle("删除", for: .normal)

            rightBtn.isHidden = false
            rightBtn.layer.borderColor = rightBtn.tintColor.cgColor
            rightBtn.layer.borderWidth = 1
            rightBtn.layer.cornerRadius = 5
            rightBtn.layer.masksToBounds = true
            rightBtn.setTitle("评论", for: .normal)
            rightBtn.setTitleColor(rightBtn.tintColor, for: .normal)
        case 5:
            rightBtn.isHidden = false
            rightBtn.layer.borderColor = UIColor.black.cgColor
            rightBtn.layer.borderWidth = 1
            rightBtn.layer.cornerRadius = 5
            rightBtn.layer.masksToBounds = true
            rightBtn.setTitleColor(.black, for: .normal)
            rightBtn.setTitle("删除", for: .normal)
        default:
            break
        }
    }

    func updateOrderStatus(id: String, type: String) {
        API.orderUpdateStatus(orderId: id, button_type: type).request { (result) in
            self.loadData()
        }
    }


    @objc func updateOrder(btn: UIButton) {
        if btn.titleLabel?.text == "付款" {
            let pay = OrderPayViewController()
            pay.order_id = order_id
            self.navigationController?.pushViewController(pay, animated: true)
        } else if btn.titleLabel?.text == "确认收货" {
            updateOrderStatus(id: order_id, type: "confirm")
        } else if btn.titleLabel?.text == "删除订单" {
            updateOrderStatus(id: order_id, type: "delete")
        } else if btn.titleLabel?.text == "查看物流" {

        }
    }

}
extension OederDetailViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return (data?.data.products.count ?? 0) + 1
        }
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return data == nil ? 0 : 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderAddressTableViewCell") as! CreatOrderAddressTableViewCell
            if data?.data.shippingName.isEmpty ?? true {
                cell.name.text = "门店自提"
                cell.addressInfo.text = "请前往门店自行提取"
            } else {
            cell.name.text = (data?.data.shippingName ?? "") + "  " + (data?.data.shippingTelephone ?? "")
            cell.addressInfo.text = data?.data.shippingAddress
            }
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 1 {
            if indexPath.row >= data?.data.products.count ?? 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailGoodsTableViewCell") as! OrderDetailGoodsTableViewCell
                cell.selectionStyle = .none
                cell.goodPrice.text = "￥\(data?.data.total ?? "0")"
                cell.discountPrice.text = "-\(data?.data.redPacket ?? "0")"
                cell.youhuiPrice.text = "-\(data?.data.couponPrice ?? "0")"
                cell.shipingPrice.text = "+￥\(data?.data.shippingPrice ?? "0")"
                cell.price.text = "￥\(data?.data.price ?? "0")"
                return cell
            }
           let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderGoodsTableViewCell") as! CreatOrderGoodsTableViewCell
            let item = data?.data.products[indexPath.row]
           cell.img.af_setImage(withURL: URL(string: item!.image)!)
           cell.name.text = item?.name ?? ""
           cell.price.text = "￥\(item?.price ?? "0")"
           cell.info.text = item?.optionUnionName ?? ""
           cell.num.text = "X\(item?.quantity ?? "0")"
           cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.shadowsLeftRightTop()
            } else {
                cell.shadowsLeftRight()
            }
           return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailNumTableViewCell") as! OrderDetailNumTableViewCell
            cell.selectionStyle = .none
            cell.orderNum.text = data?.data.orderCode
            cell.creatDate.text = data?.data.created_time ?? ""
            cell.payDate.text = data?.data.pay_time ?? ""
            cell.retuenDate.text = data?.data.shipping_time ?? ""
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vi = UIView(frame: .zero)
        vi.backgroundColor = .white
        return vi
    }
}
