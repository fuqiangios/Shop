//
//  RenRenFightingViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/8/15.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import WebKit
import WebViewJavascriptBridge

class RenRenFightingViewController: UIViewController,WKNavigationDelegate{
    var webView: WKWebView!
//    var bridge:WKWebViewJavascriptBridge!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        webView = WKWebView(frame: CGRect(x: 0,
                                              y: 44,
                                              width: UIScreen.main.bounds.width,
                                              height: UIScreen.main.bounds.height-44))
        // 让webview翻动有回弹效果
//        webView.scrollView.bounces = false
//        // 只允许webview上下滚动
//        webView.scrollView.alwaysBounceVertical = true
        webView.navigationDelegate = self
        //自定义userAgent,用于在浏览器中判断是否在app打开
//        webView.customUserAgent = "iosApp"
        webView.load(URLRequest(url: URL(string: "http://app.necesstore.com/html/renrenpin/disclaimer.html?user_token=\(UserSetting.default.activeUserToken ?? "")")!))
        view.addSubview(webView)

        WKWebViewJavascriptBridge.enableLogging()
        let bridge = WKWebViewJavascriptBridge(for: webView)
        bridge!.setWebViewDelegate(self)
        bridge!.registerHandler("backHome", handler: { data, callback in
            print(data)
        })
        bridge!.registerHandler("submitFromWeb", handler: { data, callback in
            print(data)
        })

    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }


}
