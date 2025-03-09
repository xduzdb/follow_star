//
//  StartDynamicModel.swift
//  StartTimeLine
//
//  Created by sto on 2024/10/13.
//

/*
 {
 "platform": "douyin",
 "post_id": "7327869051043204404",
 "post_type": "video",
 "send_type": "original",
 "content": "2024#抖音新春直播季  官宣啦！ 一到8点就充满欢声笑语，晚8乐小区究竟有什么奥秘？1月25日-2月25日， 搜索【新春直播季】一起解锁新春寻乐之旅。#欢笑中国年",
 "images": [],
 "video": {5 items},
 "retweet": null,
 "send_at": "2024-01-25 11:15:08",
 "star": {22 items}
 }
 */
import KakaJSON
import SwiftyJSON
import UIKit
// 明显动态社交的图片的类型
struct StartDynamicSourceModel: Convertible, Hashable {
    var width: Int?
    var height: Int?
    var url: String?
    var title: String?
    var cover: String?

    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        switch property.name {
        default: return property.name.kj.underlineCased()
        }
    }
}

// 社交动态
struct StartSocialAccountModel: Convertible, Hashable {
    var platformNickname: Int?
    var platform: Int?
    var platformUserId: String?

    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        switch property.name {
        default: return property.name.kj.underlineCased()
        }
    }
}


// retweet 的信息、
struct StartDynamicRetweetModel: Convertible, Hashable {
    var postType: String?
    var content: String?
    var images: [StartDynamicSourceModel]?
    var user: StartUserModel?
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        return property.name.kj.underlineCased()
    }
}

struct StartDynamicModel: Convertible, Hashable {
    var platform: String?
    var postId: String?
    var postType: String?
    var sendType: String?
    var content: String?
    var images: [StartDynamicSourceModel]?
    var video: StartDynamicSourceModel?
    var sendAt: String?
    var star: StartUserModel?
    var retweet: StartDynamicRetweetModel?
    var socialAccount: StartSocialAccountModel?
    
    var bottomInfo: String {
        var platformStr: String?
        if platform == "douyin" {
            platformStr = "抖音"
        } else if platform == "weibo" {
            platformStr = "微博"
        }
        return "\(Date().getFormatHomeBottomTime(dateString: sendAt ?? ""))·\(platformStr ?? "")"
    }
    

    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        return property.name.kj.underlineCased()
    }
}
