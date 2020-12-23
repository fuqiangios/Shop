//
//  AppDelegate.swift
//  Shoping
//
//  Created by qiang.c.fu on 2019/12/25.
//  Copyright © 2019 付强. All rights reserved.
//

import UIKit
import netfox
import UserNotifications
import NotificationCenter
import AdSupport
import SecurityEnvSDK


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate, UNUserNotificationCenterDelegate, JPUSHRegisterDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UMConfigure.setLogEnabled(true)
        WXApi.registerApp("wx55d4b9901badc2be", universalLink: "https://app.necesstore.com")
        UMConfigure.initWithAppkey("5eba3a36895ccab0640000b8", channel: "AppStore")

        UMSocialManager.default()?.setPlaform(.wechatSession, appKey: "wx55d4b9901badc2be", appSecret: "57dcbde37fcc0163b4a46b0fe974c540", redirectURL: "")

        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.getNotificationSettings { (setting) in
                if setting.authorizationStatus == .notDetermined {
                    center.requestAuthorization(options: [.badge,.sound,.alert]) { (result, error) in
                        if(result){
                            if !(error != nil){
                                // 注册成功
                                DispatchQueue.main.async {
                                    application.registerForRemoteNotifications()
                                }
                            }
                        } else{
                            //用户不允许推送
                        }
                    }
                } else if (setting.authorizationStatus == .denied){
                    // 申请用户权限被拒
                } else if (setting.authorizationStatus == .authorized){
                    // 用户已授权（再次获取dt）
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                } else {
                    // 未知错误
                }
            }
        }
                let entity = JPUSHRegisterEntity()
                entity.types = 1 << 0 | 1 << 1 | 1 << 2



        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        //需要IDFA 功能，定向投放广告功能
                let advertisingId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                JPUSHService.setup(withOption: launchOptions, appKey: "8268f0fe2d6af98639be5baf", channel: "App Store", apsForProduction: false, advertisingIdentifier: nil)
//        NFX.sharedInstance().start()
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
        //销毁通知红点
        UIApplication.shared.applicationIconBadgeNumber = 0
        JPUSHService.setBadge(0)
        UIApplication.shared.cancelAllLocalNotifications()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0 
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
        print(deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) { //可选
        print("did Fail To Register For Remote Notifications With Error: \(error)")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if let paste = UIPasteboard.general.string {
            checkPasteStatus(paste: paste)
            return

            }
    }

    func checkPasteStatus(paste: String) {
        print("-=_=-=-=-+_+-=\(paste)")
        if UserSetting.default.activeUserToken == nil {
            return
        }
        let pastboard = UIPasteboard.general
        pastboard.string = ""
        API.checkInviteGoods(user_token: UserSetting.default.activeUserToken ?? "", buyer_password: paste).request { (result) in
            switch result{
            case .success(let data):
                let invite = InviteGoodsViewController()
                invite.modalPresentationStyle = .custom
                invite.data = data
                invite.toGoodsDetail = { op in
                 let tabbar =   UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
                    tabbar.selectedIndex = 0
                    let detail = GoodsDeatilViewController()
                    detail.hidesBottomBarWhenPushed = true
                    detail.product_id = data.data?.id ?? ""
                    if tabbar.viewControllers?.count ?? 0 >= 1 {
                        (tabbar.viewControllers![0]as! UINavigationController).viewControllers.last?.navigationController?.pushViewController(detail, animated: true)
                    }
                }
                UIApplication.shared.keyWindow?.rootViewController?.present(invite, animated: false, completion: nil)
            case .failure(let er):
                print("0+++++++++\(er)")
            }
        }
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
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {

             let userInfo = notification.request.content.userInfo
             if notification.request.trigger is UNPushNotificationTrigger {
                 JPUSHService.handleRemoteNotification(userInfo)
             }
            // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    //        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
        }

        func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]!) {
    //        JPUSHService.handleRemoteNotification(info)
    //        completionHandler(UIBackgroundFetchResult.newData)
        }

        @available(iOS 10.0, *)
        func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {

            let userInfo = notification.request.content.userInfo
            if notification.request.trigger is UNPushNotificationTrigger {
                JPUSHService.handleRemoteNotification(userInfo)
            }
           // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
           completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
        }

        func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
           let userInfo = response.notification.request.content.userInfo
            if response.notification.request.trigger is UNPushNotificationTrigger {
                JPUSHService.handleRemoteNotification(userInfo)
            }
            // 系统要求执行这个方法
            completionHandler()
        }

        //点推送进来执行这个方法
        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
               JPUSHService.handleRemoteNotification(userInfo)
               completionHandler(UIBackgroundFetchResult.newData)

        }




        //系统获取Token
    //    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    //        JPUSHService.registerDeviceToken(deviceToken)
    //    }
}

