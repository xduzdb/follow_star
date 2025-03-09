//
//  UserSharedManger.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/7.
//

/// 用户管理的单例
import Foundation

class UserSharedManger {
    // 创建一个单例
    static let shared = UserSharedManger()

    // 用户的model
    var userInfo: UserInfo?
    
    // 用户的token

    private init() {}

    var isLogin: Bool {
        let token = self.getUserToken()
        return token?.count ?? 0 > 0
    }

    func saveUserToken(token: String?) {
        // 存储token
        UserDefaults.standard.set(token ?? "", forKey: kUserInfoToken)
        UserDefaults.standard.synchronize()
    }

    func getUserToken() -> String? {
        // 存储token
        return UserDefaults.standard.object(forKey: kUserInfoToken) as? String
    }

    func savaUserInfo(data: [String: Any]) {
        // 存储用户信息
        let str = ydDicValueString(data)
        UserDefaults.standard.set(str, forKey: kUserInfoKey)
        UserDefaults.standard.synchronize()
        let userInfo = UserInfo(JSON: data)
        // 给UserInfo.shared 赋值
        if let userData = userInfo {
            self.userInfo = userData
            return
        }
    }

    // 先获取本地的 然后根据启动获取最新的
    func getCurrentUserInfo() -> UserInfo? {
        if !self.isLogin {
            if (self.userInfo) != nil {
                return self.userInfo
            }
            return nil
        }
        let str = UserDefaults.standard.object(forKey: kUserInfoKey)
        let userInfo = UserInfo(JSON: ydStringValueDic(str as! String) ?? [:])
        self.userInfo = userInfo
        return userInfo
    }

    // 刷新用户的信息
    func updateUserInfo(resultClouse: ((UserInfo?, _ msg: String?) -> Void)? = nil) {
        // 每次在app启动的时候获取到最新的app信息
        if !self.isLogin {
            resultClouse?(nil, nil)
            return
        }
        // 获取最新的用户信息
        NetWorkManager.ydNetWorkRequest(.getUserInfo) { model in
            if model.status == NetStatus.success {
                let data = model.data
                if let userInfo = data {
                    let info = UserInfo(JSON: userInfo)
                    self.savaUserInfo(data: userInfo)
                    resultClouse?(info, model.msg)
                    return
                }
            }
            resultClouse?(nil, model.msg)
        }
    }

    // 只是更新用户信息
    func updatelocalUserData(name: String, avator: String) {
        self.userInfo?.nickname = name
        self.userInfo?.avatar = avator
        let info = self.userInfo?.toJSON()
        if let info {
            self.savaUserInfo(data: info)
        }
    }

    // 登录同步信息到User
    func syncUserData() {
        let data = UserDefaults.standard.object(forKey: kUserInfoKey) ?? ""
        let dict = ydStringValueDic(data as! String)

        if let value = dict {
            let userInfo = UserInfo(JSON: value)
            if let userData = userInfo {
                self.userInfo = userData
                return
            }
        }
    }

    // 清空用户信息
    func clearUserData() {
        UserDefaults.standard.setValue(nil, forKey: kUserInfoKey)
        UserDefaults.standard.setValue(nil, forKey: kUserInfoToken)
        UserSharedManger.shared.userInfo = nil
        // 登出完成
        ydPOSTNotification(name: "LoginOrLoginOut", info: ["isLoginFinish": "0"])
    }
}
