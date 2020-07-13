//
//  AddBackGoodsViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/3/12.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class AddBackGoodsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var order_id: String = ""
    var data: AftersaleShow? = nil
    var typeTag = 3
    var num = 1
    var resonIndex = ""
    var resonName = ""
    var coment: AddEvaluateComenntTableViewCell? = nil
    var addressInfo:AddressDatum? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        loadData()
    }

    func loadData()  {
        API.aftersaleInfo(order_product_id: order_id).request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.tableView.reloadData()
            case .failure:
                print("error")
            }
        }
    }

    func setUp() {
        title = "退换货"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        tableView.register(UINib(nibName: "CreatOrderGoodsTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatOrderGoodsTableViewCell")
        tableView.register(UINib(nibName: "AddBackGoodsPriceTableViewCell", bundle: nil), forCellReuseIdentifier: "AddBackGoodsPriceTableViewCell")
        tableView.register(UINib(nibName: "AddEvaluateComenntTableViewCell", bundle: nil), forCellReuseIdentifier: "AddEvaluateComenntTableViewCell")
        tableView.register(UINib(nibName: "AddBackGoodsTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "AddBackGoodsTypeTableViewCell")
        tableView.register(UINib(nibName: "AddBackGoodsNumTableViewCell", bundle: nil), forCellReuseIdentifier: "AddBackGoodsNumTableViewCell")
        tableView.register(UINib(nibName: "AddBackGoodsSelectTableViewCell", bundle: nil), forCellReuseIdentifier: "AddBackGoodsSelectTableViewCell")
        tableView.register(UINib(nibName: "AddBackGoodsSubmitTableViewCell", bundle: nil), forCellReuseIdentifier: "AddBackGoodsSubmitTableViewCell")
        tableView.register(UINib(nibName: "BaclAddGoodsTableViewCell", bundle: nil), forCellReuseIdentifier: "BaclAddGoodsTableViewCell")
        tableView.register(UINib(nibName: "BaclAddAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "BaclAddAddressTableViewCell")

        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.tableviewBackgroundColor
    }

    @objc func tuiAction() {
        typeTag = 1
        tableView.reloadData()
    }

    @objc func huanAction() {
        typeTag = 2
        tableView.reloadData()
    }

    func subtmit() {
//        if resonIndex < 0 {return}
        print(addressInfo)
        API.aftersaleSubmit(order_product_id: order_id, aftersale_type_id: "\(typeTag)", aftersale_reason_id: resonIndex, quantity: "\(num)", description: coment?.getComent() ?? "", images: coment?.getImgs() ?? [], address_id: addressInfo?.id ?? "").request { (result) in
            switch result {
            case .success(let datqa):
                print(datqa)
                if datqa.status == 200 {
                self.navigationController?.popViewController(animated: true)
                } else {
                    CLProgressHUD.showError(in: self.view, delegate: self, title: "请完善信息", duration: 1)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
extension AddBackGoodsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 2 {
            return 2
        }
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return data == nil ? 0 : 5
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vi = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 0))
        vi.backgroundColor = UIColor.tableviewBackgroundColor
        return vi
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BaclAddGoodsTableViewCell") as! BaclAddGoodsTableViewCell
                cell.selectionStyle = .none
                let item = data?.data.orderProduct
                cell.img.af_setImage(withURL: URL(string: item!.image)!)
                cell.name.text = item?.name ?? ""
                cell.price.text = "￥\(item?.price ?? "0")"
//                cell.info.text = item?.optionUnionName ?? ""
                cell.num.text = "\(item?.quantity ?? "0")"
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddBackGoodsNumTableViewCell") as! AddBackGoodsNumTableViewCell
                cell.addBtn.addTarget(self, action: #selector(addNum(btn:)), for: .touchUpInside)
                cell.reduceBtn.addTarget(self, action: #selector(jianNum(btn:)), for: .touchUpInside)
                cell.textField.text = "\(num)"
                cell.selectionStyle = .none
                return cell
            }
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddBackGoodsTypeTableViewCell") as! AddBackGoodsTypeTableViewCell
            if typeTag == 1 {
                cell.name.text = "退货"
            } else if typeTag == 2 {
                cell.name.text = "换货"
            }
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 12 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddBackGoodsNumTableViewCell") as! AddBackGoodsNumTableViewCell
            cell.addBtn.addTarget(self, action: #selector(addNum(btn:)), for: .touchUpInside)
            cell.reduceBtn.addTarget(self, action: #selector(jianNum(btn:)), for: .touchUpInside)
            cell.textField.text = "\(num)"
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 22 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddBackGoodsSelectTableViewCell") as! AddBackGoodsSelectTableViewCell
//            if resonIndex >= 0 {
//                cell.info.text = data?.data.reason?[resonIndex].name ?? ""
//            }
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddBackGoodsSelectTableViewCell") as! AddBackGoodsSelectTableViewCell
                    cell.info.text = resonName
                cell.selectionStyle = .none
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddEvaluateComenntTableViewCell") as! AddEvaluateComenntTableViewCell
            cell.selectionStyle = .none
//            cell.setUp(text: "请您详细描述您的退换货原因")
            coment = cell

            return cell
        }else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BaclAddAddressTableViewCell") as! BaclAddAddressTableViewCell
            cell.selectionStyle = .none
            cell.info.text = (addressInfo?.address ?? "") + (addressInfo?.detail ?? "")
            cell.name.text = (addressInfo?.name ?? "") + " " + (addressInfo?.telephone ?? "")
            return cell
        }

        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddBackGoodsSubmitTableViewCell") as! AddBackGoodsSubmitTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            let address = AddressListViewController()
                    address.didSelectAddress = { info in
                        self.addressInfo = info
                        tableView.reloadData()
                    }
                    self.navigationController?.pushViewController(address, animated: true)
        }
        if indexPath.section == 2, indexPath.row == 0 {

            let alertController = UIAlertController(title: "申请原因", message: "", preferredStyle: UIAlertController.Style.actionSheet)

            for item in data?.data.reason ?? [] {
                alertController.addAction(UIAlertAction(title: item.name, style: UIAlertAction.Style.default, handler:{ (l) in
                    self.resonIndex = item.id
                    self.resonName = item.name
                    self.tableView.reloadData()
                    }))
            }
            alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))

            self.present(alertController, animated: true, completion: nil)
        } else if indexPath.section == 4 {
            subtmit()
        } else if indexPath.section == 1 {
            let alertController = UIAlertController(title: "申请类型", message: "", preferredStyle: UIAlertController.Style.actionSheet)

            alertController.addAction(UIAlertAction(title: "退货", style: UIAlertAction.Style.default, handler:{ (l) in
                self.typeTag = 1
                self.tableView.reloadData()
                }))
            alertController.addAction(UIAlertAction(title: "换货", style: UIAlertAction.Style.default, handler: { (l) in
                self.typeTag = 2
                self.tableView.reloadData()
            }))

            alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))

            self.present(alertController, animated: true, completion: nil)
        }
    }

    @objc func addNum(btn: UIButton) {
        num = num + 1
        tableView.reloadData()
    }

    @objc func jianNum(btn: UIButton) {
        if num <= 1 { return }
        num = num - 1
        tableView.reloadData()
    }
}
