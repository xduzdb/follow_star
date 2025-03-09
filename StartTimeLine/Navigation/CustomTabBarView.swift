//
//  CustomTabBarView.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/1.
//

import SwiftUI

struct CustomTabBarView: View {
    // MARK: -  属性

    let tabs: [TabBarItem]
    let style: CustomTabBarStyle
    @Binding var selection: TabBarItem
    @Namespace private var namespace
    // 用于动画
    @State var localSelection: TabBarItem

    // MARK: -  内容

    var body: some View {
        if style == .normal {
            tabBarVersionOne
                .onChange(of: selection) { newValue in
                    withAnimation(.easeInOut) {
                        localSelection = newValue
                    }
                }
        } else {
            tabBarVersionTwo
                .onChange(of: selection) { newValue in
                    withAnimation(.easeInOut) {
                        localSelection = newValue
                    }
                }
        }
    }
}

// 预览代码
struct CustomTabBarView_Previews: PreviewProvider {
    static let tabs: [TabBarItem] = [
        .home, .history, .profile
    ]
    static var previews: some View {
        VStack {
            Spacer()
            CustomTabBarView(tabs: tabs, style: .normal, selection: .constant(tabs.first!), localSelection: tabs.first!)
                .frame(maxWidth: 88 * 3)
        }
    }
}

// 样式1
extension CustomTabBarView {
    private func tabView(tab: TabBarItem) -> some View {
        HStack(spacing: 0) {
            String.BundleImageName(selection != tab ? tab.iconSelectName : tab.iconName)
                .frame(width: 28, height: 28)

            if selection == tab {
                Text(tab.title)
                    .font(.system(size: 12))
                    .lineLimit(1)
                    .foregroundColor(.white)
            }
        }
        .foregroundColor(selection == tab ? tab.color : Color.gray)
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .frame(maxWidth: 88)
        .background(selection == tab ? tab.color.opacity(0.2) : Color.clear)
        .cornerRadius(22)
    }

    private var tabBarVersionOne: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                tabView(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 2)
        .cornerRadius(56/2)
        .frame(maxWidth: 88 * 3)
        .background(Color.red.ignoresSafeArea(edges: .bottom))
    }

    private func switchToTab(tab: TabBarItem) {
        selection = tab
    }
}

// 样式2
extension CustomTabBarView {
    private func tabView2(tab: TabBarItem) -> some View {
        HStack(spacing: 0) {
            String.BundleImageName(selection == tab ? tab.iconSelectName : tab.iconName)
                .frame(width: 28, height: 28)

            if selection == tab {
                Text(tab.title)
                    .font(.system(size: 12))
                    .lineLimit(1)
                    .foregroundColor(.white)
            }
        } //: VSTACK
        .foregroundColor(localSelection == tab ? tab.color : Color.gray)
        .padding(.vertical, 8)
        .frame(maxWidth: 88)

        .background(
            ZStack {
                if localSelection == tab {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(tab.color.opacity(0.2))
                        .matchedGeometryEffect(id: "background_rectangle", in: namespace)
                }
            }
        )
    }

    private var tabBarVersionTwo: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                tabView2(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        } //: HSTACK
        .padding(6)
        .background(Color.black.ignoresSafeArea(edges: .bottom))
        .cornerRadius(56/2)
        .frame(maxWidth: 88 * 3)
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}
