//
//  LogoutEndView.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/20.
//

import SVProgressHUD
import SwiftUI

struct LogoutEndView: View {
    @EnvironmentObject var appEnv: Model

    var body: some View {
        NavTopView {
            VStack(alignment: .leading, content: {
                // 设置12的圆角
                VStack(content: {
                    HStack {
                        Spacer()
                        VStack {
                            String.BundleImageName("logoutend_icon")
                                .frame(width: 160, height: 160)

                            Text("注销申请已提交")
                                .font(.system(size: 22))
                                .bold()
                                .foregroundColor(Color.color1D2129())

                            Text("账号将于30个自然日后注销")
                                .font(.system(size: 13))
                                .foregroundColor(Color.color666666())
                        }
                        .padding()
                        Spacer()
                    }
                    HStack(spacing: 0, content: {
                        Image(systemName: "info.circle")
                            .frame(width: 12, height: 12)
                            .foregroundColor(Color.colorFF7D00())
                            .padding(.zero)
                            .padding(.trailing, 6)
                            .padding(.leading, 16)

                        Text("在此期间请勿重新登录账号，如登录将视为您放弃注销，如再次注销，需重新提交注销申请。")
                            .font(.system(size: 14))
                            .foregroundColor(Color.colorFF7D00())

                            .padding(.vertical, 8)

                        Spacer()
                    })
                    .background(Color.colorFFF7E8())
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .padding(.top, 12)
                    .padding()
                })
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .padding(.horizontal)
                .padding(.vertical)

                Spacer()

                Button(action: {
                    print("Button tapped!")
                }) {
                    Text("我知道了")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .padding(.bottom, 50)
                .buttonStyle(GradientCornerRadiusButtonStyle())

            })
            .background(Color.hex("F7F6FB"))
        }
        .title("注销账号")
        .backColor(.white)
        .ignoringTopArea(false)
    }

    // 调用注销的接口 只有点击我知道了才可以进行注销
    func logOffApp() {
        NetWorkManager.ydNetWorkRequest(.userLogOff, completion: { requestObj in
            // 登录成功过的操作
            // 成功的回调
            if requestObj.status == .success {
                logOffAppAction()
            } else {
                SVProgressHUD.showError(withStatus: "注销失败")
            }
        })
    }

    func logOffAppAction() {
        // 调用接口退出登录
        SVProgressHUD.show(withStatus: "退出中")
        // 2秒后消失
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            SVProgressHUD.dismiss()
            appEnv.logout()
        }
    }
}

#Preview {
    LogoutEndView()
}
