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
    var backType = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "订单详情"
        if backType == "cart" {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .done, target: self, action: #selector(back))
        }
        setUp()

    }

    @objc func back() {
        self.navigationController?.popToRootViewController(animated: true)
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
//                self.title = data.data.statusName
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
        tableView.register(UINib(nibName: "OrderDetailStatusTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderDetailStatusTableViewCell")
        tableView.register(UINib(nibName: "OrderDetailIDTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderDetailIDTableViewCell")
        tableView.register(UINib(nibName: "OrderDetailMonyTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderDetailMonyTableViewCell")
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
            leftBtn.setTitle("", for: .normal)

            rightBtn.isHidden = false
            rightBtn.layer.borderColor = rightBtn.tintColor.cgColor
            rightBtn.layer.borderWidth = 1
            rightBtn.layer.cornerRadius = 5
            rightBtn.layer.masksToBounds = true
            rightBtn.setTitle("确认收货", for: .normal)
            rightBtn.setTitleColor(rightBtn.tintColor, for: .normal)
        case 4:
            rightBtn.isHidden = false
            rightBtn.layer.borderColor = UIColor.black.cgColor
            rightBtn.layer.borderWidth = 1
            rightBtn.layer.cornerRadius = 5
            rightBtn.layer.masksToBounds = true
            rightBtn.setTitleColor(.black, for: .normal)
            rightBtn.setTitle("删除", for: .normal)

            leftBtn.isHidden = true
//            leftBtn.layer.borderColor = rightBtn.tintColor.cgColor
//            leftBtn.layer.borderWidth = 1
//            leftBtn.layer.cornerRadius = 5
//            leftBtn.layer.masksToBounds = true
//            leftBtn.setTitle("评论", for: .normal)
//            leftBtn.setTitleColor(rightBtn.tintColor, for: .normal)
        case 5:
            rightBtn.isHidden = false
            rightBtn.layer.borderColor = UIColor.black.cgColor
            rightBtn.layer.borderWidth = 1
            rightBtn.layer.cornerRadius = 5
            rightBtn.layer.masksToBounds = true
            rightBtn.setTitleColor(.black, for: .normal)
            rightBtn.setTitle("删除", for: .normal)
                        leftBtn.isHidden = false
            leftBtn.layer.borderColor = UIColor.black.cgColor
                        leftBtn.layer.borderWidth = 1
                        leftBtn.layer.cornerRadius = 5
                        leftBtn.layer.masksToBounds = true
                        leftBtn.setTitle("评论", for: .normal)
            leftBtn.setTitleColor(.black, for: .normal)
        default:
            rightBtn.isHidden = false
            rightBtn.layer.borderColor = UIColor.black.cgColor
            rightBtn.layer.borderWidth = 1
            rightBtn.layer.cornerRadius = 5
            rightBtn.layer.masksToBounds = true
            rightBtn.setTitleColor(.black, for: .normal)
            rightBtn.setTitle("删除", for: .normal)
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
        } else if btn.titleLabel?.text == "删除" {
            updateOrderStatus(id: order_id, type: "delete")
        } else if btn.titleLabel?.text == "查看物流" {

        } else if btn.titleLabel?.text == "评论" {
            let addeva = EvaluateManagerViewController()
            self.navigationController?.pushViewController(addeva, animated: true)
        }
    }

}
extension OederDetailViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return (data?.data.products.count ?? 0) + 1
        } else if section == 2 {
            return 3
        }
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return data == nil ? 0 : 3
    }

    @objc func toeva(btn: UIButton) {
        let tag = btn.tag - 9999 - 1
        let addeva = AddEvaluateViewController()
        let item = data?.data.products[tag]
        addeva.eva = EvaluateDatum(productID: item?.productID ?? "", orderID: order_id, name: item?.name ?? "", image: item?.image ?? "", price: item?.price ?? "", quantity: item?.quantity ?? "", optionUnionName: item?.optionUnionName ?? "", user_name: "", user_image: "", created: "", content: "", product_evaluate_id: "", star: "", evaluate_image:[])
        self.navigationController?.pushViewController(addeva, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderAddressTableViewCell") as! CreatOrderAddressTableViewCell
            cell.righy.isHidden = true
            cell.backgroundColor = .white
            if data?.data.shippingName.isEmpty ?? true {
                cell.name.text = "门店自提"
                cell.addressInfo.text = "请前往门店自行提取"
            } else {
            cell.addressInfo.text = (data?.data.shippingName ?? "") + "  " + (data?.data.shippingTelephone ?? "")
            cell.phone.text = data?.data.shippingAddress

                       cell.name.text = ""
                       cell.defaultBg.isHidden = true
                       cell.defaultText.isHidden = true
                       cell.nna.constant = 0
                       cell.bbba.constant = 20
            }
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailStatusTableViewCell") as! OrderDetailStatusTableViewCell
                cell.selectionStyle = .none
                cell.name.text = data?.data.statusName ?? ""
                return cell
            }
           let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderGoodsTableViewCell") as! CreatOrderGoodsTableViewCell
            let item = data?.data.products[indexPath.row - 1]
           cell.img.af_setImage(withURL: URL(string: item!.image)!)
           cell.name.text = item?.name ?? ""
           cell.price.text = "￥\(item?.price ?? "0")"
           cell.info.text = item?.optionUnionName ?? ""
           cell.num.text = "X\(item?.quantity ?? "0")"
            if (Int(data?.data.orderStatus ?? "0") ?? 0) == 4 {
                cell.evaluateBtn.isHidden = false
            } else {
                cell.evaluateBtn.isHidden = true
            }
           cell.selectionStyle = .none
            if indexPath.row == 0 {
//                cell.shadowsLeftRightTop()
            } else {
//                cell.shadowsLeftRight()
            }
            cell.evaluateBtn.tag = indexPath.row + 9999
            cell.evaluateBtn.addTarget(self, action: #selector(toeva(btn:)), for: .touchUpInside)
           return cell
        } else {
            if indexPath.row == 0 {

                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailIDTableViewCell") as! OrderDetailIDTableViewCell
                cell.selectionStyle = .none
                cell.num.text = data?.data.orderCode ?? ""
                cell.date.text = data?.data.created_time ?? ""
                return cell

            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailGoodsTableViewCell") as! OrderDetailGoodsTableViewCell
                    cell.selectionStyle = .none
                cell.goodPrice.text = getPayName(str: "\(data?.data.paymentPfn ?? "")")
                cell.discountPrice.text = "￥\(data?.data.price ?? "")"
                cell.youhuiPrice.text = "￥\(data?.data.shippingPrice ?? "")"
                cell.shipingPrice.text = "-￥\(data?.data.redPacket ?? "")"
                cell.price.text = "-￥\(data?.data.couponPrice ?? "")"
//                    cell.num.text = data?.data.orderCode ?? ""
//                    cell.date.text = data?.data.created_time ?? ""
                    return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailMonyTableViewCell") as! OrderDetailMonyTableViewCell
            cell.selectionStyle = .none
            cell.price.text = "￥\(data?.data.amountPrice ?? "")"
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0.1 }
        return 15
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.tableviewBackgroundColor
        return view
    }

    func getPayName(str: String) -> String {
        switch str {
        case "Amount":
            return "余额支付"
        case "weixin":
            return "微信支付"
        case "zhifubao":
            return "支付宝支付"
        default:
            return "未付款"
        }
    }
}
