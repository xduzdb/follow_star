//
//  AsyncImageView.swift
//  StartTimeLine
//
//  Created by sto on 2024/10/10.
//

import SDWebImageSwiftUI
import SwiftUI

enum ImageFillMode {
    case fill   // 填满容器
    case fit    // 适应容器
    
    var contentMode: ContentMode {
        switch self {
        case .fill: return .fill
        case .fit: return .fit
        }
    }
}

struct CachedImage: View {
    let url: String
    let cornerRadius: CGFloat
    var fillMode: ImageFillMode = .fill  // 使用自定义枚举
    var showIndicator: Bool = true
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    var onImageLoaded: ((Image) -> Void)?
    
    var body: some View {
        GeometryReader { geometry in
            WebImage(url: URL(string: url), options: .highPriority) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.2))
                        if showIndicator {
                            ProgressView()
                        }
                    }
                    
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: fillMode.contentMode)  // 使用枚举值
                        .onAppear {
                            onImageLoaded?(image)
                        }
                    
                case .failure:
                    ZStack {
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.2))
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
                    
                @unknown default:
                    EmptyView()
                }
            }
            .frame(
                width: width ?? geometry.size.width,
                height: height ?? geometry.size.height
            )
            .clipped()
        }
        .frame(width: width, height: height)
        .cornerRadius(cornerRadius)
    }
}

// 图片加载器
class ImageLoader: ObservableObject {
    @Published var isLoading = true
    
    func load(url: String) {
        guard let imageUrl = URL(string: url) else { return }
        
        // 检查缓存
        if SDImageCache.shared.diskImageDataExists(withKey: url) {
            isLoading = false
            return
        }
        
        // 预加载
        SDWebImagePrefetcher.shared.prefetchURLs([imageUrl])
        
        // 加载图片
        SDWebImageManager.shared.loadImage(
            with: imageUrl,
            options: .highPriority,
            progress: nil
        ) { [weak self] _, _, _, _, _, _ in
            DispatchQueue.main.async {
                self?.isLoading = false
            }
        }
    }
}


struct AsyncImageView_Previews: PreviewProvider {

    static var previews: some View {
        VStack(spacing: 20) {
            // 填满模式
            CachedImage(
                url: "http://114.116.247.103:2500/static/attachment/star-avatar/weibo/0/d24df98ef4cd6f8fd3a6249d0103e75e.jpg",
                cornerRadius: 8,
                fillMode: .fill,
                width: 140,
                height: 200
            )
            
            // 适应模式
            CachedImage(
                url: "http://114.116.247.103:2500/static/attachment/star-avatar/weibo/0/d24df98ef4cd6f8fd3a6249d0103e75e.jpg",
                cornerRadius: 8,
                fillMode: .fit,
                width: 100,
                height: 200
            )
        }
        .padding()
    }
    
}
