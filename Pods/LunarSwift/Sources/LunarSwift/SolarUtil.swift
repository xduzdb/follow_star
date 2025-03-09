import Foundation

@objcMembers
public class SolarUtil {
    public static var WEEK: [String] = ["日", "一", "二", "三", "四", "五", "六"]
    public static var DAYS_OF_MONTH: [Int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    public static var XING_ZUO: [String] = ["白羊", "金牛", "双子", "巨蟹", "狮子", "处女", "天秤", "天蝎", "射手", "摩羯", "水瓶", "双鱼"]
    public static var FESTIVAL: [String: String] = [
        "1-1": "元旦节",
        "2-14": "情人节",
        "3-8": "妇女节",
        "3-12": "植树节",
        "3-15": "消费者权益日",
        "4-1": "愚人节",
        "5-1": "劳动节",
        "5-4": "青年节",
        "6-1": "儿童节",
        "7-1": "建党节",
        "8-1": "建军节",
        "9-10": "教师节",
        "10-1": "国庆节",
        "10-31": "万圣节前夜",
        "11-1": "万圣节",
        "12-24": "平安夜",
        "12-25": "圣诞节",
    ]
    public static var WEEK_FESTIVAL: [String: String] = [
        "3-0-1": "全国中小学生安全教育日",
        "5-2-0": "母亲节",
        "5-3-0": "全国助残日",
        "6-3-0": "父亲节",
        "9-3-6": "全民国防教育日",
        "10-1-1": "世界住房日",
        "11-4-4": "感恩节",
    ]
    public static var OTHER_FESTIVAL: [String: [String]] = [
        "1-8": ["周恩来逝世纪念日"],
        "1-10": ["中国人民警察节"],
        "1-14": ["日记情人节"],
        "1-21": ["列宁逝世纪念日"],
        "1-26": ["国际海关日"],
        "1-27": ["国际大屠杀纪念日"],
        "2-2": ["世界湿地日"],
        "2-4": ["世界抗癌日"],
        "2-7": ["京汉铁路罢工纪念日"],
        "2-10": ["国际气象节"],
        "2-19": ["邓小平逝世纪念日"],
        "2-20": ["世界社会公正日"],
        "2-21": ["国际母语日"],
        "2-24": ["第三世界青年日"],
        "3-1": ["国际海豹日"],
        "3-3": ["世界野生动植物日", "全国爱耳日"],
        "3-5": ["周恩来诞辰纪念日", "中国青年志愿者服务日"],
        "3-6": ["世界青光眼日"],
        "3-7": ["女生节"],
        "3-12": ["孙中山逝世纪念日"],
        "3-14": ["马克思逝世纪念日", "白色情人节"],
        "3-17": ["国际航海日"],
        "3-18": ["全国科技人才活动日", "全国爱肝日"],
        "3-20": ["国际幸福日"],
        "3-21": ["世界森林日", "世界睡眠日", "国际消除种族歧视日"],
        "3-22": ["世界水日"],
        "3-23": ["世界气象日"],
        "3-24": ["世界防治结核病日"],
        "3-29": ["中国黄花岗七十二烈士殉难纪念日"],
        "4-2": ["国际儿童图书日", "世界自闭症日"],
        "4-4": ["国际地雷行动日"],
        "4-7": ["世界卫生日"],
        "4-8": ["国际珍稀动物保护日"],
        "4-12": ["世界航天日"],
        "4-14": ["黑色情人节"],
        "4-15": ["全民国家安全教育日"],
        "4-22": ["世界地球日", "列宁诞辰纪念日"],
        "4-23": ["世界读书日"],
        "4-24": ["中国航天日"],
        "4-25": ["儿童预防接种宣传日"],
        "4-26": ["世界知识产权日", "全国疟疾日"],
        "4-28": ["世界安全生产与健康日"],
        "4-30": ["全国交通安全反思日"],
        "5-2": ["世界金枪鱼日"],
        "5-3": ["世界新闻自由日"],
        "5-5": ["马克思诞辰纪念日"],
        "5-8": ["世界红十字日"],
        "5-11": ["世界肥胖日"],
        "5-12": ["全国防灾减灾日", "护士节"],
        "5-14": ["玫瑰情人节"],
        "5-15": ["国际家庭日"],
        "5-19": ["中国旅游日"],
        "5-20": ["网络情人节"],
        "5-22": ["国际生物多样性日"],
        "5-25": ["525心理健康节"],
        "5-27": ["上海解放日"],
        "5-29": ["国际维和人员日"],
        "5-30": ["中国五卅运动纪念日"],
        "5-31": ["世界无烟日"],
        "6-3": ["世界自行车日"],
        "6-5": ["世界环境日"],
        "6-6": ["全国爱眼日"],
        "6-8": ["世界海洋日"],
        "6-11": ["中国人口日"],
        "6-14": ["世界献血日", "亲亲情人节"],
        "6-17": ["世界防治荒漠化与干旱日"],
        "6-20": ["世界难民日"],
        "6-21": ["国际瑜伽日"],
        "6-25": ["全国土地日"],
        "6-26": ["国际禁毒日", "联合国宪章日"],
        "7-1": ["香港回归纪念日"],
        "7-6": ["国际接吻日", "朱德逝世纪念日"],
        "7-7": ["七七事变纪念日"],
        "7-11": ["世界人口日", "中国航海日"],
        "7-14": ["银色情人节"],
        "7-18": ["曼德拉国际日"],
        "7-30": ["国际友谊日"],
        "8-3": ["男人节"],
        "8-5": ["恩格斯逝世纪念日"],
        "8-6": ["国际电影节"],
        "8-8": ["全民健身日"],
        "8-9": ["国际土著人日"],
        "8-12": ["国际青年节"],
        "8-14": ["绿色情人节"],
        "8-19": ["世界人道主义日", "中国医师节"],
        "8-22": ["邓小平诞辰纪念日"],
        "8-29": ["全国测绘法宣传日"],
        "9-3": ["中国抗日战争胜利纪念日"],
        "9-5": ["中华慈善日"],
        "9-8": ["世界扫盲日"],
        "9-9": ["毛泽东逝世纪念日", "全国拒绝酒驾日"],
        "9-14": ["世界清洁地球日", "相片情人节"],
        "9-15": ["国际民主日"],
        "9-16": ["国际臭氧层保护日"],
        "9-17": ["世界骑行日"],
        "9-18": ["九一八事变纪念日"],
        "9-20": ["全国爱牙日"],
        "9-21": ["国际和平日"],
        "9-27": ["世界旅游日"],
        "9-30": ["中国烈士纪念日"],
        "10-1": ["国际老年人日"],
        "10-2": ["国际非暴力日"],
        "10-4": ["世界动物日"],
        "10-11": ["国际女童日"],
        "10-10": ["辛亥革命纪念日"],
        "10-13": ["国际减轻自然灾害日", "中国少年先锋队诞辰日"],
        "10-14": ["葡萄酒情人节"],
        "10-16": ["世界粮食日"],
        "10-17": ["全国扶贫日"],
        "10-20": ["世界统计日"],
        "10-24": ["世界发展信息日", "程序员节"],
        "10-25": ["抗美援朝纪念日"],
        "11-5": ["世界海啸日"],
        "11-8": ["记者节"],
        "11-9": ["全国消防日"],
        "11-11": ["光棍节"],
        "11-12": ["孙中山诞辰纪念日"],
        "11-14": ["电影情人节"],
        "11-16": ["国际宽容日"],
        "11-17": ["国际大学生节"],
        "11-19": ["世界厕所日"],
        "11-28": ["恩格斯诞辰纪念日"],
        "11-29": ["国际声援巴勒斯坦人民日"],
        "12-1": ["世界艾滋病日"],
        "12-2": ["全国交通安全日"],
        "12-3": ["世界残疾人日"],
        "12-4": ["全国法制宣传日"],
        "12-5": ["世界弱能人士日", "国际志愿人员日"],
        "12-7": ["国际民航日"],
        "12-9": ["世界足球日", "国际反腐败日"],
        "12-10": ["世界人权日"],
        "12-11": ["国际山岳日"],
        "12-12": ["西安事变纪念日"],
        "12-13": ["国家公祭日"],
        "12-14": ["拥抱情人节"],
        "12-18": ["国际移徙者日"],
        "12-26": ["毛泽东诞辰纪念日"],
    ]

    public class func isLeapYear(year: Int) -> Bool {
        if year < 1600 {
            return year % 4 == 0
        }
        return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
    }

    public class func getDaysOfYear(year: Int) -> Int {
        if 1582 == year {
            return 355
        }
        return isLeapYear(year: year) ? 366 : 365
    }

    public class func getDaysOfMonth(year: Int, month: Int) -> Int {
        if 1582 == year && 10 == month {
            return 21
        }
        let m = month - 1
        var d = DAYS_OF_MONTH[m]
        if m == 1 && isLeapYear(year: year) {
            d += 1
        }
        return d
    }

    public class func getDaysInYear(year: Int, month: Int, day: Int) -> Int {
        var days = 0
        for i in 1 ..< month {
            days += getDaysOfMonth(year: year, month: i)
        }
        var d = day
        if 1582 == year && 10 == month {
            if day >= 15 {
                d -= 10
            } else if day > 4 {
                fatalError("wrong solar year \(year) month \(month) day \(day)")
            }
        }
        days += d
        return days
    }

    public class func getWeeksOfMonth(year: Int, month: Int, start: Int) -> Int {
        Int(ceil(Double(getDaysOfMonth(year: year, month: month) + Solar.fromYmdHms(year: year, month: month, day: 1).week - start) / Double(7)))
    }

    public class func getWeek(year: Int, month: Int, day: Int) -> Int {
        var y = year
        var m = month
        // 蔡勒公式
        if m < 3 {
            m += 12
            y -= 1
        }
        let c = y / 100
        y = y - c * 100
        let x = y + y / 4 + c / 4 - 2 * c
        var w = 0
        if isBefore(ay: year, am: month, ad: day, ah: 0, ai: 0, ac: 0, by: 1582, bm: 10, bd: 15, bh: 0, bi: 0, bc: 0) {
            w = (x + 13 * (m + 1) / 5 + day + 2) % 7
        } else {
            w = (x + 26 * (m + 1) / 10 + day - 1) % 7
        }
        return (w + 7) % 7
    }

    public class func isBefore(ay: Int, am: Int, ad: Int, ah: Int, ai: Int, ac: Int, by: Int, bm: Int, bd: Int, bh: Int, bi: Int, bc: Int) -> Bool {
        if ay > by {
            return false
        }
        if ay < by {
            return true
        }
        if am > bm {
            return false
        }
        if am < bm {
            return true
        }
        if ad > bd {
            return false
        }
        if ad < bd {
            return true
        }
        if ah > bh {
            return false
        }
        if ah < bh {
            return true
        }
        if ai > bi {
            return false
        }
        if ai < bi {
            return true
        }
        return ac < bc
    }

    public class func isAfter(ay: Int, am: Int, ad: Int, ah: Int, ai: Int, ac: Int, by: Int, bm: Int, bd: Int, bh: Int, bi: Int, bc: Int) -> Bool {
        if ay > by {
            return true
        }
        if ay < by {
            return false
        }
        if am > bm {
            return true
        }
        if am < bm {
            return false
        }
        if ad > bd {
            return true
        }
        if ad < bd {
            return false
        }
        if ah > bh {
            return true
        }
        if ah < bh {
            return false
        }
        if ai > bi {
            return true
        }
        if ai < bi {
            return false
        }
        return ac > bc
    }

    public class func getDaysBetween(ay: Int, am: Int, ad: Int, by: Int, bm: Int, bd: Int) -> Int {
        var n: Int
        var days: Int
        if ay == by {
            n = getDaysInYear(year: by, month: bm, day: bd) - getDaysInYear(year: ay, month: am, day: ad)
        } else if ay > by {
            days = getDaysOfYear(year: by) - getDaysInYear(year: by, month: bm, day: bd)
            for i in by + 1 ..< ay {
                days += getDaysOfYear(year: i)
            }
            days += getDaysInYear(year: ay, month: am, day: ad)
            n = -days
        } else {
            days = getDaysOfYear(year: ay) - getDaysInYear(year: ay, month: am, day: ad)
            for i in ay + 1 ..< by {
                days += getDaysOfYear(year: i)
            }
            days += getDaysInYear(year: by, month: bm, day: bd)
            n = days
        }
        return n
    }
}
