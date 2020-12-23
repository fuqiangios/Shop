//
//  WeakScriptMessageDelegate.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/8/15.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import WebKit

class WeakScriptMessageDelegate: NSObject, WKScriptMessageHandler {
    weak var scriptDelegate: WKScriptMessageHandler?

    init(_ scriptDelegate: WKScriptMessageHandler) {
        self.scriptDelegate = scriptDelegate
        super.init()
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        scriptDelegate?.userContentController(userContentController, didReceive: message)
    }

    
}
