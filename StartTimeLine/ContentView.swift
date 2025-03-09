//
//  ContentView.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/8/3.
//

import ExytePopupView
import SwiftUI

struct ContentView: View {
    @AppStorage("selectTab") var selectTab: Tab = .home
    @State private var tabSelection: TabBarItem = .home

    // 是否展示底部弹框设置相关
    @State private var showBottomSheet = false
    // 是否跳转到提醒设置页面
    @State private var navigateToNextRemindView = false
    // 更换订阅页面
    @State private var navigateToNextSubView = false
    // 更换封面
    @State private var navigateToChangeCoverView = false

    @EnvironmentObject var appEnv: Model

    var body: some View {
        NavigationView(content: {
            CustomTabBarContainerView(selection: $tabSelection, style: .line) {
                HomeView(showBottomSheet: $showBottomSheet, navigateToNextRemindView: $navigateToNextRemindView, navigateToNextSubView: $navigateToNextSubView, navigateToChangeCoverView: $navigateToChangeCoverView)
                    .navigationBarHidden(true)
                    .tabBarItem(tab: .home, selection: $tabSelection)

                HistoryView()
                    .navigationBarHidden(true)
                    .tabBarItem(tab: .history, selection: $tabSelection)

                MeView()
                    .navigationBarHidden(true)
                    .tabBarItem(tab: .profile, selection: $tabSelection)
            }
        })
        .edgesIgnoringSafeArea(.all) // 添加这行
        .navigationBarHidden(true) // 添加这行
        .onAppear {
            if #available(iOS 15.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                appearance.backgroundColor = .clear
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
            }
        }
        .navigationViewStyle(.stack)
        .environmentObject(appEnv)
        // 相关弹框
        .popup(isPresented: $showBottomSheet) {
            StarAlertView(pushTypeAction: { index in
                showBottomSheet = false
                if index == 0 {
                    navigateToNextRemindView = true
                } else if index == 1 {
                    navigateToNextSubView = true
                } else {
                    navigateToChangeCoverView = true
                }
            })
        } customize: {
            $0
                .type(.floater(verticalPadding: 0, useSafeAreaInset: false))
                .position(.bottom)
                .closeOnTap(true)
                .closeOnTapOutside(true)
                .backgroundColor(.black.opacity(0.4))
        }
    }
}

#Preview {
    ContentView()
}
