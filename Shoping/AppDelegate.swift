//
//  AppDelegate.swift
//  Shoping
//
//  Created by qiang.c.fu on 2019/12/25.
//  Copyright © 2019 付强. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        WXApi.registerApp("wx55d4b9901badc2be", universalLink: "https://")
        window = UIWindow(frame: UIScreen.main.bounds)
        let story =  UIStoryboard.init(name: "Main", bundle: nil)
        self.window?.rootViewController = story.instantiateInitialViewController()
        window?.makeKeyAndVisible()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
        if url.host == "safepay" {
        AlipaySDK.defaultService()?.processOrder(withPaymentResult: url, standbyCallback: nil)
        AlipaySDK.defaultService()?.processAuth_V2Result(url, standbyCallback: nil)
        } else {

            WXApi.handleOpen(url, delegate: self)

            if url == URL(string: "wx55d4b9901badc2be://pay/?returnKey=&ret=0") {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"weixinpaymethod" object:@"1"];
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "weixinpaymethod"), object: "1")
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "weixinpaymethod"), object: "2")
            }
        }
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
//        LocationManager.sharedInstance.stopUpdatingLocation()
        UIApplication.shared.applicationIconBadgeNumber = 10
//        LocationManager.sharedInstance.startUpdatingLocation()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 120
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    private func onResp(_ req: BaseReq) {
        print("99999999999999999999999999999999")
        print(req)
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print(url)
        if url.host == "safepay" {
        AlipaySDK.defaultService()?.processOrder(withPaymentResult: url, standbyCallback: nil)
            AlipaySDK.defaultService()?.processAuth_V2Result(url, standbyCallback: nil)
        } else {

            WXApi.handleOpen(url, delegate: self)
                        if url == URL(string: "wx55d4b9901badc2be://pay/?returnKey=&ret=0") {
            //                [[NSNotificationCenter defaultCenter] postNotificationName:@"weixinpaymethod" object:@"1"];
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "weixinpaymethod"), object: "1")
                        } else {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "weixinpaymethod"), object: "2")
                        }
        }
        return true
    }
}

