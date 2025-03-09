//
//  AboutUsView.swift
//  StartTimeLine
//
//  Created by sto on 2024/9/17.
//

import SwiftUI

struct AboutUsView: View {
    // 获取当前版本号
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    // 接受返回的http数据
    @State var aboutUsData: AboutUsData?

    var body: some View {
        NavTopView {
            VStack(content: {
                VStack(spacing: 0) {
                    String.BundleImageName("AppIcon")
                        .resizable()
                        .frame(width: 80.0, height: 80.0, alignment: .center)
                        .cornerRadius(12.0)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)

                    Text("星事记")
                        .font(.system(size: 16))
                        .bold()
                        .foregroundColor(.black)

                    // 版本号
                    Text("版本号：V\(version ?? "")")
                        .font(.system(size: 13))
                        .bold()
                        .foregroundColor(.black)
                        .padding(.bottom, 20)

                    HStack {
                        Text("产品介绍")
                            .font(.system(size: 13))
                            .bold()
                            .foregroundColor(Color.color333333())
                            .padding(.horizontal)

                        Spacer()
                    }

                    HStack {
                        Text(aboutUsData?.intro ?? "")
                            .font(.system(size: 13))
                            .foregroundColor(Color.color333333())
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                            .padding(.top, 8)
                        Spacer()
                    }
                }
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.horizontal)
                .padding(.top)
                .padding(.bottom, 0)

                /// 用户协议和 隐私政策
                VStack(spacing: 0) {
                    Link(destination: URL(string: aboutUsData?.protocol_url ?? "") ?? URL(string: "https://www.baidu.com")!) {
                        AccountSettingItem(title: "隐私政策", leftImageName: "setting_lock", notShowBottomLine: false) {
                            Spacer()
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.horizontal)
                .padding(.top, 0)

                Spacer()
            })
            .background(Color.hex("F7F6FB"))
        }
        .title("关于我们")
        .ignoringTopArea(false)
        .onAppear {
            getAboutRequest()
        }
    }

    // 获取关于我们的api接口
    func getAboutRequest() {
        NetWorkManager.ydNetWorkRequest(.aboutUs, completion: { requestObj in
            if requestObj.status == .success {
                aboutUsData = AboutUsData(JSON: requestObj.data ?? [:])
            }
        })
    }
}

#Preview {
    AboutUsView()
}
