import Foundation
import SwiftyJSON
import UIKit

public extension String {
//    func urlEncode() -> NSString? {
//        let KUrlCodingReservedCharacters = "!*'();|@&=+$,-?%#[]{}"
//        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: KUrlCodingReservedCharacters).inverted)! as NSString
//    }
//    /// url解码
//    ///
//    /// - Returns: NSString
//    func urlDecode() -> NSString? {
//        return self.removingPercentEncoding as NSString?
//    }
    // 字典数组转 string  去除 \n
    static func getStringFromOBJ(obj: Any) -> String? {
        let json = JSON(obj)
        let str = json.rawString([writingOptionsKeys.castNilToNSNull: true])
        return str
    }

    // 去除左右的空格
    func clearSpace() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension String {
    static func yd_isEmpty(str: String?) -> Bool {
        if let str1 = str, str1.count != 0 {
            return false
        } else {
            return true
        }
    }

    func subString(start: Int, end: Int) -> String {
        let startI = index(startIndex, offsetBy: start)
        let endI = index(startIndex, offsetBy: end)
        return String(self[startI ..< endI])
    }

    func urlEncode() -> String? {
        let KUrlCodingReservedCharacters = "!*'();|@&=+$,-?%#[]{}/:"
        return addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: KUrlCodingReservedCharacters).inverted)!
    }

    /// url解码
    ///
    /// - Returns: NSString
    func urlDecode() -> String? {
        return removingPercentEncoding as String?
    }

    // 验证手机号格式是否正确
    func isMobelNumber() -> Bool {
        let MOBILE = "^1[3456789]\\d{9}$"

        let regextestmobiel = NSPredicate(format: "SELF MATCHES %@", MOBILE)

        if regextestmobiel.evaluate(with: self) == true {
            return true
        } else {
            return false
        }
    }

    /// 密码匹配6-20 数字 或字母
    func isRegularPwd() -> Bool {
        let pattern = "^[a-zA-Z0-9]{6,20}"
        let regextestPwd = NSPredicate(format: "SELF MATCHES %@", pattern)
        if regextestPwd.evaluate(with: self) == true {
            return true
        } else {
            return false
        }
    }

    /// 匹配不包含特殊字符的字符串(用户名, 地址)
    func isRegularUserName() -> Bool {
        let pattern = "[^a-zA-Z0-9\u{4e00}-\u{9fa5}]"
        let regextestPwd = NSPredicate(format: "SELF MATCHES %@", pattern)
        if regextestPwd.evaluate(with: self) == true {
            return true
        } else {
            return false
        }
    }

    // 输入框输入过滤特殊字符
    func deleteSpecialCharacters() -> String {
        let pattern: String = "[^a-zA-Z0-9\u{4e00}-\u{9fa5}]"
        let express = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        return express.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, count), withTemplate: "")
    }

    func replaceCharactersNSRange(range: NSRange, str: String) -> String {
        if let range = toRange(range) {
            return replacingCharacters(in: range, with: str)
        } else {
            return ""
        }
    }

    func toNSRange(_ range: Range<String.Index>) -> NSRange {
        guard let from = range.lowerBound.samePosition(in: utf16), let to = range.upperBound.samePosition(in: utf16) else {
            return NSMakeRange(0, 0)
        }
        return NSMakeRange(utf16.distance(from: utf16.startIndex, to: from), utf16.distance(from: from, to: to))
    }

    func toRange(_ range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }

    // 输入金额正则
    func amountEnterVerify() -> Bool {
        let pattern = "(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,8}(([.]\\d{0,2})?)))?"

        let regextest = NSPredicate(format: "SELF MATCHES %@", pattern)

        if regextest.evaluate(with: self) == true {
            return true
        } else {
            return false
        }
    }

    // 身份证号验证
    func isTrueUserIDNumber() -> Bool {
        var value = self
        value = value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        var length: Int = 0

        length = value.count

        if length != 15 && length != 18 {
            // 不满足15位和18位，即身份证错误
            return false
        }

        // 省份代码
        let areasArray = ["11", "12", "13", "14", "15", "21", "22", "23", "31", "32", "33", "34", "35", "36", "37", "41", "42", "43", "44", "45", "46", "50", "51", "52", "53", "54", "61", "62", "63", "64", "65", "71", "81", "82", "91"]

        // 检测省份身份行政区代码
        let index = value.index(value.startIndex, offsetBy: 2)
        let valueStart2 = value.substring(to: index)

        // 标识省份代码是否正确
        var areaFlag = false

        for areaCode in areasArray {
            if areaCode == valueStart2 {
                areaFlag = true
                break
            }
        }

        if !areaFlag {
            return false
        }

        var regularExpression: NSRegularExpression?

        var numberofMatch: Int?

        var year = 0

        switch length {
        case 15:

            // 获取年份对应的数字
            let valueNSStr = value as NSString

            let yearStr = valueNSStr.substring(with: NSRange(location: 6, length: 2)) as NSString

            year = yearStr.integerValue + 1900

            if year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) {
                // 创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
                // 测试出生日期的合法性
                regularExpression = try! NSRegularExpression(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: NSRegularExpression.Options.caseInsensitive)
            } else {
                // 测试出生日期的合法性
                regularExpression = try! NSRegularExpression(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: NSRegularExpression.Options.caseInsensitive)
            }

            numberofMatch = regularExpression?.numberOfMatches(in: value, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: value.count))

            if numberofMatch! > 0 {
                return true
            } else {
                return false
            }

        case 18:

            let valueNSStr = value as NSString

            let yearStr = valueNSStr.substring(with: NSRange(location: 6, length: 4)) as NSString

            year = yearStr.integerValue

            if year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) {
                // 测试出生日期的合法性
                regularExpression = try! NSRegularExpression(pattern: "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$", options: NSRegularExpression.Options.caseInsensitive)

            } else {
                // 测试出生日期的合法性
                regularExpression = try! NSRegularExpression(pattern: "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$", options: NSRegularExpression.Options.caseInsensitive)
            }

            numberofMatch = regularExpression?.numberOfMatches(in: value, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: value.count))

            if numberofMatch! > 0 {
                let a = getStringByRangeIntValue(Str: valueNSStr, location: 0, length: 1) * 7

                let b = getStringByRangeIntValue(Str: valueNSStr, location: 10, length: 1) * 7

                let c = getStringByRangeIntValue(Str: valueNSStr, location: 1, length: 1) * 9

                let d = getStringByRangeIntValue(Str: valueNSStr, location: 11, length: 1) * 9

                let e = getStringByRangeIntValue(Str: valueNSStr, location: 2, length: 1) * 10

                let f = getStringByRangeIntValue(Str: valueNSStr, location: 12, length: 1) * 10

                let g = getStringByRangeIntValue(Str: valueNSStr, location: 3, length: 1) * 5

                let h = getStringByRangeIntValue(Str: valueNSStr, location: 13, length: 1) * 5

                let i = getStringByRangeIntValue(Str: valueNSStr, location: 4, length: 1) * 8

                let j = getStringByRangeIntValue(Str: valueNSStr, location: 14, length: 1) * 8

                let k = getStringByRangeIntValue(Str: valueNSStr, location: 5, length: 1) * 4

                let l = getStringByRangeIntValue(Str: valueNSStr, location: 15, length: 1) * 4

                let m = getStringByRangeIntValue(Str: valueNSStr, location: 6, length: 1) * 2

                let n = getStringByRangeIntValue(Str: valueNSStr, location: 16, length: 1) * 2

                let o = getStringByRangeIntValue(Str: valueNSStr, location: 7, length: 1) * 1

                let p = getStringByRangeIntValue(Str: valueNSStr, location: 8, length: 1) * 6

                let q = getStringByRangeIntValue(Str: valueNSStr, location: 9, length: 1) * 3

                let S = a + b + c + d + e + f + g + h + i + j + k + l + m + n + o + p + q

                let Y = S % 11

                var M = "F"

                let JYM = "10X98765432"

                M = (JYM as NSString).substring(with: NSRange(location: Y, length: 1))

                let lastStr = valueNSStr.substring(with: NSRange(location: 17, length: 1))

                if lastStr == "x" {
                    if M == "X" {
                        return true
                    } else {
                        return false
                    }
                } else {
                    if M == lastStr {
                        return true
                    } else {
                        return false
                    }
                }
            } else {
                return false
            }

        default:
            return false
        }
    }

    func getStringByRangeIntValue(Str: NSString, location: Int, length: Int) -> Int {
        let a = Str.substring(with: NSRange(location: location, length: length))

        let intValue = (a as NSString).integerValue

        return intValue
    }

    ///  验证银行卡号
    ///
    /// - Note: 必须是数字字符串
    /// - returns: Bool
    func checkBankCardNumber() -> Bool {
        let cardNumber: String = self

        var oddSum: Int = 0 // 奇数和
        var evenSum: Int = 0 // 偶数和
        var allSum: Int = 0 // 总和
        // 循环加和
        for i in 1 ... (cardNumber.count) {
            let theNumber = (cardNumber as NSString?)?.substring(with: NSRange(location: (cardNumber.count) - i, length: 1))
            var lastNumber = Int(theNumber!) ?? 0

            if i % 2 == 0 {
                // 偶数位
                lastNumber *= 2
                if lastNumber > 9 {
                    lastNumber -= 9
                }
                evenSum += lastNumber
            } else {
                // 奇数位
                oddSum += lastNumber
            }
        }
        allSum = oddSum + evenSum
        // 是否合法
        if allSum % 10 == 0 {
            return true
        } else {
            return false
        }
    }

    /*
     *去掉首尾空格
     */
    var removeHeadAndTailSpace: String {
        let whitespace = NSCharacterSet.whitespaces
        return trimmingCharacters(in: whitespace)
    }

    /*
     *去掉首尾空格 包括后面的换行 \n
     */
    var removeHeadAndTailSpacePro: String {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        return trimmingCharacters(in: whitespace)
    }

    /*
     *去掉所有空格
     */
    var removeAllSapce: String {
        return replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }

    /*
     *去掉首尾空格 后 指定开头空格数
     */
    func beginSpaceNum(num: Int) -> String {
        var beginSpace = ""
        for _ in 0 ..< num {
            beginSpace += " "
        }
        return beginSpace + removeHeadAndTailSpacePro
    }
}

/**
 样例
 func getNormalStrH(str: String, strFont: CGFloat, w: CGFloat) -> CGFloat {
 return NSString.getNormalStrSize(str: str, font: strFont, w: w, h: CGFloat.greatestFiniteMagnitude).height
 }

 */
