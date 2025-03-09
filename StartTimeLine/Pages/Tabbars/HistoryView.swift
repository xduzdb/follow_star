//
//  ExploreView.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/8/4.
//

import SwiftUI

// 创建 SwiftUI 视图
// 大事记Tab, 添加一个铺满Tab的HistoryTabView
struct HistoryView: View {
    var body: some View {
        VStack {
            HistoryDetailsView()
                .background(Color.clear)
        }
        .ignoresSafeArea(.all, edges: .top)
        .edgesIgnoringSafeArea(.all)
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    HistoryView()
}
