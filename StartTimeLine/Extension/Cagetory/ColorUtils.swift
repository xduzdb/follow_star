//
//  ColorUtils.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/5.
//

import Foundation
import UIKit

/// RGBA的颜色设置
public func ColorRGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

/// 随机色
public func ColorRandom() -> UIColor {
    let red = CGFloat(arc4random_uniform(255)) / CGFloat(255.0)
    let green = CGFloat(arc4random_uniform(255)) / CGFloat(255.0)
    let blue = CGFloat(arc4random_uniform(255)) / CGFloat(255.0)
    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
}

/**
 *  16进制 转 RGB
 */
public func ColorHex(rgb: Int) -> UIColor {
    return UIColor(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                   green: CGFloat((rgb & 0xFF00) >> 8) / 255.0,
                   blue: CGFloat(rgb & 0xFF) / 255.0,
                   alpha: 1.0)
}

public func ColorHex(hexStr: String, alpha: CGFloat = 1.0) -> UIColor {
    var cString: String = hexStr.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    if cString.count < 6 {
        return UIColor.black
    }
    if cString.hasPrefix("0x") {
        cString = cString.replacingOccurrences(of: "0x", with: "")
    }
    if cString.hasPrefix("#") {
        cString = cString.replacingOccurrences(of: "#", with: "")
    }
    if cString.count != 6 {
        return UIColor.black
    }

    var range: NSRange = NSMakeRange(0, 2)
    let rString = (cString as NSString).substring(with: range)
    range.location = 2
    let gString = (cString as NSString).substring(with: range)
    range.location = 4
    let bString = (cString as NSString).substring(with: range)

    var r: UInt32 = 0x0
    var g: UInt32 = 0x0
    var b: UInt32 = 0x0
    Scanner(string: rString).scanHexInt32(&r)
    Scanner(string: gString).scanHexInt32(&g)
    Scanner(string: bString).scanHexInt32(&b)

    //        return UIColor(displayP3Red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
}

/// 由角度转换弧度 (M_PI * (x) / 180.0)
public func DegreesToRadian(degree: Double) -> Double {
    return Double.pi * degree / 180.0
}

/// 由弧度转换角度  (radian * 180.0) / (M_PI)
public func RadianToDegrees(radian: Double) -> Double {
    return radian * 180.0 / Double.pi
}

// MARK: ========= 字体适配 ==========

/// 适配后的普通字体(系统)
public func AdaptedSystomFont(size: Float) -> UIFont {
    return UIFont.systemFont(ofSize: CGFloat(AdaptedWidth(w: size)))
}

/// 适配后的粗字体(系统)
public func AdaptedSystomBlodFont(size: Float) -> UIFont {
    return UIFont.boldSystemFont(ofSize: CGFloat(AdaptedWidth(w: size)))
}

/// 字体名
public let CHINESE_FONT_NAME: String = "PingFangSC-Light"
public let CHINESE_BLODFONT_NAME: String = "PingFangSC-Regular"

/// 适配后的普通字体
public func AdaptedCustomFont(size: Float) -> UIFont {
    if let font = UIFont(name: CHINESE_FONT_NAME, size: CGFloat(AdaptedWidth(w: size))) {
        return font
    }
    return UIFont.systemFont(ofSize: CGFloat(size))
}

/// 适配后的粗字体
public func AdaptedCustomBlodFont(size: Float) -> UIFont {
    if let font = UIFont(name: CHINESE_BLODFONT_NAME, size: CGFloat(AdaptedWidth(w: size))) {
        return font
    }
    return UIFont.boldSystemFont(ofSize: CGFloat(size))
}

/// 适配后的宽度
public func AdaptedWidth(w: Float) -> Float {
    return ceilf(w * kScaleX)
}

extension UIColor {
    static func mainColor() -> UIColor {
        return ColorHex(hexStr: "#F05F49")
    }

    static func mainSecColor() -> UIColor {
        return ColorHex(hexStr: "#E84C4F")
    }

    static func alertBackColor() -> UIColor {
        return ColorHex(hexStr: "#F7F6FB")
    }
    
    static func alertWhiteColor() -> UIColor {
        return ColorHex(hexStr: "#FFFFFF")
    }

    static func text333Color() -> UIColor {
        return ColorHex(hexStr: "333333")
    }

    static func text666Color() -> UIColor {
        return ColorHex(hexStr: "666666")
    }

    static func text999Color() -> UIColor {
        return ColorHex(hexStr: "999999")
    }

    static func backColor() -> UIColor {
        return ColorHex(hexStr: "F7F6FB")
    }

    static func colorD9D9D9() -> UIColor {
        return ColorHex(hexStr: "D9D9D9")
    }
}
