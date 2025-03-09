//
//  UserInfo.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/7.
//

import Foundation
import ObjectMapper

class UserInfo: Mappable, ObservableObject {
    var username: String?
    var nickname: String?
    var avatar: String?
    var iac: String?
    var phone: String?
    var email: String?
    var status: Int?
    var updatedUsernameAt: String?
    var createdAt: String?

    func mapping(map: Map) {
        username <- map["username"]
        nickname <- map["nickname"]
        avatar <- map["avatar"]
        iac <- map["iac"]
        phone <- map["phone"]
        email <- map["email"]
        status <- map["status"]
        updatedUsernameAt <- map["updated_username_at"]
        createdAt <- map["created_at"]
    }

    required init?(map: Map) {
        // 检查JSON是否有name字段
        if map.JSON["username"] == nil {
            return nil
        }
    }
}
