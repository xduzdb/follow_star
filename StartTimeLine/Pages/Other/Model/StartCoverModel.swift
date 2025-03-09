//
//  StartCoverModel.swift
//  StartTimeLine
//
//  Created by sto on 2024/10/11.
//

import KakaJSON
import SwiftyJSON
import UIKit
/*
 {
 "id": 17,
 "type": 1,
 "status": 1,
 "is_select": 0,
 "url": "http://127.0.0.1:2500/static/attachment/cover/202409/0416/3f1a1btgq3m1urdtcu.jpg",
 "thumb": "http://127.0.0.1:2500/static/attachment/cover/202409/0416/3f1a1btgq3m1urdtcu.jpg"
 }
 */
struct StartCoverModel: Convertible, Hashable {
    var id: Int?
    var type: Int?
    var status: Int?
    var isSelect: Int?
    var url: String?
    var thumb: String?

    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        switch property.name {
        default: return property.name.kj.underlineCased()
        }
    }
}

struct StartCustomCoverInfo: Convertible, Hashable {
    var globals: [StartCoverModel]?
    var stars: [StartCoverModel]?
    var owns: [StartCoverModel]?

    var combinedModels: [StartCoverModel] {
        let combined = (globals ?? []) + (stars ?? [])
        return combined
    }
    
    var allCombinedModels: [StartCoverModel] {
        let combined = (globals ?? []) + (stars ?? []) + (owns ?? [])
        return combined
    }
    
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        return property.name.kj.underlineCased() // 简化
    }
}
