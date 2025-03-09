//
//  HomeItemView.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/8.
//

import SwiftUI

struct HomeBottomSheetItemView: View {
    var title: String
    var subTitle: String
    var leftImageName: String
    var body: some View {
        HStack(spacing: 12) {
            String.BundleImageName(leftImageName)
                .resizable()
                .frame(width: 44, height: 44)
//                .padding(.horizontal, 12)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 15)).fontWeight(.bold)
                    .foregroundColor(Color.color333333())

                Text(subTitle)
                    .font(.system(size: 13)).fontWeight(.bold)
                    .foregroundColor(Color.color999999())
            }

            Spacer()
            String.BundleImageName("arrow_right")
                .resizable()
                .frame(width: 22, height: 22)
                .padding(.horizontal, 12)
        }
        .padding(EdgeInsets(top: 12, leading: 12, bottom: 16, trailing: 0))
        .background(.white)
        .cornerRadius(12)
        .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
    }
}

struct HomeCenterItemView: View {
    var itemHeight: Double

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            String.BundleImageName("home_alert_check")
                .resizable()
                .frame(width: .infinity, height: 128)
                .padding(.zero)

            Text("开启分钟级别监控")
                .font(.system(size: 18)).fontWeight(.bold)
                .foregroundColor(Color.color333333())
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 16, trailing: 0))

            Text("订阅人数暂未达要求，分享好友增加订阅数量后开启分钟级监控，更及时获取社交动态。")
                .font(.system(size: 14)).fontWeight(.bold)
                .foregroundColor(Color.color999999())
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 30, trailing: 20))

            // 画一个渐变的按钮且文字是白色的 背景是渐变的

            ZStack {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.startBackColor(), Color.endBackColor()]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: .infinity, height: 44)
                    .cornerRadius(22)

                Text("分享给好友")
                    .font(.system(size: 16)).fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: .infinity, height: 44)
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))

            // 底部取消按钮
            Button(action: {
                print("取消")
            }) {
                Text("取消")
                    .font(.system(size: 16)).fontWeight(.bold)
                    .foregroundColor(Color.color999999())
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))

            Spacer()
        }
        .frame(width: .infinity, height: itemHeight)
        .padding(.zero)
        .background(.white)
        .cornerRadius(12)
    }
}

// 请阅读并且同意
struct LoginAgreeView: View {
    var itemHeight: Double
    var onAgree: () -> Void // 添加回调闭包

    var body: some View {
        VStack(spacing: 6) {
            Text("请阅读并同意以下条款")
                .font(.system(size: 14)).fontWeight(.bold)
                .foregroundColor(Color.color333333())
                .padding(.top, 12)


            Text("《用户协议》《隐私政策》")
                .font(.system(size: 12)).fontWeight(.bold)
                .foregroundColor(Color.color333333())
                .padding(.vertical, 12)
            
            Divider()

            Button(action: {
                onAgree() // 调用回调
            }) {
                Text("同意并继续")
                    .font(.system(size: 12)).fontWeight(.bold)
                    .foregroundColor(Color.colorF05F49())
                    .padding(.vertical, 12)
            }
        }
        .frame(height: itemHeight)
        .background(.white)
        .cornerRadius(12)
    }
}

// 添加订阅的弹框
struct HomeBottomAddSubscribeView: View {
    // 弹出的高度
    var itemHeight: Double
    var sub: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            String.BundleImageName("home_add_subscribe_bottom")
                .resizable()
                .frame(width: 80, height: 80)
                .padding(.top,24)
                .onTapGesture {
                    sub()
                }

            Text("添加订阅")
                .font(.system(size: 18)).fontWeight(.bold)
                .foregroundColor(Color.color333333())
                .padding(.top, 24)

            Text("订阅后可接受个主流平台实时新动态订阅")
                .font(.system(size: 14))
                .foregroundColor(Color.color999999())
                .padding(.top, 16)
            Spacer()
        }
        .background(.white)
    }
}

#Preview {
//    HomeBottomSheetItemView(title: "提醒设置", subTitle: "更换订阅", leftImageName: "home_cover")
    LoginAgreeView(itemHeight: 120) {
        
    }
    .background(Color.red)
}
