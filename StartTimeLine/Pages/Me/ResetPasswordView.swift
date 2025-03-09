//
//  ResetPasswordView.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/23.
//

import SwiftUI

struct ResetPasswordView: View {
    @State private var orgPassword: String = ""
    @State private var newPassword: String = ""
    @State private var newPasswordAgain: String = ""
    @State private var canClck: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavTopView {
            VStack(spacing: 16) {
                SecureField("请输入原密码", text: $orgPassword) {}
                    .padding()
                    .background(Color.colorF8F8F8()) // 设置背景色为蓝色
                    .cornerRadius(8) // 设置TextField的角度
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.clear, lineWidth: 2) // 设置边框样式
                    )

                SecureField("请输入新密码", text: $newPassword) {}
                    .padding()
                    .background(Color.colorF8F8F8())
                    .cornerRadius(8) // 设置TextField的角度
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.clear, lineWidth: 2) // 设置边框样式
                    )

                SecureField("请再次输入新密码", text: $newPasswordAgain) {}
                    .padding()
                    .background(Color.colorF8F8F8())
                    .cornerRadius(8) // 设置TextField的角度
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.clear, lineWidth: 2) // 设置边框样式
                    )

                // 使用原密码修改的按钮
                // 按钮
                Button(action: {
                    // 按钮点击事件
                    updatePwd()
                }) {
                    Text("使用原密码修改")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
                .buttonStyle(GradientWidthCornerRadiusButtonStyle(width: STHelper.screenWidth - 24, height: 40, cornerRadius: 20))
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
        }
        .title("原密码修改")
        .ignoringTopArea(false)
        .onAppear(perform: {})
    }
    
    // 调用方法修改密码
    func updatePwd() {
        /// /api/users/password
        
        let params = [
            "verify":"password",
            "password": orgPassword,
            "password_new": newPassword,
            "password_repeat": newPasswordAgain,
        ] as [String: Any]
        
        NetWorkManager.ydNetWorkRequest(.userFixPassword(params)) { requestObj in
            if requestObj.status == .success {
                // 修改成功后返回上一个页面
                self.presentationMode.wrappedValue.dismiss()
                YDToast.showCenterWithText(text: "修改成功")
            }
        }
    }
}

#Preview {
    ResetPasswordView()
}
