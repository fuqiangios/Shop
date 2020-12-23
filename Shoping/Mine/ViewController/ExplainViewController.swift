//
//  WebViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/25.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import WebKit

class ExplainViewController: UIViewController {

    var wk: WKWebView!
    @IBOutlet weak var webView: UIWebView!
    var uri = ""
    var code = ""
    var data: Expiain? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        wk = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.view.addSubview(wk)
        loadData()
    }
    override func viewDidAppear(_ animated: Bool) {

    }

    func loadData() {
        API.getExpiainn(code: code).request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.wk.loadHTMLString(data.data.content, baseURL: URL(string: urlheadr))
            case .failure(let er):
                print(er)
            }
        }
    }
}
extension ExplainViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        print(1)
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print(2)
    }
}
