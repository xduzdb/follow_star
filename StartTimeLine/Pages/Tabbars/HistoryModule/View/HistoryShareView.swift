//
//  HistoryShareView.swift
//  StartTimeLine
//
//  Created by 卢仕彤 on 2025/1/3.
//

import SwiftUI
import SDWebImageSwiftUI

struct HistoryShareView: View {
    @EnvironmentObject var model: Model
    @State var data: EventListDetailsData?
    @State var shareUrl: String?
     
    @State private var rect1: CGRect = .zero
    @State private var shareImage: UIImage? = nil
    // 加载的View
    @State private var loadShareImage: Image? = nil
    // 背景的View
    @State private var backShareImage: Image? = nil
    
    @State var shotting = false
    
    var body: some View {
        ZStack(alignment: .center, content: {
            // 底部是一个背景图
            CachedImage(url: model.currentStartDetailModel?.coverUrl ?? "", cornerRadius: 0, onImageLoaded: { image in
                DispatchQueue.main.async {
                    backShareImage = image
                   }
  
            })
                .overlay {
                    Rectangle()
                        .foregroundColor(.black.opacity(0.01))
                }
            
            VStack {
                topErrorView
                    .frame(maxWidth: .infinity, alignment: .trailing) // 右对齐
                    .padding(.trailing, 12)
                    .padding(.top, STHelper.SafeArea.top + 12)
                Spacer()
            }
            
            ScreenshotableView(shotting: $shotting) { screenshot in
                self.shareImage = screenshot
            } content: { style in
                   if let backShareImage = backShareImage {
            GeometryReader { geometry in
                backShareImage
                    .resizable()
                    .aspectRatio(contentMode: .fill) // Adjust the content mode as needed
                    .clipped() // Ensure it doesn't overflow
                    .frame(width: geometry.size.width, height: geometry.size.height) // Match the size of the GeometryReader
                
                topDetailsView()
                    .frame(width: geometry.size.width, height: geometry.size.height) // Ensure topDetailsView matches the size
                    .background(Color.clear) // Optional: Ensure the background is clear to see the image
            }
        }
            }

            // 顶部的分享
            VStack {
                Spacer()
                HStack {
                    DashedLine()
                        .frame(height: 1)
                    
                    Text("分享至")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                    
                    DashedLine()
                        .frame(height: 1)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 42)
                
                HStack {
                    bottomShareView
                        .padding(.bottom, 12 + 34)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 42)
            .padding(.bottom, 44)
        })
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            // 处理分享的接口
            shareView()
        }
    }
    
    //
    func shareView() {
        NetWorkManager.ydNetWorkRequest(.share) { requestObj in
            if requestObj.status == .success {
                if let shareImgeUrl = requestObj.data?["share_img"] as? String {
                    shareUrl = shareImgeUrl
                }
            }
        }
    }
    
    func topDetailsView(onImageLoaded: (() -> Void)? = nil) -> some View {
        BlurredRectangle(
            cornerRadius: 12,
            horizontalPadding: 0,
            verticalPadding: 0
        ) {

            VStack {
                VStack {
                    HStack {
                        ZStack(alignment: .leading) {
                            String.BundleImageName("tab_bar_today")
                                .resizable()
                                .frame(width: 123, height: 40)
                            
                            HStack(spacing: 0) {
                                String.BundleImageName("calendar")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .padding(.leading, 12)
                             
                                Text("那年今日")
                                    .font(.system(size: 14))
                                    .bold()
                                    .foregroundColor(.colorF05F49())
                                    .padding(.leading, 4)
                            }
                            .padding(.top, 4)
                            .padding(.zero)
                        }
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text((data?.date ?? "").formatDateString())
                            .font(.system(size: 18))
                            .bold()
                            .foregroundColor(.white)
                            .padding(.bottom, 1)
                            .padding(.leading, 12)
                        
                        Spacer()
                    }
                    
                    // 底部一个全部的页面
                    VStack(alignment: .leading, spacing: 8) {
                        // 主要内容
                        (Text("\(data?.text ?? "")")
                            .font(.system(size: 18))
                            .bold()
                            .foregroundColor(.color1D2129())
                        )
                        .lineSpacing(8)
                        .multilineTextAlignment(.leading)
                        
                        Text("@\(model.currentStartDetailModel?.name ?? "")")
                            .font(.system(size: 12))
                            .foregroundColor(.color333333())
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                }
                //  底部的分享信息
                HStack(spacing: 12) {
                    if let loadedImage = loadShareImage {
                        loadedImage
                                               .resizable()
                                               .aspectRatio(contentMode: .fill)  // 使用枚举值
                                               .frame(width: 76, height: 76)
                                               .cornerRadius(12) // Set the corner radius
                                               .padding(.top, 16)
                                               .padding([.leading, .bottom], 12)
                                       } else {
                        CachedImage(url: shareUrl ?? "", cornerRadius: 12,onImageLoaded: { image in
                            DispatchQueue.main.async {
                                loadShareImage = image
                               }
                        })
                            .frame(width: 76, height: 76)
                            .padding(.top, 16)
                            .padding([.leading, .bottom], 12)
                    }

                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("星事记")
                            .font(.system(size: 18))
                            .bold()
                            .foregroundColor(.color1D2129())
                        
                        Text("扫码或识别二维码下载APP")
                            .font(.system(size: 13))
                            .foregroundColor(.color4E5969())
                    }
                    
                    Spacer()
                }
                .foregroundColor(.colorFEEFED())
            }
        }
    }
    
    // 底部分享的按钮
    var bottomShareView: some View {
        // 增加回调
        
        HStack(spacing: 50) {
            VStack(spacing: 12) {
                String.BundleImageName("weichat_icon")
                    .resizable()
                    .frame(width: 50, height: 50)
                Text("微信")
                    .font(.system(size: 12))
                    .bold()
                    .foregroundColor(.white)
            }
            .onTapGesture {
                shareForType(type: 0)
            }

            VStack(spacing: 12) {
                String.BundleImageName("weibo_icon")
                    .resizable()
                    .frame(width: 50, height: 50)
                Text("微博")
                    .font(.system(size: 12))
                    .bold()
                    .foregroundColor(.white)
            }
            .onTapGesture {
                shareForType(type: 1)
            }
        }
    }
    
    var topErrorView: some View {
        ZStack {
            // 外圈
            Circle()
                .fill(Color.gray.opacity(0.5))
                .overlay(
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 1)
                )
            
            // 内部错误图标
            Image(systemName: "xmark.circle.fill") // 或者使用 "exclamationmark.circle.fill"
                .resizable()
                .frame(width: 12, height: 12)
                .foregroundColor(.white)
                .padding(0)
        }
        .frame(width: 36, height: 36)
    }

    // MARK: eq
    @MainActor
    func shareForType(type: Int) {
        shotting.toggle()
        if (shareImage == nil) {
            return
        }
        if type == 0 {
            HDShareSDKManager().shareImage(shareImage, to: LQShareSession.wechatSession)
        } else {
            HDShareSDKManager().shareImage(shareImage, to: LQShareSession.sina)
        }
    }
}

extension Image {
    func asUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        let targetSize = controller.view.intrinsicContentSize
        controller.view.bounds = CGRect(origin: .zero, size: targetSize)
        controller.view.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

#Preview {
    HistoryShareView()
}
