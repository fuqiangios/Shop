//
//  WebViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/25.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var uri = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        print(uri)
        webView.delegate = self
        webView.loadRequest(URLRequest(url: URL(string: uri)!))
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
