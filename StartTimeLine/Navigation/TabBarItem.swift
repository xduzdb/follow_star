//
//  TabBarItem.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/1.
//

import SwiftUI

// 使用枚举的方式定义数据
enum TabBarItem: Hashable {
    case home, history, profile
    // 图标
    var iconName: String {
        switch self {
        case .home: return "home_icon"
        case .history: return "history_icon"
        case .profile: return "me_icon"
        }
    }

    var iconSelectName: String {
        switch self {
        case .home: return "home_select_icon"
        case .history: return "history_select_icon"
        case .profile: return "me_select_icon"
        }
    }

    // 标题
    var title: String {
        switch self {
        case .home: return "首页"
        case .history: return "大事记"
        case .profile: return "我的"
        }
    }

    // 颜色
    var color: Color {
        switch self {
        case .home: return Color.white
        case .history: return Color.white
        case .profile: return Color.white
        }
    }
}
