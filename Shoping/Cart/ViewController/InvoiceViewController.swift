//
//  InvoiceViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/10.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class InvoiceViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var type = "1"
    var name = ""
    var shui = ""
    var phone = ""
    var email = ""
    var info: InvoiceInfo? = nil
    var price = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "添加发票信息"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(save))
        setUp()
        loadData()
    }

    func loadData() {
        API.invoiceInfo().request { (result) in
            switch result {
            case .success(let data):
                self.info = data
                self.name = data.data.company.name
                self.shui = data.data.company.taxNum
                self.phone = data.data.company.telephone
                self.email = data.data.company.email
                self.tableView.reloadData()
            case .failure(let er):
                print(er)
            }
        }
    }

    @objc func save() {
        API.addInvoice(type: type, name: name, telephone: phone, email: email, tax_num: type == "1" ? shui : "").request { (result) in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let er):
                print(er)
            }
        }
    }
    func setUp() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.backgroundColor = UIColor.tableviewBackgroundColor
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "InvoiceInputTableViewCell", bundle: nil), forCellReuseIdentifier: "InvoiceInputTableViewCell")
        tableView.register(UINib(nibName: "InoviceInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "InoviceInfoTableViewCell")
        tableView.register(UINib(nibName: "InvoiceTipsTableViewCell", bundle: nil), forCellReuseIdentifier: "InvoiceTipsTableViewCell")
        tableView.register(UINib(nibName: "InvoiceTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "InvoiceTypeTableViewCell")
    }
}
extension InvoiceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            if type == "1" {
                return 5
            } else {
                return 4
            }
        } else if section == 3 {
            return 1
        }
        return 2
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vi = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 20))
        vi.backgroundColor = UIColor.tableviewBackgroundColor
        return vi
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3 {
            return 0
        }
        return 20
    }

    @objc func qiAction() {
        type = "1"
        self.name = info?.data.company.name ?? ""
        self.phone = info?.data.company.telephone ?? ""
        self.email = info?.data.company.email ?? ""
        self.shui = info?.data.company.taxNum ?? ""
        tableView.reloadData()
    }

    @objc func geAction() {
        type = "2"
        self.name = info?.data.person.name ?? ""
        self.phone = info?.data.person.telephone ?? ""
        self.email = info?.data.person.email ?? ""
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceInputTableViewCell") as! InvoiceInputTableViewCell
                  cell.selectionStyle = .none
                cell.nname.text = "发票类型"
                cell.input.text = "电子普通发票"
                cell.input.isEnabled = false
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InoviceInfoTableViewCell") as! InoviceInfoTableViewCell
                cell.selectionStyle = .none
                return cell
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceTypeTableViewCell") as! InvoiceTypeTableViewCell
                  cell.selectionStyle = .none
                if type == "1" {
                    cell.qi.setImage(UIImage(named: "选中"), for: .normal)
                    cell.ge.setImage(UIImage(named: "未选择"), for: .normal)
                } else {
                    cell.ge.setImage(UIImage(named: "选中"), for: .normal)
                    cell.qi.setImage(UIImage(named: "未选择"), for: .normal)
                }
                cell.qi.addTarget(self, action: #selector(qiAction), for: .touchUpInside)
                cell.ge.addTarget(self, action: #selector(geAction), for: .touchUpInside)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceInputTableViewCell") as! InvoiceInputTableViewCell
              cell.selectionStyle = .none
            if type == "1" {
            if indexPath.row == 1 {
                cell.nname.text = "公司名称"
                cell.input.placeholder = "请输入公司名称"
                cell.input.isEnabled = true
                cell.input.text = name
                cell.input.tag = 100
            } else if indexPath.row == 2 {
                cell.nname.text = "公司税号"
                cell.input.placeholder = "请输入公司税号"
                cell.input.isEnabled = true
                cell.input.text = shui
                cell.input.tag = 101
            } else if indexPath.row == 3 {
                cell.nname.text = "发票内容"
                cell.input.text = "明细"
                cell.input.isEnabled = false
            } else if indexPath.row == 4 {
                cell.nname.text = "发票金额"
                cell.input.text = "￥\(price)"
                cell.input.isEnabled = false
            }
            } else {
                if indexPath.row == 1 {
                    cell.nname.text = "个人或姓名"
                    cell.input.placeholder = "请输入个人或姓名"
                    cell.input.isEnabled = true
                    cell.input.text = name
                    cell.input.tag = 100
                } else if indexPath.row == 2 {
                    cell.nname.text = "发票内容"
                    cell.input.text = "明细"
                    cell.input.isEnabled = false
                } else if indexPath.row == 3 {
                    cell.nname.text = "发票金额"
                    cell.input.text = "￥\(price)"
                    cell.input.isEnabled = false
                }
            }
            cell.input.delegate = self
              return cell
        } else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceInputTableViewCell") as! InvoiceInputTableViewCell
              cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.nname.text = "收票人手机"
                cell.input.placeholder = "请输入收票人手机"
                cell.input.isEnabled = true
                cell.input.text = phone
                cell.input.tag = 102
            } else {
                cell.nname.text = "收票人邮箱"
                cell.input.placeholder = "请输入收票人邮箱"
                cell.input.isEnabled = true
                cell.input.text = email
                cell.input.tag = 103
            }
            cell.input.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceTipsTableViewCell") as! InvoiceTipsTableViewCell
              cell.selectionStyle = .none
            return cell
        }
    }
}
extension InvoiceViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.tag == 100 {
            name = textField.text ?? ""
        } else if textField.tag == 101 {
            shui = textField.text ?? ""
        } else if textField.tag == 102 {
            phone = textField.text ?? ""
        } else if textField.tag == 103 {
            email = textField.text ?? ""
        }
    }
}
