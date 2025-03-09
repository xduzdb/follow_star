//
//  AboutUsData.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/17.
//

import Foundation
//import ObjectMapper

class AboutUsData: Mappable {
    var protocol_url: String?
    var intro: String?
    var policy_url: String?

    func mapping(map: Map) {
        protocol_url <- map["protocol_url"]
        intro <- map["intro"]
        policy_url <- map["policy_url"]
    }
    
    required init?(map: Map) {
        // 检查JSON是否有name字段
        if map.JSON["intro"] == nil {
            return nil
        }
    }
}
