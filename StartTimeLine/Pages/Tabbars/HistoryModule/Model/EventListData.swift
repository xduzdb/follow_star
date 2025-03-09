//
//  EventListData.swift
//  StartTimeLine
//
//  Created by 张家和 on 2024/10/5.
//

import UIKit
import ObjectMapper

class EventListData: Mappable {
    
    var text: String?
    var likeCount: Int?
    var isLike: Bool?

    func mapping(map: Map) {
        text <- map["text"]
        likeCount <- map["likes_count"]
        isLike <- map["is_like"]
    }
    
    required init?(map: Map) {
        // 检查JSON是否有name字段
        if map.JSON["text"] == nil {
            return nil
        }
    }

    

}
