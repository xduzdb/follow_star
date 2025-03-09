//
//  AppDelegate.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/1.
//

import Foundation
import SVProgressHUD
import UIKit
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate, JPUSHRegisterDelegate {
    var window: UIWindow?

    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification) {
    }

    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        //    let userInfo = response.notification.request.content.userInfo
        //    let request = response.notification.request // 收到推送的请求
        //    let content = request.content // 收到推送的消息内容
        //    let badge = content.badge // 推送消息的角标
        //    let body = content.body   // 推送消息体
        //    let sound = content.sound // 推送消息的声音
        //    let subtitle = content.subtitle // 推送消息的副标题
        //    let title = content.title // 推送消息的标题
        // Required
        let userInfo = response.notification.request.content.userInfo
        print("jpushNotificationCenter didReceive userInfo: \(userInfo)")

        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        } else {
            // 本地通知
        }

        completionHandler() // 系统要求执行这个方法
    }

    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        // Required
        let userInfo = notification.request.content.userInfo

        print("jpushNotificationCenter willPresent userInfo: \(userInfo)")

        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        } else {
            // 本地通知
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue)) // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
    }

    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable: Any]?) {
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let entity = JPUSHRegisterEntity()
        entity.types = NSInteger(UNAuthorizationOptions.alert.rawValue) |
            NSInteger(UNAuthorizationOptions.sound.rawValue) |
            NSInteger(UNAuthorizationOptions.badge.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        JPUSHService.setup(withOption: launchOptions, appKey: jPushAppKey, channel: jPushChannel, apsForProduction: isProduction)
        /// 初始化SVHUd
        initSVHud()
        initAppData()
        injection()
        intiUmeng()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("get the deviceToken  \(deviceToken)")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DidRegisterRemoteNotification"), object: deviceToken)
        JPUSHService.registerDeviceToken(deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did fail to register for remote notification with error ", error)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
        print("收到通知", userInfo)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AddNotificationCount"), object: nil) // 把  要addnotificationcount
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        print("application 收到到通知", userInfo)
        completionHandler(.newData)
    }

    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        JPUSHService.showLocalNotification(atFront: notification, identifierKey: "")
    }

    @available(iOS 7, *)
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
    }

    @available(iOS 7, *)
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
    }

    @available(iOS 7, *)
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], withResponseInfo responseInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return UMSocialManager.default().handleOpen(url)
    }
}

extension AppDelegate {
    func initSVHud() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        SVProgressHUD.setMaximumDismissTimeInterval(10)
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 12))
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setMinimumSize(CGSize(width: 90, height: 90))
    }
}

extension AppDelegate {
    func initAppData() {
        UserSharedManger.shared.updateUserInfo { _, _ in
            // 如果是
        }
    }
}

extension AppDelegate {
    // 初始化友盟
    func intiUmeng() {
        UMConfigure.initWithAppkey(UmengAppkey, channel: "App Store")
        UMConfigure.setLogEnabled(true)
        UMConfigure.setEncryptEnabled(false)
        configUSharePlatforms()
    }

    // 设置相关config
    func configUSharePlatforms() {
        UMSocialManager.default()?.setPlaform(UMSocialPlatformType.wechatSession, appKey: wechatAppkey, appSecret: wechatAppSerect, redirectURL: "")

        /* 设置分享到QQ互联的appID
         * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
         100424468.no permission of union id
         */
//        UMSocialManager.default().setPlaform(UMSocialPlatformType.QQ, appKey: qqAppkey, appSecret: nil, redirectURL: "http://mobile.umeng.com/social")
//
//        /* 设置新浪的appKey和appSecret */
//        UMSocialManager.default().setPlaform(UMSocialPlatformType.sina, appKey: sinaAppkey, appSecret: sinaAppSerect, redirectURL: "http://mobile.umeng.com/social")
    }
}

// Swift的注入
extension AppDelegate {
    // InjectionIII 注入
    // https://github.com/johnno1962/InjectionIII/blob/main/README_Chinese.md
    func injection() {
        #if DEBUG
            do {
                let injectionBundle = Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")
                if let bundle = injectionBundle {
                    try bundle.loadAndReturnError()
                } else {
                    debugPrint("Injection 注入失败,未能检测到 Injection")
                }

            } catch {
                debugPrint("Injection 注入失败 \(error)")
            }
        #endif
    }
}
