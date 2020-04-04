//
//  AddEvaluateViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/3/10.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class AddEvaluateViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var eva: EvaluateDatum? = nil
    var coment: AddEvaluateComenntTableViewCell? = nil
    var star: String? = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }

    func setUp() {
        title = "评价晒单"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .done, target: self, action: #selector(submit))
        tableView.register(UINib(nibName: "AddEvaluateGoodsTableViewCell", bundle: nil), forCellReuseIdentifier: "AddEvaluateGoodsTableViewCell")
        tableView.register(UINib(nibName: "AddEvaluateComenntTableViewCell", bundle: nil), forCellReuseIdentifier: "AddEvaluateComenntTableViewCell")
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }

    @objc func submit() {
        API.evaluateSubmitn(orderId: eva?.orderID ?? "", product_id: eva?.productID ?? "", star: star ?? "0", content: coment?.getComent() ?? "", images: coment?.getImgs() ?? []).request { (result) in
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

extension AddEvaluateViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddEvaluateComenntTableViewCell") as! AddEvaluateComenntTableViewCell
            cell.setUp(text: "请您根据商品及我们的服务请客给予评价")
            coment = cell
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddEvaluateGoodsTableViewCell") as! AddEvaluateGoodsTableViewCell
        cell.img.af_setImage(withURL: URL(string: eva!.image)!)
        cell.name.text = eva?.name ?? ""
        cell.star.successBlock = { (inndx, halfIndex, percent) in
            print(inndx)
            self.star = "\(inndx + 1)"
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vi = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 10))
        vi.backgroundColor = UIColor.groupTableViewBackground
        return vi
    }

}
