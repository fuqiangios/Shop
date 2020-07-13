//
//  WebViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/25.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var wk: WKWebView!
    @IBOutlet weak var webView: UIWebView!
    var uri = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        print(uri)

//        wk.loadRequest(URLRequest(url: URL(string: uri)!))
    }
    override func viewDidAppear(_ animated: Bool) {
        let urlRequest = URLRequest(url: URL(string: uri)!)
               //加载请求
        wk = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))

        wk.load(urlRequest)
        self.view.addSubview(wk)
    }
}
extension WebViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        print(1)
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print(2)
    }
}
