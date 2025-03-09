//
//  UserPushNotificationsView.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/10/1.
//

import SwiftUI

struct UserPushNotificationsView: View {
    @State private var isNotice = false
    @State private var openOriginalWeibo = false
    @State private var openRelayWeibo = false

    @State private var userPushSetting: UserPushModel?

    var body: some View {
        NavTopView {
            ScrollView {
                VStack(spacing: 20) {
                    HStack(alignment: .center, spacing: 0) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("推送免打扰")
                                .font(.system(size: 15)).fontWeight(.bold)
                                .foregroundColor(Color.color333333())

                            Text("免打扰开启后，不在接受所有的推送通知")
                                .font(.system(size: 13))
                                .foregroundColor(Color.color999999())
                        }
                        .padding(.horizontal)

                        Spacer()

                        Toggle(isOn: $isNotice) {}
                            .onTapGesture {
                                isNotice.toggle()
                            }

                            .padding(.zero)
                            .padding(.trailing)
                            .frame(width: 60)

                        Spacer()
                    }
                    .padding(.leading, 0)
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                }

                VStack(spacing: 0) { // 使用 HStack 来水平排列内容
                    SettingCustomView(title: "原创微博通知", notShowBottomLine: true) {
                        Toggle(isOn: $openOriginalWeibo) {}
                            .onTapGesture {
                                openOriginalWeibo.toggle()
                            }

                            .padding(.zero)
                            .padding(.trailing)
                            .frame(width: 60)
                    }
                    SettingCustomView(title: "转发微博通知", notShowBottomLine: false) {
                        Toggle(isOn: $openRelayWeibo) {}
                            .onTapGesture {
                                openRelayWeibo.toggle()
                            }
                            .padding(.zero)
                            .padding(.trailing)
                            .frame(width: 60)
                    }
                }
                .background(Color.white)
                .cornerRadius(10)
            }
            .padding()
            .background(Color.mainBackColor())
        }
        .title("推送通知设置")
        .ignoringTopArea(false)
        .onAppear(perform: {
            getNotificationsSetting()
        })
        .onDisappear(perform: {
            // 页面消失的处理
            dissMissPage()
        })
    }

    // 获取推送通知设置
    func getNotificationsSetting() {
        NetWorkManager.ydNetWorkRequest(.userSubscribeNotice, isShowErrMsg: false, completion: { requestObj in
            if requestObj.status == .success {
                let requestData = requestObj.data?.kj.model(UserPushModel.self)
                userPushSetting = requestData
                isNotice = userPushSetting?.isNotice == 1
                openOriginalWeibo = userPushSetting?.openOriginalWeibo == 1
                openRelayWeibo = userPushSetting?.openRelayWeibo == 1
            }

        })
    }

    // 设置
    func dissMissPage() {
        let params = ["id": userPushSetting?.id ?? 0, "open_original_weibo": openOriginalWeibo ? 1 : 0, "open_relay_weibo": openRelayWeibo ? 1 : 0, "is_notice": isNotice ?1: 0] as [String: Any]
        NetWorkManager.ydNetWorkRequest(.subScribeNotice(params), isShowErrMsg: false, completion: { requestObj in
            if requestObj.status == .success {}

        })
    }
}

struct SettingCustomView<Content: View>: View {
    var title: String
    var notShowBottomLine: Bool
    var content: (() -> Content)?

    var body: some View {
        // 设置圆角
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(title)
                    .font(.system(size: 13))
                    .bold()
                    .foregroundColor(Color.color333333())

                Spacer()

                if let content = content {
                    content()
                }
            }
            .padding(EdgeInsets(top: 18, leading: 12, bottom: 18, trailing: 12))
            .foregroundColor(.white)
            .background(.white)

            if notShowBottomLine {
                Divider()
                    .background(Color.hex("EEEEEE"))
                    .frame(height: 1)
                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            }
        }
        .padding(.zero)
    }
}

#Preview {
    UserPushNotificationsView()
}
