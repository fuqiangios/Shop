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
    var resonIndex = -1
    var coment: AddEvaluateComenntTableViewCell? = nil

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

        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
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
        if resonIndex < 0 {return}
        API.aftersaleSubmit(order_product_id: order_id, aftersale_type_id: "\(typeTag)", aftersale_reason_id: data?.data.reason?[resonIndex].id ?? "", quantity: "\(num)", description: coment?.getComent() ?? "", images: coment?.getImgs() ?? []).request { (result) in
            switch result {
            case .success:
                print("success")
                self.navigationController?.popViewController(animated: true)
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
        }
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return data == nil ? 0 : 6
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vi = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 0))
        vi.backgroundColor = .groupTableViewBackground
        return vi
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderGoodsTableViewCell") as! CreatOrderGoodsTableViewCell
                cell.selectionStyle = .none
                let item = data?.data.orderProduct
                cell.img.af_setImage(withURL: URL(string: item!.image)!)
                cell.name.text = item?.name ?? ""
                cell.price.text = "￥\(item?.price ?? "0")"
                cell.info.text = item?.optionUnionName ?? ""
                cell.num.text = "X\(item?.quantity ?? "0")"
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddBackGoodsPriceTableViewCell") as! AddBackGoodsPriceTableViewCell
                cell.price.text = "￥\(data?.data.orderProduct?.total ?? "0")"
                cell.selectionStyle = .none
                return cell
            }
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddBackGoodsTypeTableViewCell") as! AddBackGoodsTypeTableViewCell
            cell.setSelect(tag: typeTag)
            cell.tui.addTarget(self, action: #selector(tuiAction), for: .touchUpInside)
            cell.huan.addTarget(self, action: #selector(huanAction), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddBackGoodsNumTableViewCell") as! AddBackGoodsNumTableViewCell
            cell.addBtn.addTarget(self, action: #selector(addNum(btn:)), for: .touchUpInside)
            cell.reduceBtn.addTarget(self, action: #selector(jianNum(btn:)), for: .touchUpInside)
            cell.textField.text = "\(num)"
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddBackGoodsSelectTableViewCell") as! AddBackGoodsSelectTableViewCell
            if resonIndex >= 0 {
                cell.info.text = data?.data.reason?[resonIndex].name ?? ""
            }
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddEvaluateComenntTableViewCell") as! AddEvaluateComenntTableViewCell
            cell.selectionStyle = .none
            cell.setUp(text: "请您详细描述您的退换货原因")
            coment = cell

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddBackGoodsSubmitTableViewCell") as! AddBackGoodsSubmitTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            let selectDiscount = CreatOrderSelectDiscountViewController()
            selectDiscount.reson = data?.data.reason
            selectDiscount.didSelectDiscount = { index in
                self.resonIndex = index
                self.tableView.reloadData()
            }
            self.present(selectDiscount, animated: true, completion: nil)
        } else if indexPath.section == 5 {
            subtmit()
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
