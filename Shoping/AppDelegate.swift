//
//  AppDelegate.swift
//  Shoping
//
//  Created by qiang.c.fu on 2019/12/25.
//  Copyright © 2019 付强. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        WXApi.registerApp("wxb4ba3c02aa476ea1", universalLink: "")
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

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print(url)
        if url.host == "safepay" {
        AlipaySDK.defaultService()?.processOrder(withPaymentResult: url, standbyCallback: nil)
            AlipaySDK.defaultService()?.processAuth_V2Result(url, standbyCallback: nil)
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

//    @available(iOS 13.0, *)
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        if #available(iOS 13.0, *) {
//            return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//        } else {
//            return UISceneConfiguration()
//        }
//    }
//
//    @available(iOS 13.0, *)
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
//
//
}

