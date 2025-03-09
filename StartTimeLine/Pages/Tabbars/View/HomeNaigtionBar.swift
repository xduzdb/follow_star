//
//  HomeNaigtionBar.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/8.
//

import SwiftUI

struct HomeNaigtionBar: View {
    var title = ""
    var headUrl = ""

    @Binding var contentHasScrolled: Bool
    
    // 给外部的点击回调
    var dismissModal: () -> Void

    var body: some View {
        ZStack {
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
                .frame(height: STHelper.SafeArea.safeTop + 44)
                .ignoresSafeArea()
                .frame(maxHeight: .infinity, alignment: .top)
                .opacity(contentHasScrolled ? 1 : 0)

            HStack(spacing: 0, content: {
                if contentHasScrolled {
                    HStack(spacing: 0, content: {
                        CachedImage(
                            url: headUrl,
                            cornerRadius: 16
                        )
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
                        .frame(width: 32, height: 32)
                        .padding(.zero)

                        Text(title)
                            .animatableFont(size: 16, weight: .bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)

                    })
                    .padding(.vertical, 2)
                    .padding(.horizontal, 1)
                    .background(.ultraThinMaterial)
                    .backgroundStyle(cornerRadius: 24, opacity: 0.4)
                    .opacity(contentHasScrolled ? 1 : 0)
                }

                Spacer()

                Button {
                    // 跳转到设置的页面 只是一个弹框
                    dismissModal()
                } label: {
                    //
                    String.BundleImageName("home_settings")
                        .resizable()
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.secondary)
                        .background(.ultraThinMaterial)
                        .backgroundStyle(cornerRadius: 24, opacity: 0.4)
                }

            })
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(.top, 24)
            .padding()
        }
    }
}

#Preview {
    HomeNaigtionBar(title: "张颂文", headUrl: "http://114.116.247.103:2500/static/attachment/star-avatar/weibo/0/d24df98ef4cd6f8fd3a6249d0103e75e.jpg", contentHasScrolled: .constant(true), dismissModal: {})
}
