//
//  Model.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/8/3.
//
import Combine
import SwiftUI

class Model: ObservableObject {
    static let shared = Model() // 添加单例
    
    @Published var showDetails: Bool = false
    @Published var isTabBarHidden: Bool = false
    @Published var appLoginState: Bool = false

    // 当前用户信息
    @Published var currentStartDetailModel: StartUserModel? {
        willSet {
            objectWillChange.send()
        }
        didSet {
            print("Model: currentStartDetailModel updated")
        }
    }
    
    @Published var token: String? {
        willSet {
            objectWillChange.send()
        }
        didSet {}
    }
    
    // 背景的URL
    @Published var coverUlr: String? {
        willSet {
            objectWillChange.send()
        }
        didSet {}
    }
    
    // 获取当前的用户信息
    @Published var userInfo: UserInfo? {
        willSet {
            objectWillChange.send()
        }
        didSet {
            print("Model: userInfo updated")
        }
    }
    
    @Published var feedBackModel: FeebBackModel? {
        willSet {
            objectWillChange.send()
        }
        didSet {
            print("Model: feedBackModel updated")
        }
    }

    @Published var startSid: String {
        didSet {
            // 当 startSid 更新时，保存到 UserDefaults
            UserDefaults.standard.set(startSid, forKey: kUserStartid)
            print("startSid has changed to: \(startSid)")
        }
    }
    
    init() {
        // 从 UserDefaults 加载数据
        startSid = UserDefaults.standard.string(forKey: kUserStartid) ?? ""
        userInfo = UserSharedManger.shared.getCurrentUserInfo()
        token = UserDefaults.standard.string(forKey: kUserInfoToken) ?? ""
        currentStartDetailModel = getCurrentStartInfo()
    }

    func logout() {
        startSid = ""
        appLoginState = false
        UserDefaults.standard.set(false, forKey: "isLogin")
        UserDefaults.standard.set("", forKey: kSubCurrentStartKey)
        UserDefaults.standard.set("", forKey: kUserStartid)
        UserDefaults.standard.set("", forKey: kUserInfoToken)
    }
    
    // 保存当前的明星信息
    func savaCurrentStartInfo(data: [String: Any]) {
        // 存储用户信息
        let str = ydDicValueString(data)
        UserDefaults.standard.set(str, forKey: kSubCurrentStartKey)
        UserDefaults.standard.synchronize()
    }
    
    // 获取当前的信息
    func getCurrentStartInfo() -> StartUserModel? {
        if let str = UserDefaults.standard.object(forKey: kSubCurrentStartKey) as? String {
            if let dataDictionary = ydStringValueDic(str) {
                let data = dataDictionary.kj.model(StartUserModel.self)
                return data
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
