//
//  ContactViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/8/15.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var img: UIImageView!
    var pone: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        title = "联系客服"
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(call), for: .touchUpInside)
        loadData()
    }

    @objc func call() {
        var tel = "tel://"+pone
        //去掉空格-不然有些电话号码会使 URL 报 nil
        tel = tel.replacingOccurrences(of: " ", with: "", options: .literal, range: nil);
        print(tel)
        if let urls = URL(string: tel){
            //ios 10.0以上和一下调用不同的方法拨打电话-默认都会弹框询问
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(urls, options: [:], completionHandler: {
                   (success) in
                    print("Open \(self.pone): \(success)")
                })
            } else {
                UIApplication.shared.openURL(urls)
            }
        }else{
            print("url 为空!")
        }

    }

    func loadData() {
        API.getContact().request { (result) in
            switch result {
            case .success(let data):
                self.btn.setTitle("拨打电话: \(data.data.contact.telephone)", for: .normal)
                self.img.af_setImage(withURL: URL(string: data.data.contact.wx)!)
                self.pone = data.data.contact.telephone
            case .failure(let er):
                print(er)
            }
        }
    }
}
