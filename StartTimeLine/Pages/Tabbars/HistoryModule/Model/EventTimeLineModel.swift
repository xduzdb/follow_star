//
//  EventTimeLineModel.swift
//  StartTimeLine
//
//  Created by Lushitong on 2024/12/27.
//

import KakaJSON
import SwiftyJSON
import UIKit

/*
 {
 "year": 2022,
 "count": 1,
 "list": [
 {
 "id": 29,
 "date": "2022-10-23T16:00:00.000000Z",
 "activity_id": 13,
 "text": "2022年的今天，主演的莲花楼在杀青，你还记得不？",
 "created_at": "2024-09-02T09:10:44.000000Z",
 "updated_at": "2024-09-02T09:10:44.000000Z"
 }
 ]
 }
 */

struct EventTimeLineDetailsModel: Convertible, Hashable,Identifiable {
    var id: String?
    var date: String?
    var activityId: Int?
    var classifyId: Int?
    var text: String?
    var createdAt: String?
    var updatedAt: String?
    var author: String?
    
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        return property.name.kj.underlineCased()
    }
}

struct EventTimeLineModel: Convertible, Hashable, Identifiable {
    let id = UUID()
    var year: Int?
    var count: Int?
    var list: [EventTimeLineDetailsModel]?

    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        return property.name.kj.underlineCased()
    }
}

