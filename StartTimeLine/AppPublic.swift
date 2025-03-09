//
//  AppPublic.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/4.
//

import ObjectMapper
import UIKit

let isRelease = false

// 是不是打开其他方式方式  目前没有对应的key 需要进行隐藏
let isShowOtherLogin = true

// 一些Config

// 极光推送
let jPushAppKey = "dc7457a784d454be057e519c"
let jPushChannel = "AppStore"
let isProduction = false

// 友盟一些key QQ和新浪的暂时没有
let UmengAppkey = "6711d4f6667bfe33f3c3f42c"

let wechatAppkey = "wx34908d77740cafda"
let wechatAppSerect = "cd5e6eebbfa00e9f34714dc22bd2c21f"

let qqAppkey = "6711d4f6667bfe33f3c3f42c"

let sinaAppkey = "6711d4f6667bfe33f3c3f42c"
let sinaAppSerect = "6711d4f6667bfe33f3c3f42c"

// MARK: - GCD

let globalQuene = DispatchQueue.global()
let mainQuene = DispatchQueue.main

// MARK: ========= DeviceInfo ==========

/// 屏幕的宽
public let SCREEN_WIDTH = UIScreen.main.bounds.size.width
/// 屏幕的高
public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

/// iPhone4
public let isIphone4 = SCREEN_HEIGHT < 568 ? true : false
/// iPhone 5
public let isIphone5 = SCREEN_HEIGHT == 568 ? true : false
/// iPhone 6
public let isIphone6 = SCREEN_HEIGHT == 667 ? true : false
/// iphone 6P
public let isIphone6P = SCREEN_HEIGHT == 736 ? true : false
/// iphone X_XS
public let isIphoneX_XS = SCREEN_HEIGHT == 812 ? true : false
/// iphone XR_XSMax
public let isIphoneXR_XSMax = SCREEN_HEIGHT == 896 ? true : false

public let kStatusBarHeight: CGFloat = SCREEN_HEIGHT >= 812 ? 44 : 20
public let kNavigationBarHeight: CGFloat = 44
public let kStatusAndNavBarHeight: CGFloat = SCREEN_HEIGHT >= 812 ? 88 : 64
public let kTabbarSafeMargin: CGFloat = SCREEN_HEIGHT >= 812 ? 34 : 0
public let kTabbarHeight: CGFloat = SCREEN_HEIGHT >= 812 ? 49 + 34 : 49

// MARK: ========= 屏幕适配 ==========

public let kScaleX: Float = .init(SCREEN_WIDTH / 375.0)
public let kScaleY: Float = .init(SCREEN_HEIGHT / 667.0)
public func ST_DP(_ x: CGFloat) -> CGFloat {
    return (x * SCREEN_WIDTH) / 375.0
}

// MARK: - UserDefaults

let mainUserDefault = UserDefaults.standard
func mainUserDeafultSave(block: (UserDefaults)->()) {
    let userD = UserDefaults.standard
    block(userD)
    userD.synchronize()
}

// 通知
func ydPOSTNotification(name: String, info: [String: Any]?) {
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: nil, userInfo: info)
}

func ydAddObserve(taget: Any, selector: Selector, name: String) {
    NotificationCenter.default.addObserver(taget, selector: selector, name: NSNotification.Name(rawValue: name), object: nil)
}

// 释放通知
func releaseNotification(target: AnyObject) {
    NotificationCenter.default.removeObserver(target)
}

func ydGetCurrentRootViewController()->(UIViewController) {
    var root: UIViewController!
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    root = appDelegate.window?.rootViewController!
    return root
}


// MARK: - log
func DDLOG<T>(message:T, file:String = #file, funcName:String = #function, lineNum:Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent;
    let curTime = Date().getCurrStrDate("yyyy-MM-dd HH:mm:SS.sss")
    print("[\(curTime)  name:\(fileName) line:\(lineNum)]:\n\(message)");
    #endif
}
