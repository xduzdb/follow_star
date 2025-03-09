//
//  StartTimeLineApp.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/8/3.
//

import SwiftUI

@main
struct StartTimeLineApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var model = Model()
    // 判断是否登录
    @AppStorage("isLogin") var isLogin: Bool?

    var body: some Scene {
        // 判断当前是否已经登录
        WindowGroup {
            if isLogin ?? false {
                ContentView()
                    .environmentObject(model)
                    .preferredColorScheme(.light) // 设置状态栏为黑色

            } else {
                LoginUIVC()
                    .preferredColorScheme(.light) // 设置状态栏为黑色
                    .environmentObject(model)
                    .onReceive(model.$appLoginState) { newData in
                        if newData {
                            isLogin = true
                        } else {
                            isLogin = false
                        }
                    }
                    .ignoresSafeArea(.all)
            }
        }
    }

    // 登录成功后需要把设备id和获取的三方token传给后端
}

// 遵循UIViewControllerRepresentable协议
struct SwiftUICallSwift: UIViewControllerRepresentable {
    @ObservedObject var model: Model
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = LoginVC()
        vc.loginCallback = { success in
            if success {
                self.model.appLoginState = true
            }
        }
        vc.pushForgetPageBlock = { _ in
            // 跳转到忘记密码页面
            let pwd = ForgetPwdVC()
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let rootViewController = window.rootViewController {
                rootViewController.present(pwd, animated: true)
            }
        }
        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // 更新的操作
    }
}

struct LoginUIVC: View {
    @EnvironmentObject var model: Model
    var body: some View {
        VStack {
            SwiftUICallSwift(model: model)
        }.navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
    }
}

// 忘记密码的页面
