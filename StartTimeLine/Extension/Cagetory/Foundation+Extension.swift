//
//  Foundation+Extension.swift
//  BestBuy-ios
//
//  Created by ice on 2020/4/14.
//  Copyright © 2020年 ice. All rights reserved.
//

import UIKit

extension UIApplication {}

public extension TimeInterval {
    // 把秒数转换成时间的字符串
    func convertString() -> String {
        // 把获取到的秒数转换成具体的时间
        let createDate = Date(timeIntervalSince1970: self)
        // 获取当前日历
        let calender = Calendar.current
        // 获取日期的年份
        let comps = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: createDate, to: Date())
        // 日期格式
        let formatter = DateFormatter()
        // 判断当前日期是否为今年
        guard createDate.isThisYear() else {
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return formatter.string(from: createDate)
        }
        // 是否是前天
        if createDate.isBeforeYesterday() {
            formatter.dateFormat = "前天 HH:mm"
            return formatter.string(from: createDate)
        } else if createDate.isToday() || createDate.isYesterday() {
            // 判断是否是今天或者昨天
            if comps.hour! >= 1 {
                return String(format: "%d小时前", comps.hour!)
            } else if comps.minute! >= 1 {
                return String(format: "%d分钟前", comps.minute!)
            } else {
                return "刚刚"
            }
        } else {
            formatter.dateFormat = "MM-dd HH:mm"
            return formatter.string(from: createDate)
        }
    }
}

public extension Int {
    func convertString() -> String {
        guard self >= 10000 else {
            return String(describing: self)
        }
        return String(format: "%.1f万", Float(self) / 10000.0)
    }

    /// 将秒数转成字符串
    func convertVideoDuration() -> String {
        // 格式化时间
        if self == 0 { return "00:00" }
        let hour = self / 3600
        let minute = (self / 60) % 60
        let second = self % 60
        if hour > 0 { return String(format: "%02d:%02d:%02d", hour, minute, second) }
        return String(format: "%02d:%02d", minute, second)
    }
}

public extension Date {
    /// 判断当前日期是否为今年
    func isThisYear() -> Bool {
        // 获取当前日历
        let calender = Calendar.current
        // 获取日期的年份
        let yearComps = calender.component(.year, from: self)
        // 获取现在的年份
        let nowComps = calender.component(.year, from: Date())

        return yearComps == nowComps
    }

    /// 是否是昨天
    func isYesterday() -> Bool {
        // 获取当前日历
        let calender = Calendar.current
        // 获取日期的年份
        let comps = calender.dateComponents([.year, .month, .day], from: self, to: Date())
        // 根据头条显示时间 ，我觉得可能有问题 如果comps.day == 0 显示相同，如果是 comps.day == 1 显示时间不同
        // 但是 comps.day == 1 才是昨天 comps.day == 2 是前天
        //        return comps.year == 0 && comps.month == 0 && comps.day == 1
        return comps.year == 0 && comps.month == 0 && comps.day == 0
    }

    /// 是否是前天
    func isBeforeYesterday() -> Bool {
        // 获取当前日历
        let calender = Calendar.current
        // 获取日期的年份
        let comps = calender.dateComponents([.year, .month, .day], from: self, to: Date())
        //
        //        return comps.year == 0 && comps.month == 0 && comps.day == 2
        return comps.year == 0 && comps.month == 0 && comps.day == 1
    }

    /// 判断是否是今天
    func isToday() -> Bool {
        // 日期格式化
        let formatter = DateFormatter()
        // 设置日期格式
        formatter.dateFormat = "yyyy-MM-dd"

        let dateStr = formatter.string(from: self)
        let nowStr = formatter.string(from: Date())
        return dateStr == nowStr
    }

    // 获取当前系统时间
    static func getCurrentDate() -> Date {
        let nowDate = Date()
        let zone = NSTimeZone.system
        let interval = zone.secondsFromGMT(for: nowDate)
        let localeDate = nowDate.addingTimeInterval(TimeInterval(interval))
        return localeDate
    }

    /// 获取当前 秒级 时间戳 - 10位
    var getSecondTimeStamp: String {
        let timeInterval: TimeInterval = timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }

