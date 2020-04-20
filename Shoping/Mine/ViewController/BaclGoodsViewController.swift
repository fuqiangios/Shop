//
//  EvaluateManagerViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/3/9.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class BaclGoodsViewController: UIViewController {

    @IBOutlet weak var line: UILabel!
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
        title = "退换/售后"
//        backGoods.setTitleColor(backGoods.tintColor, for: .normal)
//        finsh.setTitleColor(.black, for: .normal)
        eva(backGoods!)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
        tableView.register(UINib(nibName: "CreatOrderGoodsTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatOrderGoodsTableViewCell")
        tableView.register(UINib(nibName: "BaclGoodsShenTableViewCell", bundle: nil), forCellReuseIdentifier: "BaclGoodsShenTableViewCell")
        tableView.register(UINib(nibName: "BaclFinshTableViewCell", bundle: nil), forCellReuseIdentifier: "BaclFinshTableViewCell")
        tableView.register(UINib(nibName: "OrderFInshTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderFInshTableViewCell")
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.tableviewBackgroundColor
//        setShadow(view: backView, sColor: UIColor.init(white: 0.8, alpha: 1), offset: CGSize(width: 0, height: 0), opacity: 1, radius: 5)
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
//        backGoods.setTitleColor(backGoods.tintColor, for: .normal)
        backGoods.titleLabel?.font = UIFont.init(name: "Bold", size: 18)
//        finsh.setTitleColor(.black, for: .normal)
        finsh.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        line.center = CGPoint(x: backGoods.center.x, y: backGoods.center.y + 15)
        loadAftersale()
    }

    @IBAction func finsh(_ sender: Any) {
        type = "2"
                finsh.titleLabel?.font = UIFont.init(name: "Bold", size: 18)
        //        finsh.setTitleColor(.black, for: .normal)
                backGoods.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        line.center = CGPoint(x: finsh.center.x, y: finsh.center.y + 15)
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
        return data?.data.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if type == "2" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BaclFinshTableViewCell") as! BaclFinshTableViewCell
            let item = data?.data[indexPath.row]
            cell.img.af_setImage(withURL: URL(string: item!.image)!)
            cell.name.text = item?.name ?? ""
//            cell.price.text = "￥\(item?.price ?? "0")"
            cell.info.text = "申请数量：1"
            cell.orderId.text = "服务单号：\(item?.orderCode ?? "")"
            cell.type.text = "维修"

            cell.status.text = item?.statusName ?? ""
//            cell.num.text = "X\(item?.quantity ?? "0")"
            cell.selectionStyle = .none
//            cell.bottomc.constant = 6
//            cell.shadowsLeftRight()
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "BaclGoodsShenTableViewCell") as! BaclGoodsShenTableViewCell
        let item = data?.data[indexPath.row]
        cell.img.af_setImage(withURL: URL(string: item!.image)!)
        cell.name.text = item?.name ?? ""
        cell.price.text = "￥\(item?.price ?? "0")"
        cell.option.text = item?.optionUnionName ?? ""
        cell.bbtn.tag = indexPath.row + 100
        cell.bbtn.addTarget(self, action: #selector(toAddEva(btn:)), for: .touchUpInside)
//        cell.num.text = "X\(item?.quantity ?? "0")"
        cell.selectionStyle = .none
//        cell.shadow()
//        cell.setBtn(flag: "2")
//        cell.btn.tag = indexPath.row + 100
//        cell.btn.addTarget(self, action: #selector(toAddEva(btn:)), for: .touchUpInside)
        return cell
        
    }

    @objc func toAddEva(btn: UIButton) {
        let add = AddBackGoodsViewController()
        add.order_id = data?.data[btn.tag-100].orderProductID ?? ""
        self.navigationController?.pushViewController(add, animated: true)
    }

}
