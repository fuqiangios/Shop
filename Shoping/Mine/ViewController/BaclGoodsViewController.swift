//
//  EvaluateManagerViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/3/9.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class BaclGoodsViewController: UIViewController {

    @IBOutlet weak var backView: UIView!

    @IBOutlet weak var backGoods: UIButton!
    @IBOutlet weak var finsh: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var data: Aftersale? = nil
    var type: String = "1"

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        loadAftersale()
    }

    func setUp() {
        title = "申请退换货"
        backGoods.setTitleColor(backGoods.tintColor, for: .normal)
        finsh.setTitleColor(.black, for: .normal)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
        tableView.register(UINib(nibName: "CreatOrderGoodsTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatOrderGoodsTableViewCell")
        tableView.register(UINib(nibName: "OrderFInshTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderFInshTableViewCell")
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        setShadow(view: backView, sColor: UIColor.init(white: 0.8, alpha: 1), offset: CGSize(width: 0, height: 0), opacity: 1, radius: 5)
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
    @IBAction func eva(_ sender: Any) {
        type = "1"
        backGoods.setTitleColor(backGoods.tintColor, for: .normal)
        finsh.setTitleColor(.black, for: .normal)
        loadAftersale()
    }

    @IBAction func finsh(_ sender: Any) {
        type = "2"
        finsh.setTitleColor(backGoods.tintColor, for: .normal)
        backGoods.setTitleColor(.black, for: .normal)
        loadAftersale()
    }
    func loadAftersale() {
        API.aftersaleList(tab_status: type).request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    @objc func deleteEvaluate(btn: UIButton) {
    }

}
extension BaclGoodsViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return data?.data.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if type == "2" {
            if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell") as! OrderTableViewCell
                cell.name.text = data?.data[indexPath.section].statusName ?? ""
            return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderGoodsTableViewCell") as! CreatOrderGoodsTableViewCell
            let item = data?.data[indexPath.section]
            cell.img.af_setImage(withURL: URL(string: item!.image)!)
            cell.name.text = item?.name ?? ""
            cell.price.text = "￥\(item?.price ?? "0")"
            cell.info.text = item?.optionUnionName ?? ""
            cell.num.text = "X\(item?.quantity ?? "0")"
            cell.selectionStyle = .none
            cell.bottomc.constant = 6
            cell.shadowsLeftRight()
            return cell
        }
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell") as! OrderTableViewCell
            cell.name.text = "已完成"
            return cell
        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderFInshTableViewCell") as! OrderFInshTableViewCell
        let item = data?.data[indexPath.section]
        cell.img.af_setImage(withURL: URL(string: item!.image)!)
        cell.name.text = item?.name ?? ""
        cell.price.text = "￥\(item?.price ?? "0")"
        cell.option.text = item?.optionUnionName ?? ""
        cell.num.text = "X\(item?.quantity ?? "0")"
        cell.selectionStyle = .none
        cell.shadow()
        cell.setBtn(flag: "2")
        cell.btn.tag = indexPath.row + 100
        cell.btn.addTarget(self, action: #selector(toAddEva(btn:)), for: .touchUpInside)
        return cell
        }
    }

    @objc func toAddEva(btn: UIButton) {
        let add = AddBackGoodsViewController()
        add.order_id = data?.data[btn.tag-100].orderProductID ?? ""
        self.navigationController?.pushViewController(add, animated: true)
    }

}
