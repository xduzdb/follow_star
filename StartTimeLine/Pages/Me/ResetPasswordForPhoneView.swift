//
//  ResetPasswordForPhoneView.swift
//  StartTimeLine
//
//  Created by Lushitong on 2025/1/2.
//

import SwiftUI
import SVProgressHUD
import FWPopupView

struct ResetPasswordForPhoneView: View {
    @State private var newPassword: String = ""
    @State private var newPasswordAgain: String = ""
    @State private var areaCode: String = ""
    @State private var phone: String = ""
    
    @State private var code: String = ""
    @State private var arceCode: String = "+86"
    
    @State private var timeRemaining = 0  // 倒计时剩余秒数
    @State private var timer: Timer?      // 计时器
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let phoeDirList: [String] = ["+86", "+852", "+853", "+886"]
    
    var body: some View {
        NavTopView {
            VStack(spacing: 16) {
                
                // 手机号
                HStack(spacing:0 ) {
                    Button {
                        labelTap()
                    } label: {
                        Text(arceCode)
                            .font(.system(size: 15))
                            .foregroundColor(.color333333())
                            .padding(.leading, 12)
                    }
                    
                    TextField("请输入手机号", text: $phone) {}
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.clear, lineWidth: 2) // 设置边框样式
                        )
                }
                .background(Color.colorF8F8F8())
                .cornerRadius(8) // 设置TextField的角度
                
                // 发送验证码
                HStack(spacing:0 ) {
                    TextField("请输入验证码", text: $code) {}
                        .padding()
                        .background(Color.colorF8F8F8())
                        .cornerRadius(8) // 设置TextField的角度
                    
                    Spacer()
                    
                    // 发送验证码
                    Button {
                        sendCode()
                    } label: {
                        Text(timeRemaining > 0 ? "\(timeRemaining)s" : "发送验证码")
                            .font(.system(size: 15))
                            .foregroundColor(Color.colorF05F49())
                    }
                    .padding(.horizontal)
                }
                .background(Color.colorF8F8F8())
                .cornerRadius(8) // 设置TextField的角度

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
                    Text("重置密码")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
                .buttonStyle(GradientWidthCornerRadiusButtonStyle(width: STHelper.screenWidth - 24, height: 40, cornerRadius: 20))
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
        }
        .title("重置密码")
        .ignoringTopArea(false)
        .onAppear(perform: {
            loadUserPhone()
        })
        .onDisappear {
            // 视图消失时取消计时器
            timer?.invalidate()
            timer = nil
        }
    }
    
    func loadUserPhone() {
        phone = Model().userInfo?.phone ?? ""
    }
    
    // 调用方法修改密码
    func updatePwd() {
        let params = [
            "verify":"phone_code",
            "code": code,
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
    
    // 发送验证码
    func sendCode() {
        if (phone.isEmpty) {
            YDToast.showCenterWithText(text: "请输入手机号")
            return
        }
        
        // 截取self.areaCodeLabel.text 从第二个字符开始
        let requestAreaCode = String(arceCode.dropFirst())
        
        // 验证码类型，目前支持：login 登录，bind 绑定第三方平台，user_destroy 注销账户，reset_password 重置密码
        let params = ["iac": requestAreaCode, "phone": phone, "type": "reset_password"] as [String: Any]
        NetWorkManager.ydNetWorkRequest(.phoneCode(params), completion: { _ in
            startCountdown()
            SVProgressHUD.showSuccess(withStatus: "发送成功")
        })
    }
    
    func labelTap() {
        let vProperty = FWSheetViewProperty()
        vProperty.touchWildToHide = "1"
        vProperty.titleColor = UIColor.lightGray
        vProperty.titleFont = UIFont.systemFont(ofSize: 15.0)
        vProperty.leftRightTopCornerRadius = 8
        // 取消按钮底下区域通铺效果（必须修改以下属性）
        vProperty.bottomCoherent = true
        vProperty.backgroundColor = UIColor.white
        vProperty.dark_backgroundColor = kPV_RGBA(r: 44, g: 44, b: 44, a: 1)

        let sheetView = FWSheetView.sheet(title: "",
                                          itemTitles: ["+86(中国大陆)", "+852(香港)", "+853(澳门)", "+886(台湾地区)"],
                                          itemBlock: { _, index, title in
            arceCode = self.phoeDirList[index]
        }, cancenlBlock: {}, property: vProperty)
        sheetView.show()
    }
        // 开始倒计时
    private func startCountdown() {
        timeRemaining = 60
        
        // 创建计时器
        timer?.invalidate() // 确保之前的计时器被取消
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                // 倒计时结束，取消计时器
                timer?.invalidate()
                timer = nil
            }
        }
    }
}

#Preview {
    ResetPasswordForPhoneView()
}
