//
//  ContactUsView.swift
//  StartTimeLine
//
//  Created by sto on 2024/9/17.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContactUsView: View {
    
    @State var contact: ContactModel?

    var body: some View {
        NavTopView {
            ZStack {
                String.BundleImageName("contact_back_us")
                    .resizable()
                    .frame(width: .infinity, height: .infinity)

                VStack(spacing: 0) {
                    // 设置LinearGradient 部分圆角
                    ZStack {
                        LinearGradient(gradient: Gradient(colors: [Color.oneColors(), Color.twoColors(), Color.threeColors()]), startPoint: .top, endPoint: .bottom)
                            .frame(width: .infinity, height: 95 + 20)
                            .clipShape(PartialRoundedRectangle(corners: [.topLeft, .topRight], radius: 12))
                            .padding(.top, 40)
                            .padding(.horizontal)

                        // 平台相关客服等信息
                        HStack(content: {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(.red)
                                .frame(width: 50, height: 50)
                                .padding(.leading)

                            // 信息
                            VStack(alignment: .leading, spacing: 4, content: {
                                Text("动态社交平台专属客服")
                                    .font(.system(size: 16))
                                    .bold()
                                    .foregroundColor(Color.color333333())
                                // 设置Text 的背景并且设置圆角

                                Text("专属客服")
                                    .font(.system(size: 12))
                                    .bold()
                                    .foregroundColor(Color.color5F4925())
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.colorF4DEBE())
                                    .clipShape(RoundedRectangle(cornerRadius: 8))

                            })
                            .padding(.zero)

                            Spacer()

                        })
                        .padding(.horizontal)
                    }
                    .frame(width: .infinity, height: 95 + 20)

                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.white)
                            .frame(width: .infinity, height: 533 - 95)
                            .padding(.horizontal)
                            .offset(y: -20)

                        // 设置底部的信息
                        VStack(content: {
                            ZStack {
                                String.BundleImageName("contact_us_board")
                                    .resizable()
                                    .frame(width: 208, height: 208)
                                    .aspectRatio(contentMode: .fit)
                                    
                                
                                // 图片添加圆角

                                WebImage(url: URL(string: contact?.url ?? "")) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 190, height: 190, alignment: .center)
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                } placeholder: {
                                    Rectangle()
                                        .frame(width: 190, height: 190, alignment: .center)
                                        .foregroundColor(.gray)
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                }

                                .onSuccess { _, _, _ in
                                }
                            }
                            .padding(.top, 10)
                            .padding(.bottom, 28)

                            Text("截图保存至相册，微信中识别添加")
                                .font(.system(size: 13))
                                .foregroundColor(Color.color333333())

                            Spacer()
                            String.BundleImageName("contact_bottom_info")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .offset(y: -20 - 12)

                        })
                        .padding(.horizontal, 24)
                    }
                    .frame(width: .infinity, height: 533 - 95)

                    Spacer()
                }
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
        .title("联系客服")
        .ignoringTopArea(false)
        .onAppear(perform: {
            getAboutRequest()
        })
    }
    
    // 获取联系客服的链接
    // 获取关于我们的api接口
    func getAboutRequest() {
        NetWorkManager.ydNetWorkRequest(.connect, completion: { requestObj in
            if requestObj.status == .success {
                contact = ContactModel(JSON: requestObj.data ?? [:])
            }
        })
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
