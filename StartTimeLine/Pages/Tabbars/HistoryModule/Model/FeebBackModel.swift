//
//  FeebBackModel.swift
//  StartTimeLine
//
//  Created by Lushitong on 2024/12/27.
//
import KakaJSON
import SwiftyJSON
import UIKit

struct FeebBackModel: Convertible, Hashable {
    var androidWidget: String?
    var iosWidget: String?
    var feedback: String?
    
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        return property.name.kj.underlineCased()
    }
}
