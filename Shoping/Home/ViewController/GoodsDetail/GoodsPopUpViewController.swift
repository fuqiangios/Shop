//
//  GoodsPopUpViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/20.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class GoodsPopUpViewController: UIViewController {
    enum PopUpType {
        case brand(data: [ProductModel])
        case translate(data: [Coupon])
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHerght: NSLayoutConstraint!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var titleText: UILabel!

    var popUpType: PopUpType

    init(popUpType: PopUpType) {
        self.popUpType = popUpType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(white: 0, alpha: 0.0)
        closeBtn.addTarget(self, action: #selector(closePopUp), for: .touchUpInside)
        setUpTableView()
        switch popUpType {
        case .brand(let data):
            titleText.text = "产品信息"
            closeBtn.setTitle("完  成", for: .normal)
            if data.count > 6 {
                tableViewHerght.constant = 324
            } else {
                tableViewHerght.constant = CGFloat(data.count*54)
            }
            break
        case .translate(let data):
            titleText.text = "优惠券"
            closeBtn.setTitle("关  闭", for: .normal)
            if data.count > 4 {
                tableViewHerght.constant = 360
            } else {
                tableViewHerght.constant = CGFloat(data.count*90)
            }
            break
        }
    }

    @objc func closePopUp() {
        self.dismiss(animated: false, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.init(white: 0, alpha: 0.3)

    }

    func setUpTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "GoodsPopUpBrandTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsPopUpBrandTableViewCell")
        tableView.register(UINib(nibName: "GoodsPopUpTransateTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsPopUpTransateTableViewCell")
    }
}
extension GoodsPopUpViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if case .brand(let data) = popUpType {
            return data.count
        } else if case .translate(let data) = popUpType {
            return data.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if case .brand(let data) = popUpType {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsPopUpBrandTableViewCell") as! GoodsPopUpBrandTableViewCell
            cell.name.text = data[indexPath.row].key
            cell.info.text = data[indexPath.row].value
            cell.selectionStyle = .none
            return cell
        } else if case .translate(let data) = popUpType {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsPopUpTransateTableViewCell") as! GoodsPopUpTransateTableViewCell
            cell.selectionStyle = .none
            cell.price.text = data[indexPath.row].faceValue
            cell.info.text = data[indexPath.row].name
            if data[indexPath.row].hasReceive {
                cell.bbtn.backgroundColor = UIColor.init(red: 178.0/255.0, green: 169.0/255.0, blue: 168.0/255.0, alpha: 1)
                cell.bbtn.setTitle("已领取", for: .normal)
                cell.bbtn.isUserInteractionEnabled = false
            }
            cell.bbtn.tag = indexPath.row + 10000
            cell.bbtn.addTarget(self, action: #selector(getCopun(btn:)), for: .touchUpInside)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsPopUpBrandTableViewCell") as! GoodsPopUpBrandTableViewCell
        cell.selectionStyle = .none
        return cell
    }

    @objc func getCopun(btn: UIButton) {
        if case .translate(let data) = popUpType {
            API.receiveCoupon(coupon_id: data[btn.tag - 10000].id).request { (result) in
                switch result {
                case .success:
                    btn.backgroundColor = UIColor.init(red: 178.0/255.0, green: 169.0/255.0, blue: 168.0/255.0, alpha: 1)
                    btn.setTitle("已领取", for: .normal)
                    btn.isUserInteractionEnabled = false
                    NotificationCenter.default.post(name: NSNotification.Name("updateGoodsInfo"), object: self, userInfo: [:])
                    break
                case .failure:
                    break
                }

            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if case .brand = popUpType {
            return 54
        }
        return 90
    }
}
