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

    var body: some View {
        NavTopView {
            VStack(spacing: 16) {
                TextField("请输入原密码", text: $orgPassword) {}
                    .padding()
                    .background(Color.colorF8F8F8()) // 设置背景色为蓝色
                    .cornerRadius(8) // 设置TextField的角度
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.clear, lineWidth: 2) // 设置边框样式
                    )

                TextField("请输入新密码", text: $newPassword) {}
                    .padding()
                    .background(Color.colorF8F8F8())
                    .cornerRadius(8) // 设置TextField的角度
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.clear, lineWidth: 2) // 设置边框样式
                    )

                TextField("请再次输入新密码", text: $newPassword) {}
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
                    print("Button tapped!")
                }) {
                    Text("使用原密码修改")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
                .buttonStyle(SecondaryButtonStyle())
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
        }
        .title("原密码修改")
        .ignoringTopArea(false) 
        .onAppear(perform: {})
    }
}

#Preview {
    ResetPasswordView()
}
