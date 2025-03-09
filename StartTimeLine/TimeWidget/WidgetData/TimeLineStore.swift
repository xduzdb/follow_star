import Combine
import KakaJSON
import SwiftUI
import SwiftyJSON
import UIKit
import WidgetKit

import UIKit

let hhmmssSSFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm:ss:SS"
    return formatter
}()

private let JPrintQueue = DispatchQueue(label: "JPrintQueue")
/// 自定义日志
func JPrint(_ msg: Any..., file: NSString = #file, line: Int = #line, fn: String = #function) {
    #if DEBUG
        guard msg.count != 0, let lastItem = msg.last else { return }

        // 时间+文件位置+行数
        let date = hhmmssSSFormatter.string(from: Date()).utf8
        let fileName = (file.lastPathComponent as NSString).deletingPathExtension
        let prefix = "[\(date)] [\(fileName) \(fn)] [第\(line)行]:"

        // 获取【除最后一个】的其他部分
        let items = msg.count > 1 ? msg[..<(msg.count - 1)] : []

        JPrintQueue.sync {
            print(prefix, terminator: " ")
            items.forEach { print($0, terminator: " ") }
            print(lastItem)
        }
    #endif
}

func ImageCacheName(_ family: WidgetFamily, date: Date = Date()) -> String {
    let dateStr = String(format: "%.0lf", date.timeIntervalSince1970)
    switch family {
    case .systemLarge:
        return "large_\(dateStr).jpeg"
    case .systemMedium:
        return "medium_\(dateStr).jpeg"
    default:
        return "small_\(dateStr).jpeg"
    }
}

func CachePath(_ name: String) -> String {
    guard name.count > 0 else { return "" }
    var cachePath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppGroupIdentifier)?.path ?? ""
    cachePath += "/"
    cachePath += name
    return cachePath
}

@propertyWrapper struct UserDefault<T> {
    let key: String

    var wrappedValue: T? {
        set {
            UserDefaults(suiteName: AppGroupIdentifier)?.set(newValue, forKey: key)
            UserDefaults(suiteName: AppGroupIdentifier)?.synchronize()
        }
        get {
            UserDefaults(suiteName: AppGroupIdentifier)?.object(forKey: key) as? T
        }
    }
}

class OneDayStore: ObservableObject {
    /**
     * 目前疑问：
     * 为何要同时使用`UserDefault`和`AppStorage`？
     * 真正存值的是`UserDefault`，而`AppStorage`则是SwiftUI的状态，用于刷新`桌面Widget`和`App内`的UI（只要`AppStorage`发生改变SwiftUI则会立马刷新视图）
     * 虽然`AppStorage`也是能用于存取的，但是存值后`桌面Widget`和`App内`的数据并不是最新的！会有延迟（至少目前的现象就是如此）
     * 目前想到方案就是使用`UserDefault`存取，而`AppStorage`用于UI刷新的一种奇怪组合。
     */

    // 当前明星的相关数据
    @UserDefault<Data>(key: StartDataKey)
    private static var startData
    @AppStorage(StartDataKey, store: UserDefaults(suiteName: AppGroupIdentifier))
    private static var startStorage: Data?

    static func cacheModel(_ model: OneDayModel) {
        let data = model.encode()
        startData = data
        startStorage = data
    }

    static func fetchModel() -> OneDayModel {
        return .build(withData: startData)
    }

    static func fetchData(_ family: WidgetFamily, completion: @escaping () -> Void) {
        Asyncs.async {
            // 获取当前的信息
            let cacheModel = fetchModel()

            let text = cacheModel.text
            let type = cacheModel.type
            var imageName = cacheModel.imageName
            let imageUrl = cacheModel.imageUrl
            let refreshOptions = cacheModel.refreshOptions

            let isRefreshWidget = imageName == "" || text == "" || type == ""

            let refreshDone: (_ text: String, _ imageName: String, _ type: String) -> Void = {
                let model = OneDayModel(text: $0, imageName: $1, type: $2)
                Asyncs.main {
                    self.cacheModel(model)
                    completion()
                }
            }

            let group = DispatchGroup()

            if isRefreshWidget, refreshOptions.contains(.all) {
                // 获取当前的Store信息
                File.manager.deleteFile(CachePath(imageName))
                imageName = ""
                let imageTask = URLSession.shared.dataTask(with: URL(string: imageUrl)!) { data, _, _ in
                    defer { group.leave() }

                    let cacheName = ImageCacheName(family)
                    let cachePath = CachePath(cacheName)

                    guard let data = data else {
                        return
                    }

                    do {
                        try data.write(to: URL(fileURLWithPath: cachePath))
                        imageName = cacheName

                    } catch {
                    }
                }
                group.enter()
                imageTask.resume()
            } else {
            }

            group.notify(queue: DispatchQueue.global()) {
                refreshDone(text, imageName, type)
            }
        }
    }
}
