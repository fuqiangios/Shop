//
//  AddAddressViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/12.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class AddAddressViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var addressInfo: AddressDatum? = AddressDatum(id: nil, customerID: nil, name: nil, telephone: nil, address: nil, detail: nil, isDefault: "0", modified: nil, created: nil)
    var edit = 0
    var saveAddressCallBack:((AddressSave)->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        if edit == 1 {
            title = "编辑地址"
        } else {
        title = "添加地址"
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(save))
        tableView.backgroundColor = UIColor.tableviewBackgroundColor
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "AddressAddInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressAddInfoTableViewCell")
        tableView.register(UINib(nibName: "AddressSaveTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressSaveTableViewCell")
        tableView.register(UINib(nibName: "AddressListTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressListTableViewCell")
        tableView.register(UINib(nibName: "AddressDefaultTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressDefaultTableViewCell")
    }

    @objc func save() {
        if let info = addressInfo {
            API.addressSave(info: info).request { (result) in
                switch result {
                case .success(let data):
                    self.navigationController?.popViewController(animated: true)
                    self.saveAddressCallBack?(data)
                case .failure:
                    print("fail")
                }
            }
        }
    }
}
extension AddAddressViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return 5
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if edit == 1 {
            return 2
        }
        return 1
    }



    @objc func isDefault() {
        addressInfo = addressInfo?.updateAddress(isDefault: addressInfo?.isDefault == "0" ? "1":"0")
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressAddInfoTableViewCell") as! AddressAddInfoTableViewCell
            cell.selectionStyle = .none
            cell.name.textColor = .red
                            cell.name.text = "删除地址"
                            cell.inputField.placeholder = ""
            cell.btn.isHidden = true
                            cell.btn.isHidden = false
                            cell.inputField.isEnabled = false
                            cell.inputField.text = ""
            return cell
        }
        if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddressDefaultTableViewCell") as! AddressDefaultTableViewCell
                cell.selectionStyle = .none
            cell.btn.addTarget(self, action: #selector(isDefault), for: .touchUpInside)
                if (addressInfo?.isDefault ?? "0") == "1" {
                    cell.btn.setImage(UIImage(named: "选中"), for: .normal)
                } else {
                    cell.btn.setImage(UIImage(named: "未选择"), for: .normal)
                }
                return cell
            }
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressAddInfoTableViewCell") as! AddressAddInfoTableViewCell
        cell.selectionStyle = .none
            cell.inputField.tag = indexPath.row
            cell.inputField.delegate = self
        cell.inputField.setValue(UIColor.black, forKeyPath: "placeholderLabel.textColor")
        cell.inputField.textColor = .black
            if indexPath.row == 0 {
                cell.name.text = "姓名"
                cell.inputField.placeholder = "请填写收货人姓名"
                cell.btn.setImage(UIImage(named: "ic_contacts_normal"), for: .normal)
                cell.btn.isHidden = true
                cell.inputField.isEnabled = true
                cell.inputField.text = addressInfo?.name ?? ""
            } else if indexPath.row == 1 {
                cell.name.text = "手机号"
                cell.inputField.placeholder = "请填写收货人手机号"
                cell.btn.isHidden = true
                cell.inputField.isEnabled = true
                cell.inputField.text = addressInfo?.telephone ?? ""
            } else if indexPath.row == 2 {
                cell.name.text = "选择省/市/区"
                cell.inputField.placeholder = ""
//                cell.btn.setImage(UIImage(named: "ic_location_normal"), for: .normal)
                cell.btn.isHidden = false
                cell.inputField.isEnabled = false
                cell.inputField.text = addressInfo?.address ?? ""
            } else if indexPath.row == 3 {
                cell.name.text = ""
                cell.he.constant = 0
                cell.inputField.placeholder = "详细地址"
                cell.btn.isHidden = true
                cell.inputField.isEnabled = true
                cell.inputField.text = addressInfo?.detail ?? ""
            }
        cell.inputField.setValue(UIColor.black, forKeyPath: "placeholderLabel.textColor")
        cell.inputField.textColor = .black
        return cell
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            addressInfo = addressInfo?.updateAddress(name: textField.text)
        } else if textField.tag == 1 {
            addressInfo = addressInfo?.updateAddress(telephone: textField.text)
        } else if textField.tag == 2 {
            addressInfo = addressInfo?.updateAddress(address: textField.text)
        } else if textField.tag == 3 {
            addressInfo = addressInfo?.updateAddress(detail: textField.text)
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vi = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 10))
        vi.backgroundColor = .clear
        return vi
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            API.addressDelete(id: addressInfo?.id ?? "").request { (result) in
                switch result {
                case .success:
                    self.navigationController?.popViewController(animated: true)
                case .failure:
                    CLProgressHUD.showError(in: self.view, delegate: self, title: "删除地址失败", duration: 1)
                }
            }
        }
        if indexPath.row == 2 {
            let addressPicker = EWAddressViewController()
            addressPicker.backLocationStringController = { (address,province,city,area) in
                self.addressInfo = self.addressInfo?.updateAddress(address: address)
                tableView.reloadData()
            }
            self.present(addressPicker, animated: true, completion: nil)
        }
    }
}
