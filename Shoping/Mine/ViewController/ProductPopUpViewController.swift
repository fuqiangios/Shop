//
//  ProductPopUpViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/8/17.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class ProductPopUpViewController: UIViewController {

    @IBOutlet weak var sureBtn: UIButton!

    @IBOutlet weak var webView: UIWebView!
    var sureBlock: ((String)->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        sureBtn.layer.cornerRadius = 5
        sureBtn.layer.masksToBounds = true
        loadData()
    }

    func loadData() {
        API.getExpiainn(code: "project_apply").request { (result) in
            switch result {
            case .success(let data):
                self.webView.loadHTMLString(data.data.content, baseURL: URL(string: urlheadr))
            case .failure(let er):
                print(er)
            }
        }
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sureAction(_ sender: Any) {
        sureBlock?("sure")
        self.dismiss(animated: true, completion: nil)
    }
}
