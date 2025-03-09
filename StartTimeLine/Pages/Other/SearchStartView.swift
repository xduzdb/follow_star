//
//  SearchStartView.swift
//  StartTimeLine
//
//  Created by sto on 2024/10/9.
//

import SDWebImageSwiftUI
import SwiftUI
struct SearchStartView: View {
    @State private var searchText = ""
    @FocusState private var isFocused: Bool
    @State private var searchResults: [StartUserModel] = []

    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .frame(width: .infinity, height: 0.1)

            HStack {
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
                    searchText = ""
                    isFocused = false
                }) {
                    Text("取消")
                        .foregroundColor(.color666666())
                }
            }
            .background(Color.mainBackColor())
            .padding(.horizontal)
            .padding(.bottom)
            .background(Color.mainBackColor())

            // 搜索结果列表（这里是空的，因为搜索框是空的）
            List(searchResults, id: \.self) { result in
                SearchItemCell(searchModel: result)
            }
            .listStyle(PlainListStyle())
        }
        .background(Color.mainBackColor())

        .navigationBarHidden(true)
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
}

// 单独的View
struct SearchItemCell: View {
    var searchModel: StartUserModel
    // 订阅某一个明星
    func subscribeStart() {
        let params = ["sid": searchModel.sid ?? ""] as [String: Any]
        NetWorkManager.ydNetWorkRequest(.subscribe(params), completion: { requestObj in
            if requestObj.status == .success {
                // 订阅成功
                YDToast.showCenterWithText(text: "订阅成功")
            }
        })
    }

    var body: some View {
        HStack(spacing: 0) {
            // 加载头像
            AsyncImageView(
                url: URL(string: searchModel.avatar ?? ""),
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
                subscribeStart()
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

// 搜的item

#Preview {
    SearchStartView()
}
