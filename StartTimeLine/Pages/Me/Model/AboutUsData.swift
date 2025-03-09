//
//  AboutUsData.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/17.
//

import Foundation
import ObjectMapper

class AboutUsData: Mappable {
    var protocolUrl: String?
    var intro: String?
    var policyUrl: String?

    func mapping(map: Map) {
        protocolUrl <- map["protocol_url"]
        intro <- map["intro"]
        policyUrl <- map["policy_url"]
    }
    
    required init?(map: Map) {
        // 检查JSON是否有name字段
        if map.JSON["intro"] == nil {
            return nil
        }
    }
}
