//
//  BalanceViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/3/15.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class BalanceViewController: UIViewController {

    @IBOutlet weak var zhanngdan: UIButton!
    @IBOutlet weak var chonngzhi: UIButton!
    @IBOutlet weak var zhuanch: UIButton!
    @IBOutlet weak var tixian: UIButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var info: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    func loadData() {
        API.amountInfo().request { (result) in
            switch result{
            case .success(let data):
                self.price.text = data.data.amount
                self.info.text = data.data.content
            case .failure:
                print("error")
            }
        }
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
