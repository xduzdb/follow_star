//
//  ContactModel.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/17.
//

import Foundation
import ObjectMapper

class ContactModel: Mappable {
    var url: String?

    func mapping(map: Map) {
        url <- map["url"]
    }
    
    required init?(map: Map) {
        // 检查JSON是否有name字段
        if map.JSON["url"] == nil {
            return nil
        }
    }
}
