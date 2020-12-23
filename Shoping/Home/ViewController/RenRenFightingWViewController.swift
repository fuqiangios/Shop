//
//  RenRenFightingWViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/8/15.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import JavaScriptCore
import WebViewJavascriptBridge

class RenRenFightingWViewController: UIViewController,UIWebViewDelegate {
    var webView: UIWebView!
    var jsContext: JSContext!
    var bridge: WebViewJavascriptBridge!
    var wechatPaySuccess: ((Int) -> Void)!
    @IBOutlet weak var web: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction(noti:)), name: NSNotification.Name(rawValue: "weixinpaymethod"), object: nil)
        addWebView()
    }
        @objc private func notificationAction(noti: Notification) {
            wechatPaySuccess(Int(noti.object as! String)!)
        }
    func addWebView() {


//        self.web.delegate = self
        self.web.scalesPageToFit = true
        // 加载网络Html页面 请设置允许Http请求
        let url = URL(string: "http://app.necesstore.com/html/renrenpin/disclaimer.html?user_token=\(UserSetting.default.activeUserToken ?? "")");
        let request = URLRequest(url: url!)

        self.web.loadRequest(request)
        WebViewJavascriptBridge.enableLogging()
        bridge = WebViewJavascriptBridge(for: web)
        bridge.setWebViewDelegate(self)
        bridge.registerHandler("backHome", handler: { data,callback in
            self.navigationController?.popViewController(animated: true)
        })
        bridge.registerHandler("submitFromWeb", handler: { data,callback in
            print(data)
            let item = data as! Dictionary<String,String>
            if item["payment_pfn"] == "WeChatPay" {
                self.wechatPay(data: item["plugin"]!, callback2: {str in
                    callback!(["data":str])
                })
                self.wechatPaySuccess = { op in
                    callback!(["data":op])
                }
            } else {
                self.aliPay(str: item["plugin"]!, callback: {str in
                    callback!(["data":str])
                })
            }
        })
    }

        deinit {
            NotificationCenter.default.removeObserver(self)
        }

    func wechatPay(data: String, callback2: @escaping(Int)-> Void) {
            let array : Array = data.components(separatedBy: ",")
            let req = PayReq()
            req.nonceStr = array[1]
            req.partnerId = array[3]
            req.prepayId = array[4]
            req.timeStamp = UInt32(array[6]) ?? 100000
            req.package = array[2]
            req.sign = array[5]
            WXApi.send(req) { (item) in
                print(item)
                if item {

                } else {
                    callback2(2)
                }
            }
        }

    func aliPay(str: String,callback: @escaping(Int)-> Void) {
            AlipaySDK.defaultService()?.payOrder(str, fromScheme: "wojiayoupin", callback: { (reslt) in
                if let Alipayjson = reslt as? NSDictionary{
                    let resultStatus = Alipayjson.value(forKey: "resultStatus") as! String
                    if resultStatus == "9000"{
                        callback(1)
                    } else {
                        callback(2)
                    }
                } else {
                    callback(2)
                }
            })
        }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
