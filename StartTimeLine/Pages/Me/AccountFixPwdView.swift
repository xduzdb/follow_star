//
//  AccountFixPwdView.swift
//  StartTimeLine
//
//  Created by sto on 2024/9/17.
//

import SDWebImageSwiftUI
import SwiftUI

// 修改密码页面
struct AccountFixPwdView: View {
    @EnvironmentObject var appEnv: Model

    // 是否跳转到密码修改
    @State private var shouldFix = false
    @State private var shouldPhone = false

    var body: some View {
        NavTopView {
            VStack(content: {
                Spacer()
                    .frame(height: 42)

                CachedImage(url: appEnv.userInfo?.avatar ?? "", cornerRadius: 40)
                    .frame(width: 80, height: 80)
                    .clipped()

                Text("手机号码")
                    .font(.system(size: 13))
                    .foregroundColor(Color.color333333())
                    .padding(.bottom, 8)

                Text(appEnv.userInfo?.phone ?? "")
                    .font(.system(size: 24))
                    .bold()
                    .foregroundColor(Color.color333333())
                    .padding(.bottom, 26)

                Text("请选择使用哪种方式修改密码")
                    .font(.system(size: 13))
                    .foregroundColor(Color.color999999())

                Button(action: {
                    // 按钮点击事件
                    shouldFix = true
                }) {
                    Text("使用原密码修改")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .buttonStyle(GradientButtonStyle())

                NavigationLink(destination: ResetPasswordView(), isActive: $shouldFix) {
                    EmptyView()
                }
                Spacer()
                    .frame(height: 20)

                Button(action: {
                    // 按钮点击事件 
                    shouldPhone = true
                }) {
                    Text("手机验证码修改")
                        .font(.system(size: 16))
                        .foregroundColor(Color.color333333())
                }
                .background(
                    NavigationLink(
                        destination: ResetPasswordForPhoneView(),
                        isActive: $shouldPhone
                    ) { EmptyView() }
                )
                .padding(.horizontal, 20)
                .buttonStyle(SecondaryButtonStyle())

                Spacer()

            })
        }
        .title("修改密码")
        .ignoringTopArea(false)
    }
}

#Preview {
    AccountFixPwdView()
}
