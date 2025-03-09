//
//  HomeBaseDetailsView.swift
//  StartTimeLine
//
//  Created by sto on 2024/10/12.
//

import SwiftUI

struct HomeBaseDetailsView<Content: View>: View {
    var data: [Double]?
    var title: String
    var content: () -> Content // 传入的视图
    var isDataEmpty: Bool { data?.isEmpty ?? true }

    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.system(size: 16))
                    .bold()
                    .foregroundColor(.black)

                Text("仅统计半年数据")
                    .font(.system(size: 14))
                    .foregroundColor(.color999999())

                Spacer()
            }
            if isDataEmpty {
                VStack {
                    String.BundleImageName("home_empty")
                        .frame(width: 120, height: 80)

                    Text("暂无动态")
                        .font(.system(size: 13))
                        .foregroundColor(.color666666())
                        .padding(.zero)

                    Text("没有可用的数据")
                        .font(.system(size: 13))
                        .foregroundColor(.color999999())
                        .padding()
                }
            } else {
                // 要是有数据的话 则显示数据的Item
                content()
            }
        }
        .padding() // 添加内边距
        .background(Color.white) // 设置背景为白色
        .cornerRadius(12) // 设置圆角
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    HomeBaseDetailsView(title: "发文统计") {
        Text("")
    }
}
