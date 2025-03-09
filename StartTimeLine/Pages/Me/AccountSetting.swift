//
//  AccountSetting.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/8/14.
//

import SDWebImageSwiftUI
import SVProgressHUD
import SwiftUI

struct AccountSetting: View {
    @EnvironmentObject var appEnv: Model
    @State private var showAlert = false

    var body: some View {
        NavTopView {
            // 分为 顶部 中间
            VStack {
                VStack(spacing: 0) {
                    AccountSettingItem(title: "头像", leftImageName: "setting_camera", notShowBottomLine: true) {
                        WebImage(url: URL(string: appEnv.userInfo?.avatar ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 40.0, height: 40.0, alignment: .center)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40.0)
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
                    }
                    AccountSettingItem(title: "昵称", leftImageName: "setting_user", notShowBottomLine: true) {
                        Text(appEnv.userInfo?.nickname ?? "")
                            .font(.system(size: 13))
                            .foregroundColor(Color.color666666())
                    }

                    NavigationLink(destination: AccountFixPwdView()) {
                        AccountSettingItem(title: "修改密码", leftImageName: "setting_lock", notShowBottomLine: false) {
                            Text(appEnv.userInfo?.nickname ?? "")
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding()

                // 跳转到账号绑定的页面

                NavigationLink(destination: AccountBindView()) {
                    AccountSettingItem(title: "绑定账号", leftImageName: "settring_mobile", notShowBottomLine: false) {
                        Text(appEnv.userInfo?.nickname ?? "")
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .padding(.horizontal)
                    .padding(.vertical, 0)
                }

                Spacer()

                // 退出登录和注销账号的
                VStack {
                    HStack {
                        Spacer()
                        Text("退出登录")
                            .font(.system(size: 16))
                            .foregroundColor(Color.color4E5969())
                            .padding(.vertical, 10)
                        Spacer()
                    }
                    .alert(isPresented: $showAlert, content: {
                        Alert(title: Text("提示"),
                              message: Text("是否退出登录?"),
                              primaryButton: .destructive(Text("退出登录")) {
                                  logOut()
                              },
                              secondaryButton: .cancel(Text("取消")))

                    })
                    .onTapGesture {
                        showAlert = true
                    }

                    Divider()

                    NavigationLink(destination: LogoutView()) {
                        Text("注销账号")
                            .font(.system(size: 16))
                            .foregroundColor(Color.color4E5969())
                            .padding(.vertical, 10)
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.horizontal)
                .padding(.vertical, 0)

                Spacer()
                    .frame(height: 50)
            }
            .background(Color.hex("F7F6FB"))
        }
        .title("账号设置")
        .backColor(Color.mainBackColor())
        .ignoringTopArea(false)
    }

    // 退出登录的逻辑操作
    func logOut() {
        // 调用接口退出登录
        SVProgressHUD.show(withStatus: "退出中")
        // 2秒后消失
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            SVProgressHUD.dismiss()
            appEnv.logout()
        }
    }
}

struct AccountSettingItem<Content: View>: View {
    var title: String
    var leftImageName: String
    var notShowBottomLine: Bool
    var notShowRight: Bool = false
    var content: (() -> Content)?

    var body: some View {
        // 设置圆角
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    String.BundleImageName(leftImageName)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)

                    Text(title)
                        .font(.system(size: 13))
                        .bold()
                        .foregroundColor(Color.color333333())

                    Spacer()
                    if let content = content {
                        content()
                    }

                    if !notShowRight {
                        String.BundleImageName("arrow_right")
                            .frame(width: 22, height: 22)
                            .padding(.horizontal, 12)
                    } else {
                        Spacer()
                            .frame(width: 22, height: 22)
                            .padding(.horizontal, 12)
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                .foregroundColor(.white)
                .background(.white)
            }
            if notShowBottomLine {
                Divider()
                    .frame(height: 1)
                    .background(Color.hex("EEEEEE"))
                    .padding(.horizontal, 20) // 设置左右间距为20px
            }
        }
    }
}

// 底部的退出登录和注销账号
#Preview {
    AccountSetting()
}
