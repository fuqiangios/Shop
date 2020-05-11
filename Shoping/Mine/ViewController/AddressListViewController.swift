//
//  AddressListViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/1/31.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class AddressListViewController: UIViewController {

    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var data: Address? = nil
    var addressInfo: AddressDatum? = AddressDatum(id: nil, customerID: nil, name: nil, telephone: nil, address: nil, detail: nil, isDefault: "1", modified: nil, created: nil)
    var up = "1"

    var didSelectAddress: ((AddressDatum?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "地址管理"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        setUp()
        loadData()
        btn.addTarget(self, action: #selector(addAddress), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }

    @objc func addAddress() {
        let add = AddAddressViewController()
        self.navigationController?.pushViewController(add, animated: true)
    }

    func setUp() {
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        tableView.backgroundColor = UIColor.tableviewBackgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "AddressAddInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressAddInfoTableViewCell")
        tableView.register(UINib(nibName: "AddressSaveTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressSaveTableViewCell")
        tableView.register(UINib(nibName: "AddressListTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressListTableViewCell")
        tableView.register(UINib(nibName: "AddressDefaultTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressDefaultTableViewCell")
    }

    func loadData() {
        API.addressList().request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
                print(error.self)
                print(error.localizedDescription)
            }
        }
    }

    func saveAddress() {
        if let info = addressInfo {
            API.addressSave(info: info).request { (result) in
                switch result {
                case .success:
                    self.loadData()
                case .failure:
                    print("fail")
                }
            }
        }
    }
}
extension AddressListViewController: UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if up == "10" {return}
        if indexPath.section == 10, indexPath.row == 2 {
            let addressPicker = EWAddressViewController()
            addressPicker.backLocationStringController = { (address,province,city,area) in
                self.addressInfo = self.addressInfo?.updateAddress(address: address)
                tableView.reloadData()
            }
            self.present(addressPicker, animated: true, completion: nil)
        } else if indexPath.section == 10, indexPath.row == 5 {
            saveAddress()
        } else if indexPath.section == 0 {
            didSelectAddress?(data?.data[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 10 {
            return 6
        }
        return data?.data.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 10 {
        if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressSaveTableViewCell") as! AddressSaveTableViewCell
            cell.selectionStyle = .none
            return cell
        }
            if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddressDefaultTableViewCell") as! AddressDefaultTableViewCell
                cell.selectionStyle = .none
                return cell
            }
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressAddInfoTableViewCell") as! AddressAddInfoTableViewCell
        cell.selectionStyle = .none
            cell.inputField.tag = indexPath.row
            cell.inputField.delegate = self
            if indexPath.row == 0 {
                cell.name.text = "收货人"
                cell.inputField.placeholder = "请填写收货人姓名"
                cell.btn.setImage(UIImage(named: "ic_contacts_normal"), for: .normal)
                cell.btn.isHidden = false
                cell.inputField.isEnabled = true
                cell.inputField.text = addressInfo?.name ?? ""
            } else if indexPath.row == 1 {
                cell.name.text = "手机号码"
                cell.inputField.placeholder = "请填写收货人手机号码"
                cell.btn.isHidden = true
                cell.inputField.isEnabled = true
                cell.inputField.text = addressInfo?.telephone ?? ""
            } else if indexPath.row == 2 {
                cell.name.text = "所在地区"
                cell.inputField.placeholder = ""
                cell.btn.setImage(UIImage(named: "ic_location_normal"), for: .normal)
                cell.btn.isHidden = false
                cell.inputField.isEnabled = false
                cell.inputField.text = addressInfo?.address ?? ""
            } else if indexPath.row == 3 {
                cell.name.text = "详细地址"
                cell.inputField.placeholder = "详细地址,如街道、楼牌号"
                cell.btn.isHidden = true
                cell.inputField.isEnabled = true
                cell.inputField.text = addressInfo?.detail ?? ""
            }
        return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressListTableViewCell") as! AddressListTableViewCell
            cell.selectionStyle = .none
            cell.edit.tag = indexPath.row + 1000
//            cell.delete.tag = indexPath.row + 100000
            cell.edit.addTarget(self, action: #selector(editAddress(btn:)), for: .touchUpInside)
//            cell.delete.addTarget(self, action: #selector(deleteAddress(btn:)), for: .touchUpInside)
            let addressInfo = data?.data[indexPath.row]
            cell.name.text = (addressInfo?.name ?? "") + "  " + (addressInfo?.telephone ?? "")
            cell.address.text = (addressInfo?.address ?? "") + (addressInfo?.detail ?? "")
            if addressInfo?.isDefault == "1" {
                cell.isDefault.isHidden = false
            } else {
                cell.isDefault.isHidden = true
            }
            return cell
        }
    }

    @objc func editAddress(btn:UIButton) {
        let add = AddAddressViewController()
        add.addressInfo = data?.data[btn.tag - 1000]
        add.edit = 1
        self.navigationController?.pushViewController(add, animated: true)
//        addressInfo = data?.data[btn.tag - 1000]
//        tableView.reloadData()
    }

    @objc func deleteAddress(btn:UIButton) {
        let alertController = UIAlertController(title: "温馨提示", message: "是否删除收货地址", preferredStyle: UIAlertController.Style.alert)

        alertController.addAction(UIAlertAction(title: "确认", style: UIAlertAction.Style.default, handler: { (aler) in
            let id = self.data?.data[btn.tag - 100000].id ?? ""
            API.addressDelete(id: id).request { (result) in
                switch result {
                case .success:
                    self.loadData()
                case .failure:
                    print("fail")
                }
            }
        }))
            alertController.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))

        self.present(alertController, animated: true, completion: nil)


    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//        header.backgroundColor = .groupTableViewBackground
//        return header
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }

    @objc func switchChange(switcah: UISwitch) {
        addressInfo = addressInfo?.updateAddress(isDefault: switcah.isOn ? "1":"0")
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

}
