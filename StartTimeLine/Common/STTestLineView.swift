//
//  STTestLineView.swift
//  StartTimeLine
//
//  Created by 卢仕彤 on 2024/12/20.
//

import SwiftUI
import ExytePopupView

struct STTestLineView: View {
    @State private var text = "weibo"
    @State private var datas = ["1,", "123", "1,", "123", "1,", "123"]
    @State private var props = [1.0, 220, 120, 2.0, 1.0, 2.0]
    @State private var show = false

    var body: some View {
        VStack(content: {
            STLineChartView(title: $text, categories: $datas, prop: $props)
                .frame(width: .infinity, height: 500)
            Button {
                show = true
            } label: {
                Text("12312")
            }

        })
        
        
            .popup(isPresented: $show) {
                FloatTopLeading()
            } customize: {
                $0
                    .closeOnTapOutside(true)
                    .type(.floater())
                    .position(.topLeading)
                    .animation(.spring())
            }
    }
}

struct FloatTopLeading: View {

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("dark"))

            Text("123")
        }
        .fixedSize()
    }
}

#Preview {
    STTestLineView()
}
