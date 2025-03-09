//
//  StartStatisticsModel.swift
//  StartTimeLine
//
//  Created by sto on 2024/10/13.
//

import KakaJSON
import SwiftyJSON
import UIKit

struct StartSubtotalSubModel: Convertible, Hashable {
    var platform: String?
    var platform_name: String?
    var quantity: Int?
}

struct StartSubtotalModel: Convertible, Hashable {
    var weibo: StartSubtotalSubModel?
    var douyin: StartSubtotalSubModel?
}

struct StartHourSubModel: Convertible, Hashable, Identifiable {
    let id = UUID()
    var hour: Int?
    var startTime: String?
    var endTime: String?
    var quantity: Int?
    var subtotal: Int?
    var scale: Double?

    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        return property.name.kj.underlineCased()
    }
}

struct StartHourModel: Convertible, Hashable {
    var weibo: [StartHourSubModel]?
    var douyin: [StartHourSubModel]?

    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        return property.name.kj.underlineCased()
    }
}

struct StartHistorySubModel: Convertible, Hashable {
    var platform: String?
    var platformName: String?
    var date: [String]?

    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        return property.name.kj.underlineCased()
    }
}

struct StartHistoryModel: Convertible, Hashable {
    var dates: [String]?
    var items: [StartHistorySubModel]?
}

struct StartStatisticsModel: Convertible, Hashable {
    var subtotal: StartSubtotalModel?
    var hour: StartHourModel?
    var history: StartHistoryModel?

    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        return property.name.kj.underlineCased()
    }
}
