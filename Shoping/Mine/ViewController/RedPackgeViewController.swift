//
//  RedPackgeViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/3/15.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class RedPackgeViewController: UIViewController {
    @IBOutlet weak var price: UILabel!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backView: UIView!
    var type = "1"
    var data: Redpackge? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        title = "红包"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "查看明细", style: .done, target: self, action: #selector(toDetail))
//        setShadow(view: backView, sColor: UIColor.init(white: 0.8, alpha: 1), offset: CGSize(width: 0, height: 0), opacity: 1, radius: 5)
        tableView.register(UINib(nibName: "RedPackgeTableViewCell", bundle: nil), forCellReuseIdentifier: "RedPackgeTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
//        tableView.separatorStyle = .none
        loadData()
    }

    @objc func toDetail() {
        let history = RedHistoryViewController()
        self.navigationController?.pushViewController(history, animated: true)
    }

    @IBAction func shouruAction(_ sender: UIButton) {
        updateBtnStatus()
        sender.setTitleColor(sender.tintColor, for: .normal)
        type = "1"
        loadData()
    }

    @IBAction func zhichuAction(_ sender: UIButton) {
        updateBtnStatus()
        sender.setTitleColor(sender.tintColor, for: .normal)
        type = "2"
        loadData()
    }

    @IBAction func guoqiAction(_ sender: UIButton) {
        updateBtnStatus()
        sender.setTitleColor(sender.tintColor, for: .normal)
        type = "3"
        loadData()
    }

    func updateBtnStatus() {
        for index in 100...102 {
            let btn = view.viewWithTag(index)as!UIButton
            btn.setTitleColor(.black, for: .normal)
        }
    }

    func loadData() {
        API.redpackgeList(type: type).request { (result) in
            switch result{
            case .success(let data):
                self.data = data
                self.price.text = data.data.redPackage
                self.tableView.reloadData()
            case .failure:
                print("error")
            }
        }
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

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension RedPackgeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.data.redPackageList.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RedPackgeTableViewCell") as! RedPackgeTableViewCell
        let item = data?.data.redPackageList[indexPath.row]
        cell.price.text = "\(item?.value ?? "")"
        cell.info.text = item?.method ?? ""
        cell.shiyong.text = "\(item?.created ?? "")"
        cell.youxian.text = "\(item?.endDate ?? "")"
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89
        
    }
}
