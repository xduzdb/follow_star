//
//  HistoryTopBarView.swift
//  StartTimeLine
//
//  Created by 卢仕彤 on 2024/12/25.
//

import SDWebImageSwiftUI
import SwiftUI

struct HistoryTopBarView: View {
    @Binding var shareNum: String? // 用户名
    @Binding var allTimeDatas: [EventTimeLineModel]?
    @Binding var contentHasScrolled: Bool
    
    @EnvironmentObject var model: Model
    @State private var showChangeCover = false
    @State private var showC = false
    @State private var showEventList = false
    
    var body: some View {
        ZStack(alignment:.top) {
            // 底部的详情
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .black.opacity(0.0),
                            .black.opacity(0.2),
                            .black.opacity(0.4),
                            .black.opacity(0.5),
                            .black.opacity(0.6),
                        ].reversed()),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(maxWidth: .infinity)
                .frame(height: STHelper.SafeArea.safeTop + 44.0)
                .ignoresSafeArea()
                .frame(maxHeight: .infinity, alignment: .top)
                .opacity(contentHasScrolled ? 1 : 0)
            
            HStack {
                HStack(spacing: 8) {
                    CachedImage(url: model.currentStartDetailModel?.avatar ?? "", cornerRadius: 15)
                        .clipShape(Circle())
                        .frame(width: 30.0, height: 30.0, alignment: .center)
                        .overlay(
                            Circle()
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [.red, .blue],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .padding(.leading, 2)

                    Text(model.currentStartDetailModel?.name ?? "")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(.trailing, 12)
                }
                .padding(.vertical, 4)
                .background(Color.white.opacity(0.15))
                .cornerRadius(18.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 18.0)
                        .stroke(Color.hex("FFFFFF").opacity(0.2), lineWidth: 0.5)
                )

                Spacer()

                HStack(spacing: 12) {
                    HStack(spacing: 0) {
                        Text(shareNum ?? "")
                            .bold()
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.9))

                        Image("launch")
                            .resizable()
                            .frame(width: 15.0, height: 15.0)
                    }
                    .frame(height: 36)
                    .padding(.horizontal, 12)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(22.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18.0)
                            .stroke(Color.hex("FFFFFF").opacity(0.2), lineWidth: 0.5)
                    )
                    .background(
                        NavigationLink(
                            destination: HistoryEventListView(allTimeDatas: $allTimeDatas), // 如果需要传递 model
                            isActive: $showEventList
                        ) { EmptyView() }
                    )
                    .onTapGesture {
                        // 跳转到详情的页面
                        showEventList = true
                    }

                    HStack(spacing: 0) {
                        Image("edit_bg_colors")
                            .resizable()
                            .frame(width: 15.0, height: 15.0)
                    }
                    .frame(width: 34, height: 34) // 设置固定宽高
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(17) // 圆角设为宽度的一半
                    .overlay(
                        Circle() // 使用 Circle 而不是 RoundedRectangle
                            .stroke(Color.hex("FFFFFF").opacity(0.2), lineWidth: 0.5)
                    )
                    .background(
                        NavigationLink(
                            destination: ChangeCoverView(startDetailModel: $model.currentStartDetailModel), // 如果需要传递 model
                            isActive: $showChangeCover
                        ) { EmptyView() }
                    )
                    .onTapGesture {
                        showChangeCover = true
                    }

                    HStack(spacing: 0) {
                        Text("C位")
                            .font(.system(size: 12))
                            .bold()
                            .foregroundColor(.white)
                            .padding(.horizontal, 2)
                    }
                    .frame(width: 34, height: 34) // 设置固定宽高
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(17) // 圆角设为宽度的一半
                    .overlay(
                        Circle() // 使用 Circle 而不是 RoundedRectangle
                            .stroke(Color.hex("FFFFFF").opacity(0.2), lineWidth: 0.5)
                    )
                    .background(
                        WebViewNavigationLink(
                            urlString: model.feedBackModel?.iosWidget,
                            isActive: $showC
                        )
                    )
                    .onTapGesture {
                        if let _ = model.feedBackModel?.iosWidget {
                            showC = true
                        }
                    }
                }
            }
            .frame(height: 44.0)
            .background(Color.clear)
            .padding(.horizontal, 12)
            .padding(.vertical, STHelper.SafeArea.safeTop)
        }
    }
}

