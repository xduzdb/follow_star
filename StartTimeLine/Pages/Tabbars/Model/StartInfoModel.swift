//
//  StartInfoModel.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/8.
//

import ObjectMapper

/*
 {
     "sid": "66daa30c0002876b74c1",
     "name": "霉霉",
     "avatar": "http://127.0.0.1:2500/static/images/default-avatar.jpg",
     "sex": 2,
     "birthday": "1989-12-13",
     "subscription": 0,
     "status": 2,
     "last_post_at": null,
     "intro": null,
     "real_name": "",
     "nation": "",
     "nationality": "",
     "birthplace": "",
     "school": "",
     "constellation": "",
     "height": "",
     "weight": "",
     "blood": "",
     "company": "",
     "masterpiece": "",
     "career": "",
     "awards": "",
     "default_cover_url": ""
 }
 */
class StartInfoModel: Mappable {
    var name: String?
    var sid: String?
    var defaultCoverUrl: String?
    var avatar: String?
    var sex: Int?
    var subscription: String?
    var birthday: String?
    var status: Int?
    var realName: String?
    var nation: String?
    var nationality: String?
    var birthplace: String?
    var school: String?
    var constellation: String?
    var height: String?
    var weight: String?
    var blood: String?
    var company: String?
    var masterpiece: String?
    var career: String?
    var awards: String?
    
    func mapping(map: Map) {
        name <- map["name"]
        sid <- map["sid"]
        defaultCoverUrl <- map["default_cover_url"]
        avatar <- map["avatar"]
        sex <- map["sex"]
        birthday <- map["birthday"]
        status <- map["status"]
        nation <- map["nation"]
        nationality <- map["nationality"]
        birthplace <- map["birthplace"]
        school <- map["school"]
        constellation <- map["constellation"]
        height <- map["height"]
        weight <- map["weight"]
        blood <- map["blood"]
        company <- map["company"]
        masterpiece <- map["masterpiece"]
        career <- map["career"]
        awards <- map["awards"]
    }
    
    required init?(map: Map) {
        // 检查JSON是否有name字段
        if map.JSON["name"] == nil {
            return nil
        }
    }
}
