//
//  ContactUsView.swift
//  StartTimeLine
//
//  Created by sto on 2024/9/17.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContactUsView: View {
    @State private var contact: ContactModel?
    
    var body: some View {
        NavTopView {
            mainContent
        }
        .title("联系客服")
        .ignoringTopArea(false)
        .onAppear(perform: getAboutRequest)
    }
    
    // MARK: - 主要内容
    private var mainContent: some View {
        ZStack {
            // 背景图
            backgroundImage
            
            // 内容层
            VStack(spacing: 0) {
                headerSection
                contentSection
                Spacer()
            }
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
    
    // MARK: - 背景
    private var backgroundImage: some View {
        String.BundleImageName("contact_back_us")
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - 顶部区域
    private var headerSection: some View {
        ZStack {
            // 渐变背景
            gradientBackground
            
            // 客服信息
            customerServiceInfo
        }
        .frame(height: 140)
    }
    
    private var gradientBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.oneColors(),
                Color.twoColors(),
                Color.threeColors()
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .clipShape(PartialRoundedRectangle(corners: [.topLeft, .topRight], radius: 12))
        .padding(.top, 40 + 12)
        .padding(.horizontal)
    }
    
    private var customerServiceInfo: some View {
        HStack {
            // App 图标
            String.BundleImageName("app_icon")
                .resizable()
                .cornerRadius(12)
                .frame(width: 50, height: 50)
                .clipped()
                .padding(.leading)
            
            // 客服信息
            serviceInfoText
            
            Spacer()
        }
        .padding(.top, 25)
        .padding(.horizontal)
    }
    
    private var serviceInfoText: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("动态社交平台专属客服")
                .font(.system(size: 16))
                .bold()
                .foregroundColor(Color.color333333())
            
            Text("专属客服")
                .font(.system(size: 12))
                .bold()
                .foregroundColor(Color.color5F4925())
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.colorF4DEBE())
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    // MARK: - 内容区域
    private var contentSection: some View {
        ZStack {
            // 白色背景
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.white)
                .frame(height: 438)
                .padding(.horizontal)
                .offset(y: -20)
            
            // 内容
            VStack {
                qrCodeSection
                
                Text("截图保存至相册，微信中识别添加")
                    .font(.system(size: 13))
                    .foregroundColor(Color.color333333())
                
                Spacer()
                
                bottomImage
            }
            .padding(.horizontal, 24)
        }
        .frame(height: 438)
    }
    
    private var qrCodeSection: some View {
        ZStack {
            String.BundleImageName("contact_us_board")
                .resizable()
                .frame(width: 208, height: 208)
                .aspectRatio(contentMode: .fit)
            
            // 二维码图片
            WebImage(url: URL(string: contact?.url ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 190, height: 190)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            } placeholder: {
                Rectangle()
                    .frame(width: 190, height: 190)
                    .foregroundColor(.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 28)
    }
    
    private var bottomImage: some View {
        String.BundleImageName("contact_bottom_info")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .offset(y: -32)
    }
    
    // MARK: - 网络请求
    private func getAboutRequest() {
        NetWorkManager.ydNetWorkRequest(.connect) { requestObj in
            if requestObj.status == .success {
                contact = ContactModel(JSON: requestObj.data ?? [:])
            }
        }
    }
}

struct PartialRoundedRectangle: Shape {
    var corners: UIRectCorner
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    ContactUsView()
}