    /// 获取当前 毫秒级 时间戳 - 13位
    var getMilliSecondStamp: String {
        let timeInterval: TimeInterval = timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval * 1000))
        return "\(millisecond)"
    }

    /// 获取两个时间戳的差值
    func getMillSecondStampTimeDifference(startStamp: String, endStamp: String) -> String {
        let endDeci = Int(endStamp) ?? 0
        let startDeci = Int(startStamp) ?? 0
        let difference = endDeci - startDeci
        if difference > 0 {
            return "\(difference)"
        }
        return "0"
    }

    // 计算时间差  endStamp  结束时间。  intervalTime 修正间隔 单位秒 默认 1小时
    func ydDateComponents(startStamp: String, intervalTime: Int = 60 * 60) -> Int {
        let curTime = getSecondTimeStamp
        let curDeci = NSDecimalNumber(string: curTime)
        let startDeci = NSDecimalNumber(string: startStamp)
        let intervalTimeDect = NSDecimalNumber(value: intervalTime)
        let resuleDeci = startDeci.subtracting(curDeci).adding(intervalTimeDect)
        return resuleDeci.intValue
    }

    // 获取当前的年月日
    static func getCurrentYearOrMouthOrDay(type: Calendar.Component) -> Int {
        let date = Date()
        let calendar = Calendar.current
        let time = calendar.component(type, from: date)
        return time
    }

    // 获取当前的 年月日的时间
    func getCurrentDateYearMouthDay() -> String {
        let curDate = Date.getCurrentDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateStr = formatter.string(from: curDate)
        return dateStr
    }

    // MARK: 将字符串转换为日期

    func getDateFromString(dateString: String, fomartStr: String = "yyyy-MM-dd HH:mm:ss") -> Date {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.dateFormat = fomartStr
        let date = formatter.date(from: dateString)
        return date!
    }

    // MARK: 将字符串转换为日期 返回时间戳

    func getDateStampFromString(dateString: String, fomartStr: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = fomartStr
        let date1 = formatter.date(from: dateString)
        if date1 != nil {
            return "\(dateToTimesp(aDate: date1!))"
        } else {
            return "0"
        }
    }

    // MARK: NSISO8601DateFormatter 格式化

    static func getISO8601DateFmtFromTimeStr(dateString: String, fomartStr: String = "yyyy-MM-dd HH:mm:ss") -> String {
        //        DDLOG(message: dateString)
        if dateString.isEmpty {
            return ""
        }
        let dataStr = (dateString as NSString).replacingOccurrences(of: "T", with: " ")
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = fmt.date(from: dataStr)

        let resultFormatter = DateFormatter()
        resultFormatter.dateFormat = fomartStr
        return resultFormatter.string(from: date!)
    }

    // MARK: 将字符串转换为date -> 时间戳

    func dateToTimesp(aDate: Date) -> Int {
        return Int(aDate.timeIntervalSince1970)
    }

    /*
     stringTime 时间为stirng
     返回时间戳为stirng
     */
    static func stringToTimeStamp(timeStamp: String, fomartStr: String = "yyyy-MM-dd HH:mm:ss") -> String {
        if timeStamp == "0" || timeStamp.isEmpty {
            return ""
        }
        let string = NSString(string: timeStamp)
        let timeSta: TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = fomartStr
        let date = NSDate(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: date as Date)
    }

    /// 根据日期类型返还当前的日期
    /// - Parameter fomartStr: 返回如期字符串类型：如：yyyy-MM-dd
    /// - Returns: 返回日期字符串 如 2020-08-27
    func getCurrStrDate(_ fomartStr: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let currTime = NSString(string: getSecondTimeStamp)
        let timeSta: TimeInterval = currTime.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = fomartStr
        let date = NSDate(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: date as Date)
    }

    /// 获取2个时间的时间差 返回间隔天数
    func daysBetweenDate(oldDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: oldDate, to: Date().getDateFromString(dateString: Date().getCurrentDateYearMouthDay(), fomartStr: "yyyy-MM-dd"))
        return components.day ?? 0
    }

    /// 秒换成00:00:00格式
    ///
    /// - Parameter secounds: 秒数
    /// - Returns: 时间字符串
    func getFormatPlayTime(secounds: TimeInterval) -> String {
        if secounds.isNaN {
            return "00:00:00"
        }
        var Min = Int(secounds / 60)
        let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
        var Hour = 0
        if Min >= 60 {
            Hour = Int(Min / 60)
            Min = Min - Hour * 60
            return String(format: "%02d:%02d:%02d", Hour, Min, Sec)
        }
        return String(format: "00:%02d:%02d", Min, Sec)
    }

    // 转为
    func getFormatHomeBottomTime(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        // 将字符串转换为日期
        guard let date = dateFormatter.date(from: dateString) else {
            return ""
        }

        // 获取当前日期
        let now = Date()

        // 使用日历计算日期差异
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month], from: date, to: now)

        // 根据日期差异返回相应的字符串
        if let months = components.month, months > 0 {
            return months == 1 ? "1个月前" : "\(months)个月前"
        } else if let days = components.day {
            switch days {
            case 0:
                return "今天"
            case 1:
                return "昨天"
            case 2:
                return "前天"
            default:
                return "\(days)天前"
            }
        }

        return ""
    }
}
