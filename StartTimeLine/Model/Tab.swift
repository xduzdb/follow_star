//
//  Tab.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/8/3.
//

import SwiftUI

// 创建数据模型
struct TabItem: Identifiable {
    var id = UUID()
    var text: String
    var icon: String
    var selectIcon: String
    var tab: Tab
    var color: Color
}

var tabItems = [
    TabItem(text: "首页", icon: "home_icon", selectIcon: "home_select_icon", tab: .home, color: .teal),
    TabItem(text: "大事记", icon: "history_icon", selectIcon: "history_select_icon", tab: .history, color: .blue),
    TabItem(text: "我的", icon: "me_icon", selectIcon: "me_select_icon", tab: .me, color: .red),
]

enum Tab: String {
    case home
    case history
    case me
}

struct TabPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
