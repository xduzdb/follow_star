//
//  RemindSettingView.swift
//  StartTimeLine
//
//  Created by sto on 2024/10/9.
//

import SwiftUI
import UserNotifications

struct RemindSettingView: View {
    // 判断当前是否是开启通知
    @State private var isNotificationEnabled = false

    var body: some View {
        NavTopView {
            ScrollView {
                VStack(spacing: 20) {
                    HStack(alignment: .center, spacing: 0) {
                        String.BundleImageName("remind_icon")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.horizontal, 12)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("开启通知")
                                .font(.system(size: 15)).fontWeight(.bold)
                                .foregroundColor(Color.color333333())

                            Text(isNotificationEnabled ? "您的设备开启了通知" : "您的设备未开启通知")
                                .font(.system(size: 13))
                                .foregroundColor(Color.color999999())
                        }
                        .padding(.zero)
                        .onTapGesture {
                            openAppSettings()
                        }

                        Spacer()

                        String.BundleImageName("arrow_right")
                            .frame(width: 22, height: 22)
                            .padding(.horizontal, 12)
                    }
                    .padding(.leading, 0)
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .padding()
            .background(Color.mainBackColor())
        }
        .title("提醒设置")
        .ignoringTopArea(false)
        .onAppear {
            checkNotificationStatus()
        }
    }

    func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isNotificationEnabled = settings.authorizationStatus == .authorized
            }
        }
    }
    
    func openAppSettings() {
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            }
        }
}

#Preview {
    RemindSettingView()
}
