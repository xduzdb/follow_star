//
//  HomeDynamicView.swift
//  StartTimeLine
//
//  Created by sto on 2024/10/13.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeDynamicView: View {
    var dynamic: StartDynamicModel

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                CachedImage(url: dynamic.star?.avatar ?? "", cornerRadius: 22)
                    .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing:4, content: {
                    Text(dynamic.star?.name ?? "")
                        .font(.system(size: 13))
                        .foregroundColor(.color333333())
                        .lineLimit(2)
                    
                    // 时间
                    Text(dynamic.bottomInfo)
                        .font(.system(size: 11))
                        .foregroundColor(.colorA3A2A8())
                        .lineLimit(2)
                })

                Spacer()
                Button(action: {
                    // 按钮点击事件
                    let weiboAppUrl = "https://weibo.com/\(dynamic.socialAccount?.platformUserId ?? "")/\(dynamic.postId ?? "")"

                    if UIApplication.shared.canOpenURL(URL(string: weiboAppUrl)!) {
                        UIApplication.shared.open(URL(string: weiboAppUrl)!, options: [:], completionHandler: nil)
                    } else {
                        // 微博App没有安装，可以选择打开微博官网或其他操作
                        if let url = URL(string: "https://weibo.com/\(String(describing: dynamic.socialAccount?.platformUserId))") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                }) {
                    Text("抢沙发")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
                .buttonStyle(GradientWidthCornerRadiusButtonStyle(width: 74, height: 32, cornerRadius: 16))
            }
            .padding(.horizontal,0)
            .padding(.bottom, 6)

            Text(dynamic.content ?? "")
                .font(.system(size: 15))
                .bold()
                .foregroundColor(.color333333())
                .lineSpacing(2)
                .lineLimit(3)

            // 判断当前的类型 图片还是视频呢？
            if dynamic.postType == "image" {
                if let images = dynamic.images, !images.isEmpty {
                    if (images.count == 1) {
                        WebImage(url: URL(string: dynamic.images?[0].url ?? "")) { image in
                            // 图片等比例缩放模式
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxHeight: 180)
                                .frame(width: STHelper.screenWidth - 24 * 2)
                                .clipped()
                                .cornerRadius(8)
                        } placeholder: {

                        }
                    } else {
                        if (images.count == 2) {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                            ], spacing: 10) {
                                ForEach(Array(dynamic.images ?? []).prefix(2), id: \.self) { item in
                                    GridItemView(
                                        imageUrl: item.url ?? "",
                                        imageWidth: (STHelper.screenWidth - 24 - 6) / 2,
                                        imageHeight:  (STHelper.screenWidth - 24 - 6) / 2
                                    )}}
                        } else {
                            LazyVGrid(columns: columns, spacing: 3) {
                                ForEach(Array(dynamic.images ?? []).prefix(9), id: \.self) { item in
                                    GridItemView(
                                        imageUrl: item.url ?? "",
                                        imageWidth: (STHelper.screenWidth - 24 - 4 * 12) / 3.0,
                                        imageHeight: (STHelper.screenWidth - 24 - 4 * 12) / 3.0
                                    )}}
                        }
                        
                    }
                }
            } else if dynamic.postType == "text" {
                VStack(spacing: 10) {
                    // 底部的信息
                    HStack(spacing: 0) {
                        CachedImage(url: dynamic.retweet?.images?.first?.url ?? "", cornerRadius: 8)
                            .frame(width: 60.0, height: 60.0)
                            .clipped()
                            .cornerRadius(9)
                            .padding(.trailing, 6)

                        VStack(alignment: .leading, spacing: 8) {
                            // 用户名
                            Text(dynamic.retweet?.user?.nickname ?? "@UNIQ-LEO")
                                .font(.system(size: 15))
                                .foregroundColor(.black)

                            // 用户内容
                            Text(dynamic.retweet?.content ?? "")
                                .font(.system(size: 12))
                                .foregroundColor(.black)
                                .lineLimit(2) // 允许多行
                        }
                        .padding(.horizontal,4)
                        .frame(maxHeight: 88)
                        .cornerRadius(10) // 圆角
                    }
                    .padding(.horizontal, 4)
                    .padding(.vertical,4)
                    .background(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(Color.colorF8F8F8()) // 背景颜色
                    )
                }
            } else {
                // 如果是Video 则只显示Vide
                ZStack {
                    CachedImage(url: dynamic.video?.cover ?? "", cornerRadius: 8)
                        .scaledToFill()
                        .frame(width: 164, height: 205)
                        .clipped()
                        .cornerRadius(8)
                        .padding(.horizontal)

                    String.BundleImageName("play_circle_filled")
                        .frame(width: 24, height: 24)
                        .position(x: 164, y: 15)
                }
                .frame(width: 164, height: 205)
                .padding(.zero)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }

    // 获取地下的文字
    func getBottomDynamincInfo() {}
}

