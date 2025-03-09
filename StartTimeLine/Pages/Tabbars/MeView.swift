//
//  MeView.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/8/4.
//

import SDWebImageSwiftUI
import SwiftUI
import UserNotifications

struct MeView: View {
    @EnvironmentObject var appEnv: Model

    var body: some View {
        ZStack {
            // 底部的渐变
            VStack(spacing: 0, content: {
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.hex("E84C4F"), Color.hex("FF7E3F")]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .frame(maxWidth: .infinity, maxHeight: 275)
                    .edgesIgnoringSafeArea(.all)
                Spacer()
            })

            RoundedRectangle(cornerRadius: 25)
                .frame(width: .infinity, height: .infinity)
                .edgesIgnoringSafeArea(.bottom)
                .offset(y: 100 + STHelper.SafeArea.top)
                .foregroundColor(Color.mainBackColor())

            ScrollView {
                scrollDetection
                profile
            }

            VStack(spacing: 0, content: {
                HStack(alignment: .top) {
                    // 占位
                    String.BundleImageName("")
                        .frame(width: 12, height: 12)
                        .padding(.horizontal, 20)
                    Spacer()
                    Text("个人中心")
                        .font(.system(size: 18))
                        .fontWeight(.heavy)
                        .foregroundColor(Color.white)
                    Spacer()

                    NavigationLink(destination: AccountSetting()) {
                        String.BundleImageName("me_setting")
                            .frame(width: 22, height: 22)
                            .padding(.horizontal, 20)
                            .navigationBarBackButtonHidden()
                    }
                }
                .frame(maxWidth: .infinity)
                Spacer()
            })
            .padding(.top, STHelper.SafeArea.top)
        }
        .onAppear {
            // 主线程刷新
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                appEnv.userInfo = UserSharedManger.shared.getCurrentUserInfo()
            }
            // 获取是否打开推送的状态
        }
    }

    var profile: some View {
        VStack(spacing: 12.0) {
            // 底部的图片
            WebImage(url: URL(string: appEnv.userInfo?.avatar ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 68.0, height: 68.0, alignment: .center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 34.0)
                            .stroke(LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.0)
                    )

            } placeholder: {
                Rectangle()
                    .clipShape(Circle())
                    .frame(width: 68.0, height: 68.0, alignment: .center)
                    .foregroundColor(.gray)
            }

            .onSuccess { _, _, _ in
            }
            .indicator(.activity) // Activity Indicator
            .transition(.fade(duration: 0.5))
            .padding(EdgeInsets(top: 100 + STHelper.SafeArea.top - 64, leading: 0, bottom: 0, trailing: 0))

            Text(appEnv.userInfo?.nickname ?? "")
                .font(.system(size: 18)).fontWeight(.bold)
                .foregroundColor(Color.color333333())

            // 推送设置
            NavigationLink(destination: UserPushNotificationsView(), label: {
                HStack(alignment: .center, spacing: 0) {
                    String.BundleImageName("setting_push")
                        .frame(width: 24, height: 24)
                        .padding(.horizontal, 12)

                    VStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("推送通知设置")
                                .font(.system(size: 15)).fontWeight(.bold)
                                .foregroundColor(Color.color333333())

                            Text("开启推送，实时了解动态信息")
                                .font(.system(size: 13))
                                .foregroundColor(Color.color999999())
                        }
                    }

                    Spacer()
                    String.BundleImageName("arrow_right")
                        .frame(width: 22, height: 22)
                        .padding(.horizontal, 12)
                }
                .padding(.leading, 0)
                .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                .background(Color.white)
                .cornerRadius(10)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            })

            // 底部的设置
            VStack {
                NavigationLink(destination: STWebView(url: URL(string: "https://www.baidu.com/")!).navigationBarBackButtonHidden(true)) { // Hide the back button) {
                    MeSettingItem(title: "帮助与反馈", leftImageName: "me_help_icon")
                }
                NavigationLink(destination: ContactUsView()) {
                    MeSettingItem(title: "联系客服", leftImageName: "me_phone_icon")
                }

                NavigationLink(destination: AboutUsView()) {
                    MeSettingItem(title: "关于我们", leftImageName: "me_about_icon")
                }
            }
            .padding(.leading, 0)
            .background(Color.white)
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }

    var scrollDetection: some View {
        GeometryReader { proxy in
            //                Text("\(proxy.frame(in: .named("scroll")).minY)")
            Color.clear.preference(key: ScrollPreferenceKey.self, value: proxy.frame(in: .named("scroll")).minY)
        }
        .frame(height: 0)
        .onPreferenceChange(ScrollPreferenceKey.self, perform: { value in
            withAnimation(.easeInOut) {
                if value < 0 {
                    //                    hasScrolled = true
                } else {
                    //                    hasScrolled = false
                }
            }
        })
    }
}

struct MeSettingItem: View {
    var title: String
    var leftImageName: String
    var body: some View {
        HStack(spacing: 0) {
            String.BundleImageName(leftImageName)
                .frame(width: 38, height: 38)
                .padding(.horizontal, 12)

            Text(title)
                .font(.system(size: 15)).fontWeight(.bold)
                .foregroundColor(Color.color333333())
            Spacer()
            String.BundleImageName("arrow_right")
                .frame(width: 22, height: 22)
                .padding(.horizontal, 12)
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
        .foregroundColor(.white)
    }
}

#Preview {
    MeView()
}
