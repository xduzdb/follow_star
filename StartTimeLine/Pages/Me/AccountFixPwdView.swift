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

                WebImage(url: URL(string: "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 80.0, height: 80.0, alignment: .center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 80.0)
                                .stroke(LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.0)
                        )

                } placeholder: {
                    Rectangle()
                        .clipShape(Circle())
                        .frame(width: 80.0, height: 80.0, alignment: .center)
                        .foregroundColor(.gray)
                }

                .onSuccess { _, _, _ in
                }
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding()

                Text("手机号码")
                    .font(.system(size: 13))
                    .foregroundColor(Color.color333333())
                    .padding(.bottom, 8)

                Text("15167100152")
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
                .buttonStyle(GradientButtonStyle())
                
                NavigationLink(destination: ResetPasswordView(), isActive: $shouldFix) {
                    EmptyView()
                }
                Spacer()
                    .frame(height: 20)
      

                Button(action: {
                    // 按钮点击事件
                    print("Button tapped!")
                }) {
                    Text("手机验证码修改")
                        .font(.system(size: 16))
                        .foregroundColor(Color.color333333())
                }
                .padding(.horizontal, 20)
                .buttonStyle(SecondaryButtonStyle())

                Spacer()

            })

//            Spacer()
        }
        .title("修改密码")
        .ignoringTopArea(false)
    }
}

#Preview {
    AccountFixPwdView()
}
