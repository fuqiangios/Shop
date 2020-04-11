//
//  CreatOrderSelectPayTypeViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/1/31.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class CreatOrderSelectPayTypeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var bottomLayout: NSLayoutConstraint!
    @IBOutlet weak var floatView: UIView!
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var price: UILabel!
    var priceText: String = ""
    var data: [Datum] = []
    var addressInfo:AddressDatum? = nil
    var order_type: String = ""
    var selectIndex: Int = -1
    var payList: PayList? = nil
    var redpackgePrice: Double? = 0.00
    var couponId: String? = ""
    var store: Store? = nil
    var product_id: String? = ""
    var quantity: String? = ""
    var product_option_union_id: String? = ""

    var didPaySuccess: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        price.text = priceText
//        submitBtn.addTarget(self, action: #selector(submitAction(_:)), for: .touchUpInside)
        setUp()
    }

    override func viewDidAppear(_ animated: Bool) {
    }

    override func viewWillDisappear(_ animated: Bool) {
        view.backgroundColor = .clear
    }

    func setUp() {
        bottomLayout.constant = 0
        floatView.layer.cornerRadius = 5
        floatView.layer.masksToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(UINib(nibName: "CreatOrderPayTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatOrderPayTypeTableViewCell")
        tableView.reloadData()
    }

    
}
extension CreatOrderSelectPayTypeViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payList?.data.payment.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreatOrderPayTypeTableViewCell") as! CreatOrderPayTypeTableViewCell
        cell.name.text = payList?.data.payment[indexPath.row].name ?? ""
        cell.img.af_setImage(withURL: URL(string: (payList?.data.payment[indexPath.row].getIcon())!)!)
        if indexPath.row == selectIndex {
            cell.selectImg.image = UIImage(named: "ic_fu")
        } else {
            cell.selectImg.image = UIImage(named: "ic_ellipse")
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        tableView.reloadData()
    }
}
