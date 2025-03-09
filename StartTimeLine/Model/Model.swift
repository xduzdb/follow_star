//
//  Model.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/8/3.
//
import Combine
import SwiftUI

class Model: ObservableObject {
    @Published var showDetails: Bool = false
    @Published var isTabBarHidden: Bool = false
    @Published var appLoginState: Bool = false

    // 获取当前的用户信息
    @Published var userInfo: UserInfo? = UserSharedManger.shared.getCurrentUserInfo()

    @Published var startSid: String {
        didSet {
            // 当 startSid 更新时，保存到 UserDefaults
            UserDefaults.standard.set(startSid, forKey: "startSid")
        }
    }

    init() {
        // 从 UserDefaults 加载数据
        startSid = UserDefaults.standard.string(forKey: "startSid") ?? ""
    }

    func logout() {
        appLoginState = false
        UserDefaults.standard.set(false, forKey: "isLogin")
        // 清除 用户缓存
    }
}
