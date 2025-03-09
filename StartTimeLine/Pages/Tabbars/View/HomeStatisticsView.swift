//
//  HomeStatisticsView.swift
//  StartTimeLine
//
//  Created by sto on 2024/10/12.
//

import SwiftUI

struct HomeStatisticsView<Content: View>: View {
    var data: [Double]?
    var content: () -> Content

    var body: some View {
        HomeBaseDetailsView(data: data, title: "发布统计") {
            content()
        }
    }
}

#Preview {
    HomeStatisticsView {
        Text("")
    }
}
