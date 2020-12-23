//
//  BaclGoodsDetailViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/27.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class BaclGoodsDetailViewController: UIViewController {

    @IBOutlet weak var typeLabel: UILabel!

    @IBOutlet weak var hi: NSLayoutConstraint!
    @IBOutlet weak var tianxie: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var id = ""
    var data: AfterDetail? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.register(UINib(nibName: "BaclGoodsDetailGoodsTableViewCell", bundle: nil), forCellReuseIdentifier: "BaclGoodsDetailGoodsTableViewCell")
        tableView.register(UINib(nibName: "BaclGoodsDetailinfoTableViewCell", bundle: nil), forCellReuseIdentifier: "BaclGoodsDetailinfoTableViewCell")
        tableView.register(UINib(nibName: "BaclGoodsDetailDateTableViewCell", bundle: nil), forCellReuseIdentifier: "BaclGoodsDetailDateTableViewCell")
        tableView.register(UINib(nibName: "BaclFinshTableViewCell", bundle: nil), forCellReuseIdentifier: "BaclFinshTableViewCell")
        tableView.register(UINib(nibName: "OrderFInshTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderFInshTableViewCell")
        tableView.register(UINib(nibName: "BaclGoodsDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "BaclGoodsDetailTableViewCell")
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.tableviewBackgroundColor
        tianxie.layer.borderWidth = 1
        tianxie.layer.borderColor = UIColor.white.cgColor
        tianxie.layer.masksToBounds = true
        tianxie.layer.cornerRadius = 5
        tianxie.addTarget(self, action: #selector(setInput), for: .touchUpInside)
        loadData()
    }

    @objc func setInput() {
        let pop = ShipingInputViewController()
        pop.modalPresentationStyle = .custom
        pop.backOnClickSubmit = { (name,number) in
            API.setShping(order_aftersale_id: self.data?.data.afterSale.id ?? "",
                          shipping_company: name, shipping_no: number).request { (result) in
                print(result)
                self.loadData()
            }
        }
        self.present(pop, animated: true, completion: nil)
    }

    func loadData() {
        API.getAftersaleDetail(aftersale_id: id).request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.typeLabel.text = data.data.afterSale.statusName
                if data.data.afterSale.aftersaleStatus == "2" {
                    self.tianxie.isHidden = false
                    self.hi.constant = 30
                } else {
                    self.tianxie.isHidden = true
                    self.hi.constant = 0
                }
                self.tableView.reloadData()
            case .failure(let er):
                print(er)
            }
        }
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension BaclGoodsDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if (data?.data.afterSale.aftersaleStatus ?? "") == "2" ||
                (data?.data.afterSale.aftersaleStatus ?? "") == "4" {
                return 3
            }
            return 2
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return data == nil ? 0 : 2
    }



    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 15
        }
        return 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let bg = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 15))
        bg.backgroundColor = .white
        return bg
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bg = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 15))
        bg.backgroundColor = .white
        return bg
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
         let cell = tableView.dequeueReusableCell(withIdentifier: "BaclGoodsDetailGoodsTableViewCell") as! BaclGoodsDetailGoodsTableViewCell
        cell.selectionStyle = .none
            cell.img.af_setImage(withURL: URL(string: (data?.data.orderProduct.image)!)!)
            cell.name.text = data?.data.orderProduct.name ?? ""
            cell.price.text = "￥\(data?.data.orderProduct.price ?? "")"
            cell.num.text = data?.data.orderProduct.quantity

        return cell
        } else {
            if indexPath.row == 0 {
                 let cell = tableView.dequeueReusableCell(withIdentifier: "BaclGoodsDetailinfoTableViewCell") as! BaclGoodsDetailinfoTableViewCell
                cell.selectionStyle = .none
                cell.order.text = data?.data.orderProduct.orderID
                cell.date.text = data?.data.afterSale.created
                cell.type.text = data?.data.afterSale.aftersaleTypeName
                cell.info.text = data?.data.afterSale.aftersaleReasonName
                return cell
            } else if indexPath.row == 1 {
                 let cell = tableView.dequeueReusableCell(withIdentifier: "BaclGoodsDetailDateTableViewCell") as! BaclGoodsDetailDateTableViewCell
                cell.address.text = (data?.data.address.address.count ?? 0) > 1 ? data?.data.address.address : " "
                cell.name.text = data?.data.address.userName
                cell.phone.text = data?.data.address.telephone
                cell.selectionStyle = .none

                return cell
            } else {
                 let cell = tableView.dequeueReusableCell(withIdentifier: "BaclGoodsDetailTableViewCell") as! BaclGoodsDetailTableViewCell
                cell.selectionStyle = .none
                cell.name.text = data?.data.afterSale.shippingCompany
                cell.no.text = data?.data.afterSale.shippingNo

                    cell.name.isEnabled = false
                    cell.no.isEnabled = false

                cell.name.delegate = self
                cell.no.delegate = self
                cell.name.tag = 19
                cell.no.tag = 20
                return cell
            }
        }
    }
}
extension BaclGoodsDetailViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 20 {
            API.setShping(order_aftersale_id: data?.data.afterSale.id ?? "", shipping_company: data?.data.afterSale.shippingCompany ?? "", shipping_no: textField.text ?? "").request { (result) in
                print(result)
                self.loadData()
            }
        } else {
            API.setShping(order_aftersale_id: data?.data.afterSale.id ?? "", shipping_company: textField.text ?? "", shipping_no: data?.data.afterSale.shippingNo ?? "").request { (result) in
                print(result)
                self.loadData()
            }
        }
    }
}
