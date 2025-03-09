//
//  HistoryEventListView.swift
//  StartTimeLine
//
//  Created by Lushitong on 2024/12/30.
//

import SwiftUI

struct HistoryEventListView: View {
    @EnvironmentObject var model: Model
    @Binding var allTimeDatas: [EventTimeLineModel]?
    
    @State private var showAdd = false
    var body: some View {
        NavTopView {
            // 滑动的view
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(allTimeDatas ?? [], id: \.id) { item in
                            HistoryYearItemView(data: item)
                                .padding(.bottom, 12)
                        }
                    }
                    .padding(.bottom, 120)
                }
            }
            .background(Color.mainBackColor())
        }
        .backButtonHidden(false)
        .maxWidth(leading: (STHelper.screenWidth - 50) / 2, trailing: (STHelper.screenWidth - 50) / 2)
        .backColor(Color.mainBackColor())
        .title("")
        .ignoringTopArea(false)
        .wrNavigationBarItems(leading: {
            leadingView
        }, trailing: {
            trailingView
        })
    }
    
    
    var leadingView: some View {
        HStack {
            HStack(spacing: 8) {
                CachedImage(url: model.currentStartDetailModel?.avatar ?? "", cornerRadius: 15)
                    .clipShape(Circle())
                    .frame(width: 30.0, height: 30.0, alignment: .center)
                    .overlay(
                        Circle()
                            .strokeBorder(
                                LinearGradient(
                                    colors: [.red, .blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .padding(.leading, 2)

                Text(model.currentStartDetailModel?.name ?? "")
                    .font(.system(size: 14))
                    .bold()
                    .foregroundColor(.black)
                    .padding(.trailing, 12)
            }
            .padding(.vertical, 4)
            .background(Color.white)
            .cornerRadius(18.0)
            .overlay(
                RoundedRectangle(cornerRadius: 18.0)
                    .stroke(Color.hex("FFFFFF").opacity(0.2), lineWidth: 0.5)
            )
        }
        .padding(.leading, 12)
    }
    
    var trailingView: some View {
        HStack {
            HStack(spacing: 8) {
                String.BundleImageName("plus_btn")
                    .resizable()
                    .frame(width: 18,height: 18)
                
                Text("添加事件")
                    .font(.system(size: 14))
                    .bold()
                    .foregroundColor(.black)
          
            }
            .background(
                WebViewNavigationLink(
                    urlString: getShowAddUrl(),
                    isActive: $showAdd
                )
            )
            .onTapGesture {
                showAdd = true
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.white)
            .cornerRadius(18.0)
            .overlay(
                RoundedRectangle(cornerRadius: 18.0)
                    .stroke(Color.hex("FFFFFF").opacity(0.2), lineWidth: 0.5)
            )
        }
    }
    
    
    
    // 获取当前的链接
    func getShowAddUrl() -> String {
        let token = UserSharedManger.shared.getUserToken() ?? ""
        let urlString = eventUrlStr(token: token)
        return urlString
    }
}

#Preview {
//    HistoryEventListView()
}
