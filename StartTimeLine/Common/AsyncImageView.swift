//
//  AsyncImageView.swift
//  StartTimeLine
//
//  Created by sto on 2024/10/10.
//

import SDWebImageSwiftUI
import SwiftUI

struct AsyncImageView: View {
    let url: URL?
    let cornerRadius: CGFloat
    let borderColor: Color?
    let borderWidth: CGFloat?
    let defaultImage: Image?

    @State private var isLoading: Bool = true // 状态变量来跟踪加载状态

    init(url: URL?, cornerRadius: CGFloat, borderColor: Color? = nil, borderWidth: CGFloat? = nil, defaultImage: Image? = nil) {
        self.url = url
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.defaultImage = defaultImage
    }

    var body: some View {
        WebImage(url: url)
            .resizable()
            .onSuccess { _, _, _ in
            }
            .onFailure { _ in
            }
            .scaledToFill()
            .cornerRadius(cornerRadius)
            .clipped()
            .overlay(
                // 仅在边框颜色和宽度都不为 nil 时添加边框
                (borderColor != nil && borderWidth != nil) ?
                    RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor!, lineWidth: borderWidth!) : nil
            )
    }
}

struct AsyncFrameImageView: View {
    let url: URL?
    let cornerRadius: CGFloat

    var body: some View {
        if let url = url {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView() // 显示加载指示器
                case let .success(image):
                    image
                        .resizable() // 使图像可调整大小
                        .scaledToFill() // 按比例填充
                        .cornerRadius(cornerRadius) // 设置圆角
                        .clipped() // 裁剪超出部分
                case .failure:
                    Image(systemName: "exclamationmark.triangle") // 显示错误图标
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(cornerRadius)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // 撑满父视图
        } else {
            EmptyView() // 如果没有 URL，返回空视图
        }
    }
}

struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageView(
            url: URL(string: "http://114.116.247.103:2500/static/attachment/star-avatar/weibo/0/d24df98ef4cd6f8fd3a6249d0103e75e.jpg"),
            cornerRadius: 10
//            borderColor: nil,
//            borderWidth: nil
        )
        .frame(width: 100, height: 100) // 设置视图的大小
    }
}
