//
//  ChangeCoverView.swift
//  StartTimeLine
//
//  Created by sto on 2024/10/9.
//

import SwiftUI

struct ChangeCoverView: View {
    @EnvironmentObject var appEnv: Model
    /*
     globals: 全局封面，任何人物都可以使用。
     stars: 明星封面，只有特定人物可以使用。
     owns: 当前用户拥有的封面，任何人物都可以使用。
     */
    @State private var coverInfo: StartCustomCoverInfo?

    // 当前的sid
    var body: some View {
        NavTopView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("默认封面")
                        .font(.system(size: 18))
                        .bold()
                        .foregroundColor(.color333333())
                        .padding()

                    // 默认封面部分
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(coverInfo?.combinedModels ?? [], id: \.id) { info in
                                AsyncImageView(
                                    url: URL(string: info.url ?? ""),
                                    cornerRadius: 22,
                                    defaultImage: Image(systemName: "info.circle")
                                )
                                .frame(width: 100, height: 100)
                                .padding(.trailing)
                            }
                        }
                    }
                    .padding()

                    Text("用户上传")
                        .font(.system(size: 18))
                        .bold()
                        .foregroundColor(.color333333())
                        .padding()

                    // 用户上传部分
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                        ForEach(0 ..< 6) { index in
                            if index == 0 {
                                Button(action: {
                                    // 上传图片的动作
                                }) {
                                    VStack {
                                        Image(systemName: "plus")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                        Text("点击上传")
                                            .font(.caption)
                                    }
                                    .frame(width: 100, height: 100)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                }
                            } else {
                                Image("user_upload_\(index - 1)") // 替换为您的图片名称
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(Color.mainBackColor())
        }
        .title("更换封面")
        .ignoringTopArea(false)
        .onAppear {
            getCoverInfo()
        }
    }

    // 获取当前封面的信息
    func getCoverInfo() {
        let params = ["sid": appEnv.startSid, "type": "2"] as [String: Any]
        NetWorkManager.ydNetWorkRequest(.startUserCover(params), completion: { requestObj in
            if requestObj.status == .success {
                // 用户的Cover
                coverInfo = requestObj.data?.kj.model(StartCustomCoverInfo.self)
            }
        })
    }
}

#Preview {
    ChangeCoverView()
}
