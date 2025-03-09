//
//  HomeStartStatisticsView.swift
//  StartTimeLine
//
//  Created by sto on 2024/10/13.
//

import SwiftUI

struct HomeStartStatisticsView: View {
    // 当前选择的是抖音还是微博
    @State private var selectedIndex: Int = 0

    var statisticsModel: StartStatisticsModel?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 2) {
                        Text("发布微博")
                            .font(.system(size: 12))
                            .foregroundColor(selectedIndex == 0 ? .colorF05F49() : .color333333())

                        String.BundleImageName(selectedIndex == 0 ? "home_select_arrow" : "home_arrow")
                            .frame(width: 16, height: 16)
                    }

                    HStack(alignment: .center, spacing: 2) {
                        Text("\(statisticsModel?.subtotal?.weibo?.quantity ?? 0)")
                            .font(.system(size: 20))
                            .bold()
                            .foregroundColor(.black)

                        Text("条")
                            .font(.system(size: 12))
                            .bold()
                            .foregroundColor(.black)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(selectedIndex == 0 ? Color.colorF05F49().opacity(0.1) : Color.mainBackColor())
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(selectedIndex == 0 ? Color.colorF05F49() : Color.clear, lineWidth: 1) // 设置边框颜色和宽度
                )
                .onTapGesture(perform: {
                    selectedIndex = 0
                })

                Spacer() // 添加 Spacer 以等分 HStack

                Spacer()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .padding(3)

            // 时间统计标题
            Text("按发布时间统计")
                .font(.system(size: 14))
                .bold()
                .foregroundColor(.color333333())

            // 时间段统计
            if let hours = selectedIndex == 0 ? statisticsModel?.hour?.weibo : statisticsModel?.hour?.douyin {
                if hours.isEmpty {
                    Text("没有数据可显示") // Handle empty case
                        .foregroundColor(.gray)
                } else {
                    // 只展示前五个
                    ForEach(hours.prefix(5)) { stat in
                        if stat.scale ?? 0.0 > 0 {
                            HStack(content: {
                                VStack(alignment: .leading) {
                                    HStack(spacing: 0) {
                                        Text("\(stat.startTime ?? "")~\(stat.endTime ?? "")")
                                            .font(.system(size: 12))
                                            .bold()
                                            .foregroundColor(.color333333())

                                        Spacer()

                                        Text("\(stat.scale ?? 0.0, specifier: "%.0f")") // Format percentage
                                            .font(.system(size: 12))
                                            .bold()
                                            .foregroundColor(.color333333())

                                        Text("%")
                                            .font(.system(size: 12))
                                            .bold()
                                            .foregroundColor(.color999999())
                                    }

                                    ProgressView(value: Double(stat.scale ?? 0.0), total: 100)
                                        .progressViewStyle(GradientProgressViewStyle(gradient: LinearGradient(gradient: Gradient(colors: [Color.startBackColor(), Color.endBackColor()]), startPoint: .leading, endPoint: .trailing)))
                                        .foregroundColor(.white)
                                        .frame(height: 6)
                                        .cornerRadius(3)
                                }
                            })
                            .padding(.vertical, 8)
                            .padding(.horizontal, 8)
                            .background(Color.mainBackColor())
                            .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct GradientProgressViewStyle: ProgressViewStyle {
    var gradient: LinearGradient

    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .leading) {
            // Background
            Rectangle()
                .foregroundColor(Color.gray.opacity(0.2))
                .frame(height: 6)

            // Gradient foreground
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * 100, height: 6)
                .background(gradient)
                .cornerRadius(3) // Optional: add corner radius for rounded edges
        }
    }
}

#Preview {
    HomeStartStatisticsView()
}
