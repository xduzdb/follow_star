//
//  ContentView.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/8/3.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("selectTab") var selectTab: Tab = .home
    @State private var tabSelection: TabBarItem = .home

    @EnvironmentObject var appEnv: Model

    var body: some View {
        NavigationView(content: {
            CustomTabBarContainerView(selection: $tabSelection, style: .line) {
                HomeView()
                    .tabBarItem(tab: .home, selection: $tabSelection)

                HistoryView()
                    .tabBarItem(tab: .history, selection: $tabSelection)
                
                MeView()
                    .tabBarItem(tab: .profile, selection: $tabSelection)
            }
        })
        .navigationViewStyle(.stack)
        .environmentObject(appEnv)
    }
}

#Preview {
    ContentView()
}
