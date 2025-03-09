//
//  STColor.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/8/4.
//

import Foundation
import SwiftUI

public extension Color {
    static func hex(_ hex: String) -> Self {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = .init(utf16Offset: 0, in: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xFF0000) >> 16
        let g = (rgbValue & 0xFF00) >> 8
        let b = rgbValue & 0xFF

        return Self(
            red: Double(r) / 0xFF,
            green: Double(g) / 0xFF,
            blue: Double(b) / 0xFF,
            opacity: 1
        )
    }

    static func tabBarBackColor() -> Self {
        return Color.hex("0C0C21")
    }

    static func mainBackColor() -> Self {
        return Color.hex("F7F6FB")
    }

    static func startBackColor() -> Self {
        return Color.hex("E84C4F")
    }

    static func endBackColor() -> Self {
        return Color.hex("FF7E3F")
    }

    // 使用的范围 顶部的颜色
    static func color333333() -> Self {
        return Color.hex("333333")
    }

    static func color666666() -> Self {
        return Color.hex("666666")
    }

    static func color999999() -> Self {
        return Color.hex("999999")
    }

    static func colorF5F5F5() -> Self {
        return Color.hex("F5F5F5")
    }

    static func colorEEEEEE() -> Self {
        return Color.hex("EEEEEE")
    }

    static func color5F4925() -> Self {
        return Color.hex("5F4925")
    }

    static func colorF4DEBE() -> Self {
        return Color.hex("F4DEBE")
    }

    static func color4E5969() -> Self {
        return Color.hex("4E5969")
    }

    static func colorFFF7E8() -> Self {
        return Color.hex("FFF7E8")
    }

    static func colorFF7D00() -> Self {
        return Color.hex("FF7D00")
    }

    static func color1D2129() -> Self {
        return Color.hex("1D2129")
    }

    static func colorF05F49() -> Self {
        return Color.hex("F05F49")
    }

    // 联系客服的渐变
    static func oneColors() -> Self {
        return Color.hex("FFF1EF")
    }

    static func twoColors() -> Self {
        return Color.hex("FFE6DE")
    }

    static func threeColors() -> Self {
        return Color.hex("F9DED5")
    }

    static func colorF8F8F8() -> Self {
        return Color.hex("F8F8F8")
    }

    // widget开始的渐变
    static func startWidgetLinear() -> Self {
        return Color.hex("272221")
    }

    static func endWidgetLinear() -> Self {
        return Color.hex("574C49")
    }
}
