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
    // 是否展示底部弹框设置相关
    @State private var showBottomSheet = false

    // 更换订阅页面
    @State private var isPresented = false
    @State private var chooseImageList: [UIImage] = []

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
                                    Circle()
                                        .strokeBorder(
                                            LinearGradient(
                                                colors: [.red, .blue],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 2
                                        )
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
                    .imagePickerSheet(isPresented: $isPresented, selectedImages: $chooseImageList, maxImagesCount: 1) { list in
                        if let firstImage = list.first {
                            uploadAvator(file: firstImage)
                        }
                    }
                    .onTapGesture {
                        isPresented = true
                    }
                    // 点击后显示修改昵称
                    Button {
                        showBottomSheet = true
                    } label: {
                        AccountSettingItem(title: "昵称", leftImageName: "setting_user", notShowBottomLine: true) {
                            Text(appEnv.userInfo?.nickname ?? "")
                                .font(.system(size: 13))
                                .foregroundColor(Color.color666666())
                        }
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
        .popup(isPresented: $showBottomSheet) {
            FixUserName(changeNameCallback: { name in
                updateUserName(userName: name)
                showBottomSheet = false
            })
        } customize: {
            $0
                .type(.floater(verticalPadding: 0, useSafeAreaInset: false))
                .position(.bottom)
                .closeOnTap(true)
                .closeOnTapOutside(true)
                .backgroundColor(.black.opacity(0.4))
        }
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

    func uploadAvator(file: UIImage) {
        SVProgressHUD.show(withStatus: "头像上传中中")
        NetWorkManager.ydNetWorkRequest(.uploadImage(file: file, type: "1"), progressClouse: { _ in

        }, completion: { requestObj in
            if requestObj.status == .success {
                if let data = requestObj.data,
                   let tempFileStr = data["tmp"] as? String
                {
                    setAvator(tempFileStr: tempFileStr)
                }
            }
        })
    }

    // 设置头像
    func setAvator(tempFileStr: String) {
        let params = ["tmp": tempFileStr] as [String: Any]

        NetWorkManager.ydNetWorkRequest(.setAvator(params), completion: { requestObj in
            if requestObj.status == .success {
                if let data = requestObj.data,
                   let userAvatar = data["url"] as? String
                {
                    UserSharedManger.shared.updatelocalUserData(name: appEnv.userInfo?.nickname ?? "", avator: userAvatar)
                    appEnv.userInfo?.avatar = userAvatar
                    appEnv.objectWillChange.send()
                }
                SVProgressHUD.dismiss()
                YDToast.showCenterWithText(text: "设置成功")
            }
        })
    }

    // 修改昵称
    func updateUserName(userName: String) {
        appEnv.userInfo?.nickname = userName
        UserSharedManger.shared.updatelocalUserData(name: userName, avator: appEnv.userInfo?.avatar ?? "")
        appEnv.objectWillChange.send()

        let params = ["nickname": userName] as [String: Any]
        NetWorkManager.ydNetWorkRequest(.updateNickName(params), completion: { requestObj in
            if requestObj.status == .success {
                YDToast.showCenterWithText(text: "设置成功")
            }
        })
    }
}

struct FixUserName: View {
    @State private var nickname: String = ""
    
    var changeNameCallback: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("修改昵称")
                .font(.system(size: 18))
                .bold()
                .foregroundColor(.color333333())
                .padding(.top, 24)

            // 输入框
            STTextView(
                text: $nickname,
                placeholder: "请输入内容...",
                maxLength: 200,
                height: 52,
                backgroundColor: .gray.opacity(0.1),
                placeholderColor: .gray,
                cornerRadius: 12,
                fontSize: 14
            ) { submittedText in
                nickname = submittedText
            }

            Text("4~30个字符，支持中文、英文、数字")
                .font(.system(size: 13))
                .foregroundColor(.colorC9CDD4())

            // 一个取消和修改
            HStack {
                // 取消按钮
                Button(action: {
                    // 取消操作
                }) {
                    Text("取消")
                        .padding()
                        .font(.system(size: 20))
                        .foregroundColor(Color.color1D2129())
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 0.5))
                }

                // 确认修改按钮
                Button(action: {
                    // 确认修改操作
                    changeNameCallback(nickname)
                }) {
                    Text("确认修改")
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 20))
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.startBackColor(), Color.endBackColor()]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.top, 64)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .background(Color.white)
        .padding(.zero)
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
    FixUserName { _ in
    }
}
