//
//  TimeLineData.swift
//  StartTimeLine
//
//  Created by sto on 2024/9/26.
//

import KakaJSON
import SwiftyJSON
import UIKit
import WidgetKit

struct StartWidgetInfoModel: Convertible {
    var uuid: String?
    var text: String?
    var type: String?
    var date: String?
    var week: String?
    var star: StartUser?

    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        switch property.name {
        case "star": return "star"
        default: return property.name
        }
    }
}

struct StartUser: Convertible {
    let sid: String = ""
    let name: String = ""
    let avatar: String = ""
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        return property.name.kj.underlineCased()
    }
}

struct OneDayModel: Codable, Identifiable {
    struct RefreshOptions: OptionSet {
        var rawValue: Int = 0
        static let all = Self(rawValue: 1 << 1 + 1 << 2 + 1 << 3)
    }

    var id = UUID()

    // 文案
    var text: String

    // 当前的标签类型
    var type: String

    // 图片文件名
    var imageName: String

    // 图片的链接
    var imageUrl: String

    // 刷新类型（Int类型，用于存储）
    var refreshOptionsRawValue: Int = RefreshOptions.all.rawValue

    // 刷新类型
    var refreshOptions: RefreshOptions {
        set { refreshOptionsRawValue = newValue.rawValue }
        get { RefreshOptions(rawValue: refreshOptionsRawValue) }
    }

    enum CodingKeys: String, CodingKey {
        case text, imageName, type, refreshOptionsRawValue, imageUrl
    }

    init(text: String = "", imageName: String = "", imageUrl: String = "", type: String = "") {
        self.text = text
        self.imageName = imageName
        self.imageUrl = imageUrl
        self.type = type
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)

        text = try c.decode(String.self, forKey: .text)
        imageName = try c.decode(String.self, forKey: .imageName)
        imageUrl = try c.decode(String.self, forKey: .imageUrl)
        type = try c.decode(String.self, forKey: .type)

        refreshOptionsRawValue = try c.decode(Int.self, forKey: .refreshOptionsRawValue)
        if refreshOptionsRawValue == 0 {
            refreshOptionsRawValue = RefreshOptions.all.rawValue
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)

        try c.encode(text, forKey: .text)
        try c.encode(imageName, forKey: .imageName)
        try c.encode(imageUrl, forKey: .imageUrl)
        try c.encode(type, forKey: .type)

        try c.encode(refreshOptionsRawValue, forKey: .refreshOptionsRawValue)
    }
}

extension OneDayModel {
    var showText: String {
        text.count > 0 ? text : ""
    }

    var image: UIImage {
        let imagePath = CachePath(imageName)
        if File.manager.fileExists(imagePath), let image = UIImage(contentsOfFile: imagePath) {
            return image
        } else {
            return DefaultMediumImage
        }
    }
}

extension OneDayModel {
    func encode() -> Data? {
        try? JSONEncoder().encode(self)
    }

    static func decode(_ data: Data?) -> OneDayModel? {
        guard let data = data else { return nil }
        return try? JSONDecoder().decode(OneDayModel.self, from: data)
    }

    static func placeholder() -> OneDayModel {
        OneDayModel(text: "人类的悲欢并不相通，我只觉得他们吵闹", type: "咖营")
    }

    static func build(withData data: Data?) -> OneDayModel {
        do {
            let decoder = JSONDecoder()
            // 尝试解码数据
            let model = try decoder.decode(OneDayModel.self, from: data ?? Data())
            return model
        } catch {
            // 打印错误日志
            print("Decoding error: \(error.localizedDescription)")
            return .placeholder() // 返回占位符
        }
    }
}
