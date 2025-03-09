//
//  HomeTrendView.swift
//  StartTimeLine
//
//  Created by sto on 2024/10/11.
//

import Charts
import SwiftUI

struct HomeTrendView<Content: View>: View {
    var data: Double?
    var content: () -> Content // 传入的视图

    var body: some View {
        HomeBaseDetailsView(data: data ,title: "发文趋势") {
            content()
                .padding(.bottom, 12)
        }
    }
}

#Preview {
    HomeTrendView {
        Text("1")
    }
}
