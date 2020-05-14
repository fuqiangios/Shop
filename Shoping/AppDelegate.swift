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
        UMConfigure.setLogEnabled(true)
        WXApi.registerApp("wx55d4b9901badc2be", universalLink: "https://")
        UMConfigure.initWithAppkey("5eba3a36895ccab0640000b8", channel: "AppStore")

        UMSocialManager.default()?.setPlaform(.wechatSession, appKey: "wx55d4b9901badc2be", appSecret: "57dcbde37fcc0163b4a46b0fe974c540", redirectURL: "")

//        window = UIWindow(frame: UIScreen.main.bounds)
//        let story =  UIStoryboard.init(name: "Main", bundle: nil)
//        self.window?.rootViewController = story.instantiateInitialViewController()
//        window?.makeKeyAndVisible()
//
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return WXApi.handleOpenUniversalLink(userActivity, delegate: self)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
        let r = UMSocialManager.default()?.handleOpen(url)
        if !(r ?? false) {
        if url.host == "safepay" {
        AlipaySDK.defaultService()?.processOrder(withPaymentResult: url, standbyCallback: nil)
        AlipaySDK.defaultService()?.processAuth_V2Result(url, standbyCallback: nil)
        } else {

            WXApi.handleOpen(url, delegate: self)

            if url == URL(string: "wx55d4b9901badc2be://pay/?returnKey=&ret=0") {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"weixinpaymethod" object:@"1"];
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "weixinpaymethod"), object: "1")
            } else {
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "weixinpaymethod"), object: "2")
            }
        }
        }
        return r ?? false
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

    func onReq(_ req: BaseReq) {
        print("99999999999999999999999999999999")
        print(req)
    }

    func onResp(_ resp: BaseResp) {
        if resp.isKind(of: PayResp.self) {
            switch resp.errCode {
            case 0:
                  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "weixinpaymethod"), object: "1")
            default:
                  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "weixinpaymethod"), object: "2")
            }
        } else if resp.isKind(of: SendAuthResp.self) {
            let r = resp as! SendAuthResp
            switch resp.errCode {
            case 0:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "weixinlogin"), object: r.country)
            default:
                break
            }
        }
        print(resp)
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print(url)
        let r = UMSocialManager.default()?.handleOpen(url)
        if !(r ?? false) {
        if url.host == "safepay" {
        AlipaySDK.defaultService()?.processOrder(withPaymentResult: url, standbyCallback: nil)
            AlipaySDK.defaultService()?.processAuth_V2Result(url, standbyCallback: nil)
        } else {

            WXApi.handleOpen(url, delegate: self)
                        if url == URL(string: "wx55d4b9901badc2be://pay/?returnKey=&ret=0") {
            //                [[NSNotificationCenter defaultCenter] postNotificationName:@"weixinpaymethod" object:@"1"];

                        } else {
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "weixinpaymethod"), object: "2")
                        }
        }
        }
        return r ?? false
    }
}

