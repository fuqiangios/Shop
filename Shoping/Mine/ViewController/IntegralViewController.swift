//
//  IntegralViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/3/15.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class IntegralViewController: UIViewController {
    var data: Point? = nil
    @IBOutlet weak var pointLable: UILabel!
    @IBOutlet weak var toBtn: UIButton!
    @IBOutlet weak var priceLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        title = "积分"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "查看明细", style: .done, target: self, action: #selector(toDetail))
        toBtn.layer.borderColor = UIColor.white.cgColor
        toBtn.layer.borderWidth = 1
        toBtn.layer.cornerRadius = 25
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }

    @objc func toDetail() {
        let detail = IntegraDetailViewController()
        self.navigationController?.pushViewController(detail, animated: true)
    }

    func loadData() {
        API.pointInfo().request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.setUp()
            case .failure(let er):
                print(er)
            }
        }
    }

    func setUp() {
        pointLable.text = "\(data?.data.points ?? 0)"
        priceLable.text = "\(data?.data.pointUnit ?? "0")"

    }
    @IBAction func toAction(_ sender: Any) {
        let pay = IntegraPayViewController()
        self.navigationController?.pushViewController(pay, animated: true)
    }
}
