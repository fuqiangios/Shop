//
//  ShareViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/18.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController, UMSocialShareMenuViewDelegate {

    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var info: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "邀请推荐"

        UMSocialUIManager.setShareMenuViewDelegate(self)
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
//        let req = SendMessageToWXReq()
//        req.text = "分享"
//        req.bText = true
//        req.scene = Int32(WXSceneSession.rawValue)
//        WXApi.send(req) { (item) in
//            print(item)
//        }

//        UMSocialManager.default()?.getUserInfo(with: .wechatSession, currentViewController: nil, completion: { (result, er) in
//            print(result)
//            print(er)
//        })

//        UMSocialUIManager.showShareMenuViewInWindow { (type, userInfo) in
//
//        }
//        let m = UMSocialMessageObject()
//        let s = UMShareWebpageObject.shareObject(withTitle: "我家有品", descr: "欢迎使用", thumImage: nil)
//        s?.webpageUrl = "www.baidu.com"
//        m.shareObject = s
//        UMSocialManager.default()?.share(to: .wechatSession, messageObject: m, currentViewController: self, completion: { (le, er) in
//            print(er)
//            print(le)
//        })
        //调用setPreDefinePlatforms的示例
        UMSocialUIManager.setPreDefinePlatforms([NSNumber(integerLiteral:UMSocialPlatformType.wechatSession.rawValue),NSNumber(integerLiteral:UMSocialPlatformType.wechatTimeLine.rawValue)])
        UMSocialShareUIConfig.shareInstance()?.sharePageGroupViewConfig.sharePageGroupViewPostionType = .bottom
        UMSocialShareUIConfig.shareInstance()?.sharePageScrollViewConfig.shareScrollViewPageItemStyleType = .iconAndBGRoundAndSuperRadius
        UMSocialUIManager.showShareMenuViewInWindow { (type, info) in
            let t = type as! UMSocialPlatformType
            let m = UMSocialMessageObject()
                    let s = UMShareWebpageObject.shareObject(withTitle: "注册我家用品APP，免费红包送到手软~", descr: "", thumImage: nil)
            s?.webpageUrl = "https://app.necesstore.com/html/invite.html?code=\(self.code.text ?? "")"
                    m.shareObject = s
                    UMSocialManager.default()?.share(to: t, messageObject: m, currentViewController: self, completion: { (le, er) in
                        print(er)
                        print(le)
                    })
        }
    }

//    func umSocialParentView(_ defaultSuperView: UIView!) -> UIView! {
//        return defaultSuperView
//    }
    func umSocialShareMenuViewDidAppear() {
        print(11)
    }
    func umSocialShareMenuViewDidDisappear() {
        print(222)
    }
    
    @IBAction func copyAction(_ sender: Any) {
        let pastboard = UIPasteboard.general
        pastboard.string = code.text ?? ""
        CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "复制成功", duration: 1)
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
