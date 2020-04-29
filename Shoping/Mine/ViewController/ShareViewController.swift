//
//  ShareViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/18.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {

    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var info: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "邀请推荐"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        loadData()
    }

    func loadData() {
        API.getShare().request { (result) in
            switch result {
            case .success(let data):
                self.info.text = data.data.signUpGift
                self.code.text = data.data.inviteCode
            case .failure(let er):
                print(er)
            }
        }
    }

    @IBAction func shareAction(_ sender: Any) {
        let req = SendMessageToWXReq()
        req.text = "分享"
        req.scene = Int32(WXSceneSession.rawValue)
        WXApi.send(req) { (item) in
            print(item)
        }
    }
    
    @IBAction func copyAction(_ sender: Any) {
        let pastboard = UIPasteboard.general
        pastboard.string = code.text ?? ""
        CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "复制成功", duration: 1)
    }
}
