//
//  ChangeCoverView.swift
//  StartTimeLine
//
//  Created by sto on 2024/10/9.
//

import SwiftUI

struct ChangeCoverView: View {
    @EnvironmentObject var appEnv: Model
    @Binding var startDetailModel: StartUserModel?
    /*
     globals: 全局封面，任何人物都可以使用。
     stars: 明星封面，只有特定人物可以使用。
     owns: 当前用户拥有的封面，任何人物都可以使用。
     */
    @State private var coverInfo: StartCustomCoverInfo?

    @State private var coverId: Int?

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    // 更换订阅页面
    @State private var isPresented = false
    @State private var chooseImageList: [UIImage] = []

    // 当前的sid
    var body: some View {
        NavTopView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        // 顶部默认封面部分
                        defaultCusttomView

                        // 底部自定义视图 - 占满剩余空间
                        bottomCustomView
                            .frame(minHeight: geometry.size.height) // 减去顶部大约高度
                            .background(Color(UIColor.systemBackground))
                    }
                }
            }
            .background(Color.white)
        }
        .title("更换封面")
        .ignoringTopArea(false)
        .onAppear {
            getCoverInfo()
        }
    }

    // 用户网络请求的封面的处理
    var defaultCusttomView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("默认封面")
                .font(.system(size: 18))
                .bold()
                .foregroundColor(.color333333())
                .padding(.vertical, 12.0)
                .padding(.horizontal, 12.0)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(coverInfo?.combinedModels ?? [], id: \.id) { info in
                        Button {
                            startDetailModel?.coverUrl = info.url ?? ""
                            setCover(currentCoverId: info.id ?? 0,coverUrl: info.url ?? "")
                        } label: {
                            ZStack {
                                CachedImage(url: info.url ?? "", cornerRadius: 12)
                                    .frame(width: 101.0, height: 101.0)
                                    .clipped()
                                    .cornerRadius(9)

                                if coverId == (info.id ?? 0) {
                                    String.BundleImageName("cover_user_back")
                                        .resizable()
                                        .frame(width: 100.0, height: 100.0)
                                        .padding(.vertical, 2.0)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 12.0)
                .padding(.bottom, 16.0)
            }
        }
        .background(Color.colorF5F5F5())
    }

    // 用户自定义的封面
    var bottomCustomView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("用户上传")
                .font(.system(size: 18))
                .bold()
                .foregroundColor(.color333333())
                .padding(.horizontal, 12)
                .padding(.top, 12)

            // 用户上传部分 - 取本地的数据
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                Button(action: {
                    isPresented = true
                }) {
                    VStack {
                        String.BundleImageName("add_pic_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32.0, height: 32.0)

                        Text("点击上传")
                            .foregroundColor(.color333333())
                            .font(.system(size: 14))
                    }
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .frame(width: (STHelper.screenWidth - 4 * 12) / 3.0, height: (STHelper.screenWidth - 4 * 12) / 3.0)
                .modifier(DashedBorder(
                    color: .gray,
                    cornerRadius: 10,
                    dashLength: 5,
                    dashGap: 5,
                    lineWidth: 1
                ))
                .imagePickerSheet(isPresented: $isPresented, selectedImages: $chooseImageList, maxImagesCount: 1) { list in
                    if let firstImage = list.first {
                        uploadCover(file: firstImage)
                    }
                }

                ForEach(coverInfo?.owns ?? [], id: \.id) { info in
                    Button {
                        startDetailModel?.coverUrl = info.url ?? ""
                        setCover(currentCoverId: info.id ?? 0,coverUrl: info.url ?? "")
                    } label: {
                        ZStack {
                            CachedImage(url: info.url ?? "", cornerRadius: 12)
                                .frame(width: (STHelper.screenWidth - 4 * 12) / 3.0, height: (STHelper.screenWidth - 4 * 12) / 3.0)
                                .clipped()
                                .cornerRadius(9)

                            if coverId == (info.id ?? 0) {
                                String.BundleImageName("cover_user_back")
                                    .resizable()
                                    .frame(width: (STHelper.screenWidth - 4 * 12) / 3.0 + 2.0, height: (STHelper.screenWidth - 4 * 12) / 3.0 + 2.0)
                                    .padding(.vertical, 2.0)
                            }
                        }
                    }
                }
            }
            .padding(.top, 12)
            .padding(.horizontal, 12)

            Spacer()
        }
    }

    // 获取当前封面的信息
    func getCoverInfo() {
        let params = ["sid": appEnv.startSid, "type": "2"] as [String: Any]
        NetWorkManager.ydNetWorkRequest(.startUserCover(params), completion: { requestObj in
            if requestObj.status == .success {
                coverInfo = requestObj.data?.kj.model(StartCustomCoverInfo.self)
                for info in coverInfo?.allCombinedModels ?? [] {
                    if (info.isSelect ?? 0) == 1 {
                        coverId = info.id ?? 0
                    }
                }
            }
        })
    }

    // 设置当前的cover信息
    func setCover(currentCoverId: Int, coverUrl: String) {
        coverId = currentCoverId
        setCoverUrl(coverUrl: coverUrl)
        let params = ["sid": appEnv.startSid, "cover_id": String(coverId ?? 0)] as [String: Any]
        NetWorkManager.ydNetWorkRequest(.setStartUserCover(params), completion: { requestObj in
            if requestObj.status == .success {
                self.presentationMode.wrappedValue.dismiss()
                YDToast.showCenterWithText(text: "设置成功")
            }
        })
    }

    // 上传封面 /api/covers
    func uploadCover(file: UIImage) {
        NetWorkManager.ydNetWorkRequest(.uploadFile(file: file, type: "1"), completion: { requestObj in
            if requestObj.status == .success {
                if let data = requestObj.data,
                   let requestCoverId = data["id"] as? Int, let requestCoverUrl = data["url"] as? String
                {
                    setCover(currentCoverId: requestCoverId, coverUrl: requestCoverUrl)
                }
            }
        })
    }

    func canChangeSubscrible(completion: @escaping (Bool) -> Void) {
        NetWorkManager.ydNetWorkRequest(.changeSubscribe) { requestObj in
            if requestObj.status == .success {
                // 假设返回数据中有 "change" 字段
                if let data = requestObj.data,
                   let change = data["change"] as? Bool
                {
                    completion(change)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }

    // 设置当前的cover
    func setCoverUrl(coverUrl: String) {
        appEnv.coverUlr = coverUrl
    }
}
