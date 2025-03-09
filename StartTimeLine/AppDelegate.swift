//
//  AppDelegate.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/1.
//

import Foundation
import IQKeyboardManagerSwift
import SDWebImageSwiftUI
import SVProgressHUD
import UIKit
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate, JPUSHRegisterDelegate {
    var window: UIWindow?

    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification) {}

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

    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable: Any]?) {}

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let entity = JPUSHRegisterEntity()
        entity.types = NSInteger(UNAuthorizationOptions.alert.rawValue) |
            NSInteger(UNAuthorizationOptions.sound.rawValue) |
            NSInteger(UNAuthorizationOptions.badge.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        JPUSHService.setup(withOption: launchOptions, appKey: jPushAppKey, channel: jPushChannel, apsForProduction: isProduction)
        
        /// 初始化SVHUd
        initSVHud()
        intSDInfo()
        initIQkeyBoard()
        initAppData()
        injection()
        initShare()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}

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
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {}

    @available(iOS 7, *)
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {}

    @available(iOS 7, *)
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], withResponseInfo responseInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {}

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

    func intSDInfo() {
        let cache = SDImageCache.shared
        cache.config.maxMemoryCost = 100 * 1024 * 1024 // 100MB 内存缓存
        cache.config.maxDiskSize = 500 * 1024 * 1024 // 500MB 磁盘缓存
        cache.config.shouldCacheImagesInMemory = true
        cache.config.shouldUseWeakMemoryCache = true

        // 配置 SDWebImage 下载器
        let downloader = SDWebImageDownloader.shared
        downloader.config.downloadTimeout = 15.0 // 15秒超时
        downloader.config.maxConcurrentDownloads = 6
        downloader.config.operationClass = SDWebImageDownloaderOperation.self
    }

    // 初始化iqkeyboard
    func initIQkeyBoard() {
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true // 当点击键盘外部时，键盘是否应该关闭
        IQKeyboardManager.shared.shouldGroupAccessibilityChildren = false // 是否显示工具栏占位符
        IQKeyboardManager.shared.keyboardDistance = 10 // 输入框距离键盘的距离
    }
    
    // 扩展share
    func initShare(){
        MobSDK.uploadPrivacyPermissionStatus(true)
        MobSDK.registerAppKey("3a94b7d292c9d", appSecret: "54a47552896548325cd8d7c71662cbfa")
        ShareSDK.registPlatforms { register in
            register?.setupWeChat(withAppId: wechatAppkey, appSecret: wechatAppSerect, universalLink: "49032217697a2e2090f03b884de16581.share2dlink.com")
            register?.setupSinaWeibo(withAppkey: sinaAppkey, appSecret: sinaAppSerect, redirectUrl: "", universalLink: "https://serv.xingshiji.cc")
        }
    
    }
}

extension AppDelegate {
    func initAppData() {
        UserSharedManger.shared.updateUserInfo { _, _ in
            // 如果是
        }
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
