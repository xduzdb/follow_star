//
//  EventListData.swift
//  StartTimeLine
//
//  Created by 张家和 on 2024/10/5.
//

import KakaJSON
import SwiftyJSON
import UIKit

struct EventListDetailsData: Convertible, Hashable {
    var id: String?
    var date: String?
    var activityId: Int?
    var classifyId: Int?
    var timelineType: String?
    var text: String?
    var createdAt: String?
    var updatedAt: String?
    var comment: String?
    var isLike: Bool?
    var likesCount: Int?
    
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        return property.name.kj.underlineCased()
    }
}

struct EventListData: Convertible, Hashable, Identifiable {
    let id = UUID()
    var lunarDate: String?
    var solarDate: String?
    var list: [EventListDetailsData]?

    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        return property.name.kj.underlineCased()
    }
}
