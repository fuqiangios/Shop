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

    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var toBtn: UIButton!
    @IBOutlet weak var infoLabble: UITextView!
    @IBOutlet weak var priceLable: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    func loadData() {
        API.pointInfo().request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.setUp()
            case .failure:
                print("error")
            }
        }
    }

    func setUp() {
        pointLable.text = "\(data?.data.points ?? 0)"
        priceLable.text = "\(data?.data.pointUnit ?? "0")"
        infoLabble.text = "\(data?.data.content ?? "")"
    }
    @IBAction func toAction(_ sender: Any) {

    }

    @IBAction func innfoAction(_ sender: Any) {

    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
