//
//  SearchStartView.swift
//  StartTimeLine
//
//  Created by sto on 2024/10/9.
//

import SDWebImageSwiftUI
import SwiftUI
import SVProgressHUD

struct SearchStartView: View {
    @State private var searchText = ""
    @FocusState private var isFocused: Bool
    @State private var searchResults: [StartUserModel] = []
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var showAlertType: CustomAlertType? // 改为内部状态
    @State private var sid: String = ""
    @EnvironmentObject var model: Model

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                // 返回的按钮
                STBackButton(named: "nav_back", isBlack: true, foreground: .color666666()) {
                    self.presentationMode.wrappedValue.dismiss()
                }
                HStack(spacing: 0) {
                    Image(systemName: "magnifyingglass")
                        .frame(width: 36, height: 36)
                        .foregroundColor(.gray)

                    TextField("查找明星订阅", text: $searchText)
                        .focused($isFocused)
                        .keyboardType(.webSearch)
                        .onSubmit {
                            searchKeyWord() // 调用搜索方法
                        }
                }
                .background(Color.white)
                .cornerRadius(16)
                .frame(height: 44)

                Spacer()

                Button(action: {
                    // 搜索
                    searchKeyWord()
                }) {
                    Text("搜索")
                        .foregroundColor(.color666666())
                }
            }
            .background(Color.mainBackColor())
            .padding(.horizontal)
            .padding(.bottom)
            .background(Color.mainBackColor())

            // 搜索结果列表（这里是空的，因为搜索框是空的）
            List(searchResults, id: \.self) { result in
                SearchItemCell(searchModel: result, showAlertType: $showAlertType, sid: $sid)
            }
            .listStyle(PlainListStyle())
        }
        .background(Color.mainBackColor())
        .navigationBarHidden(true)
        .customAlert($showAlertType, message: "订阅后三个月内不可更换订阅哦~  确认要订阅吗？", finish: { _ in
            subscribeStart()
        })
        .onAppear {
            isFocused = true
        }
    }

    // 搜索的方法
    func searchKeyWord() {
        let params = ["name": searchText] as [String: Any]
        NetWorkManager.ydNetWorkRequest(.startSearch(params), completion: { requestObj in
            if requestObj.status == .success {
                // 使用KKJson 进行解析 返回的是一个数组
                let json: [[String: Any]] = requestObj.data?["list"] as! [[String: Any]]
                searchResults = json.kj.modelArray(StartUserModel.self)
            }
        })
    }

    func subscribeStart() {
        canChangeSubscrible { change in
            if change {
                let params = ["sid": sid] as [String: Any]
                NetWorkManager.ydNetWorkRequest(.subscribe(params), completion: { requestObj in
                    if requestObj.status == .success {
                        // 订阅成功
                        model.startSid = sid
                        YDToast.showCenterWithText(text: "订阅成功")
                        self.presentationMode.wrappedValue.dismiss()
                    }
                })
            } else {
                YDToast.showCenterWithText(text: "不可以更换订阅")
            }
        }
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
}

// 单独的View
struct SearchItemCell: View {
    var searchModel: StartUserModel
    @Binding var showAlertType: CustomAlertType?
    @Binding var sid: String

    var body: some View {
        HStack(spacing: 0) {
            // 加载头像
            CachedImage(
                url: searchModel.avatar ?? "",
                cornerRadius: 22
            )
            .frame(width: 44, height: 44)
            .padding(.trailing)

            Text(searchModel.name ?? "")
                .font(.system(size: 15)).fontWeight(.bold)
                .foregroundColor(Color.color333333())
            Spacer()

            Button(action: {
                // 订阅操作 调用接口 然后返回
                // 先设置 sid，再设置 showAlertType
                sid = searchModel.sid ?? ""
                // 在主线程中设置状态
                DispatchQueue.main.async {
                    showAlertType = .Alert
                    print("Current showAlertType: \(String(describing: showAlertType))")
                }

            }) {
                Text("订阅")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
            }
            .buttonStyle(GradientWidthCornerRadiusButtonStyle(width: 52, height: 28, cornerRadius: 14))
        }
        .background(Color.white)
        .listRowSeparator(.hidden)
    }
}

// Preview 修正
#Preview {
    SearchStartView() // 添加预览
}
