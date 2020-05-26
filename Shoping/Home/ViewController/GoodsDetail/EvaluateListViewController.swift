//
//  EvaluateListViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/1/12.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import MJRefresh

class EvaluateListViewController: UIViewController {

    @IBOutlet weak var floatView: UIView!
    @IBOutlet weak var addCardBtn: UIButton!
    @IBOutlet weak var bugBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var product_id: String = ""
    var page: Int = 1
    var data: GoodsEvaluateList? = nil
    var goodsData: GoodsDetail? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        loadData()
    }

    func setUp() {
        title = "评价"
//        bugBtn.layer.cornerRadius = 5
//        bugBtn.layer.masksToBounds = true
//
//        addCardBtn.layer.borderColor = bugBtn.backgroundColor?.cgColor
//        addCardBtn.layer.borderWidth = 1
//        addCardBtn.layer.cornerRadius = 5
//        addCardBtn.layer.masksToBounds = true
//        addCardBtn.addTarget(self, action: #selector(addCartAction), for: .touchUpInside)
//        bugBtn.addTarget(self, action: #selector(addCartAction), for: .touchUpInside)
//        floatView.layer.cornerRadius = 5
//        floatView.layer.masksToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "GoodsEvaluateTableViewCell", bundle: nil), forCellReuseIdentifier: "GoodsEvaluateTableViewCell")
        tableView.register(UINib(nibName: "EvaluateReplyTableViewCell", bundle: nil), forCellReuseIdentifier: "EvaluateReplyTableViewCell")
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page = self.page + 1
            self.loadDataMore()
        })
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            self.loadData()
        })
    }

    @objc func addCartAction() {
        if UserSetting.default.activeUserToken == nil {
        let login = LoginViewController()
        self.navigationController?.pushViewController(login, animated: true)
            return
        }

        let type = SelectTypeViewController()
        type.modalPresentationStyle = .pageSheet
        type.data = goodsData
        self.present(type, animated: true, completion: nil)
    }

    func loadData() {
        page = 1
        API.evaluateList(product_id: product_id, page: "\(page)").request { (result) in
            self.tableView.mj_header?.endRefreshing()
            switch result {
            case .success(let data):
                self.data = data
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    func loadDataMore() {
        API.evaluateList(product_id: product_id, page: "\(page)").request { (result) in
            self.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let data):
                var ar = self.data?.data ?? []
                ar = ar + data.data
                self.data = GoodsEvaluateList(result: true, message: "", status: 200, data: ar)
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension EvaluateListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (data?.data[section].evaluateReply.count ?? 0) < 1 {
            return 1
        }
        return 2
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return data?.data.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluateReplyTableViewCell") as! EvaluateReplyTableViewCell
            cell.name.text = "有家用品: \(data?.data[indexPath.section].evaluateReply[0].content ?? "")"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsEvaluateTableViewCell") as! GoodsEvaluateTableViewCell
        let info = data?.data ?? []
        cell.userName.text = info[indexPath.section].userName
        cell.userImage.af_setImage(withURL: URL(string: info[indexPath.section].getUserImage())!)
        cell.detail.text = info[indexPath.section].content
        cell.date.text = info[indexPath.section].created
        if info[indexPath.section].evaluateImage.count == 0 {
            cell.imgLayout.constant = 0
        } else {
            cell.imgLayout.constant = 50
        }
        for index in 0..<info[indexPath.section].evaluateImage.count {
            let item = info[indexPath.section].evaluateImage[index]
            if index == 0 {
                cell.img1.af_setImage(withURL: URL(string: item)!)
            } else if index == 1 {
                cell.img2.af_setImage(withURL: URL(string: item)!)
            } else if index == 2 {
                cell.img3.af_setImage(withURL: URL(string: item)!)
            } else if index == 3 {
                cell.img4.af_setImage(withURL: URL(string: item)!)
            } else if index == 4 {
                cell.img5.af_setImage(withURL: URL(string: item)!)
            }
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

//    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
//        return 1
//    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
                let view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .groupTableViewBackground
        } else {
            view.backgroundColor = .groupTableViewBackground
        }
        return view
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}
