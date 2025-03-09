//
//  UserPushModel.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/10/1.
//

import KakaJSON
import SwiftyJSON
import UIKit

struct UserPushModel: Convertible {
    let id: Int = 0
    let isSubscribe: Int = 0
    let isNotice: Int = 0
    let openOriginalWeibo: Int = 0
    let openRelayWeibo: Int = 0

    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        switch property.name {
        default: return property.name.kj.underlineCased()
        }
    }
}
