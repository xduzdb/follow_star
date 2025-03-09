//
//  AccountBindView.swift
//  StartTimeLine
//
//  Created by sto on 2024/9/17.
//

import SwiftUI

struct AccountBindView: View {
    @EnvironmentObject var appEnv: Model
    var body: some View {
        NavTopView {
            // 分为 顶部 中间
            VStack {
                VStack(spacing: 0) {
                    AccountSettingItem(title: "手机号码", leftImageName: "bind_phone", notShowBottomLine: false) {
                        Text(appEnv.userInfo?.phone ?? "")
                            .font(.system(size: 13))
                            .foregroundColor(Color.color666666())
                    }
//                    AccountSettingItem(title: "微博", leftImageName: "bind_weibo", notShowBottomLine: true, notShowRight: true) {
//                        Text(appEnv.userInfo?.nickname ?? "")
//                            .font(.system(size: 13)) 
//                            .foregroundColor(Color.color666666())
//                    }
//                    AccountSettingItem(title: "微信", leftImageName: "bind_wechat", notShowBottomLine: true, notShowRight: true) {
//                        Text(appEnv.userInfo?.nickname ?? "")
//                    }
//
//                    AccountSettingItem(title: "QQ", leftImageName: "bind_qq", notShowBottomLine: false, notShowRight: true) {
//                        Text(appEnv.userInfo?.nickname ?? "")
//                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding()
                Spacer()
            }
            .background(Color.hex("F7F6FB"))
        }
        .title("账号绑定")
        .backColor(Color.mainBackColor())
        .ignoringTopArea(false)
    }
}

#Preview {
    AccountBindView()
}
