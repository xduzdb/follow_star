//
//  ConstString.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/7.
//

import Foundation
import UIKit

let ScreenScale: CGFloat = UIScreen.mainScale

let PortraitScreenWidth: CGFloat = min(UIScreen.mainWidth, UIScreen.mainHeight)
let PortraitScreenHeight: CGFloat = max(UIScreen.mainWidth, UIScreen.mainHeight)
let PortraitScreenSize: CGSize = CGSize(width: PortraitScreenWidth, height: PortraitScreenHeight)
let PortraitScreenBounds: CGRect = CGRect(origin: .zero, size: PortraitScreenSize)

let LandscapeScreenWidth: CGFloat = PortraitScreenHeight
let LandscapeScreenHeight: CGFloat = PortraitScreenWidth
let LandscapeScreenSize: CGSize = CGSize(width: LandscapeScreenWidth, height: LandscapeScreenHeight)
let LandscapeScreenBounds: CGRect = CGRect(origin: .zero, size: LandscapeScreenSize)

let IsBangsScreen: Bool = PortraitScreenHeight > 736.0

let BasisWScale: CGFloat = PortraitScreenWidth / 375.0
let BasisHScale: CGFloat = PortraitScreenHeight / 667.0

let Months: [String] = ["01", "02", "03", "04", "04", "06", "07", "08", "09", "10", "11", "12"]
let ShotMonths: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

let Weekdays: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
let ShotWeekdays: [String] = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]

let DefaultSmallImage: UIImage = #imageLiteral(resourceName: "default_train_medium")
let DefaultMediumImage: UIImage = #imageLiteral(resourceName: "default_train_medium")
let DefaultLargeImage: UIImage = #imageLiteral(resourceName: "default_train_medium")

let AppGroupIdentifier: String = "group.time.StartTime"
let StartDataKey = "startDataKey"

let SmallDataKey: String = "smallData"
let MediumDataKey: String = "mediumData"
let LargeDataKey: String = "largeData"

let HitokotoURL: String = "https://v1.hitokoto.cn"
let RandomImageURL: (CGSize) -> String = {
    "https://picsum.photos/\(Int($0.width))/\(Int($0.height))?random=\(arc4random_uniform(10000))"
}

let kUserInfoToken = "kUserInfoToken"

// 用户信息key
let kUserInfoKey = "kUserInfoKey1"

struct JP<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

protocol JPCompatible {}
extension JPCompatible {
    static var jp: JP<Self>.Type {
        set {}
        get { JP<Self>.self }
    }

    var jp: JP<Self> {
        set {}
        get { JP(self) }
    }
}
