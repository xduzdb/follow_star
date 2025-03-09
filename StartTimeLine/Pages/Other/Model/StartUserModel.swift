//
//  StartSearchModel.swift
//  StartTimeLine
//
//  Created by sto on 2024/10/9.
//

/*
 {
 "sid": "65d56b790002844b863e", //明星 SID
 "name": "王弘毅", //明星名字
 "avatar": "http://127.0.0.1:2500/static/images/default-avatar.jpg", //头像地址
 "sex": 1, //性别，1男性，2女性
 "birthday": "1999-03-24", //出生日期
 "subscription": 0, //订阅人数
 "status": 1,
 "last_update_at": "2024-02-21 11:18:17", //明星数据最后更新时间
 "is_subscribed": false, //当前账号是否已订阅该明星（仅登录状态有此字段）
 "subscribe": null

 }
 */

import KakaJSON
import SwiftyJSON
import UIKit

struct StartCover: Convertible, Hashable {
    var status: String?
    var url: String?

    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        switch property.name {
        default: return property.name.kj.underlineCased()
        }
    }
}

struct StartUserModel: Convertible, Hashable {
    var sid: String?
    var name: String?
    var nickname: String?
    var avatar: String?
    var sex: Int?
    var status: Int?
    var birthday: String?
    var subscription: String?
    var lastUpdateAt: String?
    var isSubscribed: Bool?
    var subscribe: Int?
    var cover: StartCover?

    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        switch property.name {
        case "cover": return "cover"
        default: return property.name.kj.underlineCased()
        }
    }
}
