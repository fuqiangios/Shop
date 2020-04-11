//
//  MineViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2019/12/25.
//  Copyright © 2019 付强. All rights reserved.
//

import UIKit

class MineViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

//    var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.tintColor = .black
        setUp()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func setUp() {
        tableView.register(UINib(nibName: "MineHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "MineHeaderTableViewCell")
        tableView.register(UINib(nibName: "MineOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "MineOrderTableViewCell")
        tableView.register(UINib(nibName: "MineImgTableViewCell", bundle: nil), forCellReuseIdentifier: "MineImgTableViewCell")
        tableView.register(UINib(nibName: "MinToolTableViewCell", bundle: nil), forCellReuseIdentifier: "MinToolTableViewCell")
        tableView.register(UINib(nibName: "MineRedTableViewCell", bundle: nil), forCellReuseIdentifier: "MineRedTableViewCell")
        tableView.delegate = self
        tableView.backgroundColor = UIColor.tableviewBackgroundColor
        tableView.dataSource = self
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
        tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never;
        }
        else
        {
        self.automaticallyAdjustsScrollViewInsets = false;
        }
        view.addSubview(tableView)
    }

    @objc func myprice(btn: UIButton) {
        if btn.tag == 666 {
            let inte = IntegralViewController()
            inte.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(inte, animated: true)
        } else if btn.tag == 667 {
            let red = RedPackgeViewController()
            red.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(red, animated: true)
        } else if btn.tag == 668 {
            let amount = BalanceViewController()
            amount.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(amount, animated: true)
        } else if btn.tag == 669 {
            let discount = DiscountViewController()
            discount.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(discount, animated: true)
        }
    }

}

extension MineViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MineHeaderTableViewCell") as! MineHeaderTableViewCell
//            cell.pointBtn.addTarget(self, action: #selector(myprice(btn:)), for: .touchUpInside)
//            cell.redPackgBtn.addTarget(self, action: #selector(myprice(btn:)), for: .touchUpInside)
//            cell.priceBtn.addTarget(self, action: #selector(myprice(btn:)), for: .touchUpInside)
//            cell.discountBtn.addTarget(self, action: #selector(myprice(btn:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MineOrderTableViewCell") as! MineOrderTableViewCell
            cell.payBtn.tag = 1
            cell.payBtn.addTarget(self, action: #selector(runOrderVc(btn:)), for: .touchUpInside)
            cell.deliverBtn.tag = 2
            cell.deliverBtn.addTarget(self, action: #selector(runOrderVc(btn:)), for: .touchUpInside)
            cell.receivingBtn.tag = 3
            cell.receivingBtn.addTarget(self, action: #selector(runOrderVc(btn:)), for: .touchUpInside)
            cell.evaluateBtn.tag = 5
            cell.evaluateBtn.addTarget(self, action: #selector(runOrderVc(btn:)), for: .touchUpInside)
            cell.returnBtn.tag = 6
            cell.returnBtn.addTarget(self, action: #selector(runOrderVc(btn:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MineImgTableViewCell") as! MineImgTableViewCell
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MineRedTableViewCell") as! MineRedTableViewCell
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MinToolTableViewCell") as! MinToolTableViewCell
        cell.selectionStyle = .none
        return cell
    }

    @objc func runOrderVc(btn: UIButton) {
        if btn.tag == 5 {
            let eva = EvaluateManagerViewController()
            eva.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(eva, animated: true)
            return
        }
        if btn.tag == 6 {
            let eva = BaclGoodsViewController()
            eva.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(eva, animated: true)
            return
        }
        let order = OrderViewController() 
        order.hidesBottomBarWhenPushed = true
        order.tab_status = "\(btn.tag)"
        self.navigationController?.pushViewController(order, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vi = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        vi.backgroundColor = UIColor.tableviewBackgroundColor
        return vi
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30
        }
        return 20
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        } else if indexPath.section == 1 {
            return 122
        } else if indexPath.section == 3 {
            return 70
        } else if indexPath.section == 2 {
            return 102
        }
        return 147
    }
}
