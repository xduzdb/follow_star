//
//  SetPasswordView.swift
//  StartTimeLine
//
//  Created by 卢仕彤 on 2025/1/5.
//

import SwiftUI

struct SetPasswordView: View {
    @State private var newPassword: String = ""
    @State private var newPasswordAgain: String = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    // 回调给上个页面使用
    // 定义回调闭包
    var onPasswordSet: ((Bool) -> Void)?

    var body: some View {
        ZStack(alignment: .top, content: {
            VStack {
                String.BundleImageName("set_pass_top")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }

                ZStack {
                    Spacer()
                        .background(Color.white)
                        .cornerRadius(12)
                        .offset(y: -12)

                    VStack {
                        SecureField("请设置密码", text: $newPassword) {}
                            .padding()
                            .background(Color.colorF8F8F8())
                            .cornerRadius(8) // 设置TextField的角度
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.clear, lineWidth: 2) // 设置边框样式
                            )

                        SecureField("确认密码", text: $newPasswordAgain) {}
                            .padding()
                            .background(Color.colorF8F8F8())
                            .cornerRadius(8) // 设置TextField的角度
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.clear, lineWidth: 2) // 设置边框样式
                            )

                        Button(action: {
                            // 按钮点击事件
                            setPassWord()
                        }) {
                            Text("提交")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                        .buttonStyle(GradientWidthCornerRadiusButtonStyle(width: STHelper.screenWidth - 24, height: 53, cornerRadius: 8))
                        .padding(.top, 12)

                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 12)
                }
            }

            // 右上角有错误
            HStack {
                Spacer()
                String.BundleImageName("common_close_icon")
                    .resizable()
                    .padding(.all, 12)
                    .frame(width: 44, height: 44)
                    .onTapGesture {
                        // 返回到登录的页面
                    }
            }
            .padding(.top, STHelper.SafeArea.top - 12)
            .padding(.trailing, 12)

        })
        .background(Color.white)
        .ignoresSafeArea(.all)
        .navigationBarHidden(true)
    }

    //
    func setPassWord() {
        let params = [
            "verify": "set",
            "password": newPassword,
            "password_new": newPassword,
            "password_repeat": newPasswordAgain,
        ] as [String: Any]

        NetWorkManager.ydNetWorkRequest(.userFixPassword(params)) { requestObj in
            if requestObj.status == .success {
                // 修改成功后返回上一个页面
                YDToast.showCenterWithText(text: "设置密码成功")
                onPasswordSet?(true) // 调用回调，传递成功状态
                self.presentationMode.wrappedValue.dismiss() // 关闭当前视图
            }
        }
    }
}

#Preview {
    SetPasswordView()
}