struct GridItemView: View {
    let imageUrl: String
    let imageWidth: CGFloat
    let imageHeight: CGFloat

    var body: some View {
        CachedImage(url: imageUrl, cornerRadius: 8)
            .frame(width: imageWidth, height: imageHeight)
            .scaledToFill()
            .clipped()
            .cornerRadius(8)
    }
}

#Preview {
    let model = StartUserModel(
        sid: "",
        name: "张颂文",
        avatar: "http://114.116.247.103:2500/static/attachment/star-avatar/weibo/0/d24df98ef4cd6f8fd3a6249d0103e75e.jpg",
        sex: 1,
        status: 1,
        birthday: "",
        subscription: "",
        lastUpdateAt: "",
        isSubscribed: false,
        subscribe: 1
    )

    let rew = StartDynamicRetweetModel(postType: "", content: "【#一幅画打开老家河南#】说到河南，你会想起什么？是龙门石窟的悠久历史，是唐宫夜宴小姐姐优美起舞，是后母戊鼎的厚重，是烩面、胡辣汤的香气扑鼻…#我的宝藏家乡#，河南真“中”！戳图↓↓一起“豫”见画里的精彩河南，来评论区留言，说说你眼里#老家河南哪些地方值得一去# ", images: [StartDynamicSourceModel(width: 0, height: 0, url: "http://114.116.247.103:2500/static/attachment/star-avatar/weibo/0/d24df98ef4cd6f8fd3a6249d0103e75e.jpg", title: "1", cover: ""), StartDynamicSourceModel(width: 0, height: 0, url: "http://114.116.247.103:2500/static/attachment/star-avatar/weibo/0/d24df98ef4cd6f8fd3a6249d0103e75e.jpg", title: "1", cover: ""), StartDynamicSourceModel(width: 0, height: 0, url: "http://114.116.247.103:2500/static/attachment/star-avatar/weibo/0/d24df98ef4cd6f8fd3a6249d0103e75e.jpg", title: "1", cover: "")])

    let dynamicModel = StartDynamicModel(
        platform: "weibo",
        postType: "image",
        sendType: "original",
        content: "【#一幅画打开老家河南#】说到河南，你会想起什么？是龙门石窟的悠久历史，是唐宫夜宴小姐姐优美起舞，是后母戊鼎的厚重，是烩面、胡辣汤的香气扑鼻…#我的宝藏家乡#，河南真“中”！戳图↓↓一起“豫”见画里的精彩河南，来评论区留言，说说你眼里#老家河南哪些地方值得一去# ",
        images: [StartDynamicSourceModel(width: 299, height: 200, url: "http://114.116.247.103:2500/static/attachment/star-avatar/weibo/0/d24df98ef4cd6f8fd3a6249d0103e75e.jpg", title: "1", cover: "")],
        video: StartDynamicSourceModel(width: 0, height: 0, url: "http://114.116.247.103:2500/static/attachment/star-avatar/weibo/0/d24df98ef4cd6f8fd3a6249d0103e75e.jpg", title: "1", cover: "https://sinaimg.pp.cc/wx4/orj480/005ZHJnily1hu4i0jjqebj60u01hcgrd02.jpg"),
        sendAt: "2024-01-18 18:52:38",
        star: model,
        retweet: rew
    )

    return VStack {
        ScrollView {
            HomeDynamicView(dynamic: dynamicModel)
        }
    }
}
