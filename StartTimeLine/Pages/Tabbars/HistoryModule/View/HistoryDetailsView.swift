//
//  HistoryDetailsView.swift
//  StartTimeLine
//
//  Created by Lushitong on 2024/12/25.
//

import SwiftUI

struct HistoryDetailsView: View {
    @State private var hasLoaded = false
    @Environment(\.colorScheme) var colorScheme
    @State private var currentPage: Int = 0
    @State private var shareNum: String?
    
    @EnvironmentObject var model: Model
    
    @State private var datas: [EventListData]?
    @State private var allTimeDatas: [EventTimeLineModel]?
    @State var contentHasScrolled = true
    // 是不是第一次请求过
    @State private var requestStartId = ""
    
    var body: some View {
        ZStack(alignment: .top, content: {
            // 底部是一个背景图
            CachedImage(url: model.coverUlr ?? "", cornerRadius: 0)
                .overlay {
                    Rectangle()
                        .foregroundColor(.black.opacity(0.01))
                }
            
            GeometryReader { geometry in
                TabView(selection: $currentPage) {
                    // 反转数组顺序来实现向右滑动
                    ForEach(Array((datas ?? []).enumerated().reversed()), id: \.element.id) { index, item in
                        PageView(item: item)
                            .tag(index)
                            .frame(width: geometry.size.width)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                // 添加自定义转场动画
                .transition(.slide)
                // 设置滑动方向
                .environment(\.layoutDirection, .rightToLeft)
            }
            
            VStack(spacing: 0) {
                // 顶部导航栏
                HistoryTopBarView(shareNum: $shareNum, allTimeDatas: $allTimeDatas, contentHasScrolled: $contentHasScrolled)
                    .background(Color.clear)
            }
        })
        .statusBarStyle(.lightContent)
        .onAppear {
            if model.startSid == ""  || requestStartId == model.startSid {
                return
            }
            requestStartId = model.startSid
            loadData()
            getTimeLinesAllInfo()
        }
        .onChange(of: model.startSid) { newValue in
            if newValue == "" {
                return
            }
            requestStartId = newValue
            loadData()
            getTimeLinesAllInfo()
        }
        .onDisappear {}
    }
    
    private func loadData() {
        getEventListRequest { _, _ in
            // 设置初始页为最后一个（最新的）
            currentPage = (datas ?? []).count - 1
        }
    }
    
    func getEventListRequest(completion: @escaping ([EventListData]?, String?) -> Void) {
        let params = [
            "sid": model.startSid
        ] as [String: Any]
        // 发送网络请求并处理响应
        NetWorkManager.ydNetWorkRequest(.eventList(params)) { requestObj in
            if requestObj.status == .success {
                let json: [[String: Any]] = requestObj.data?["list"] as! [[String: Any]]
                datas = json.kj.modelArray(EventListData.self).reversed()
                completion(datas, requestObj.msg)
            } else {
                completion(nil, requestObj.msg)
            }
        }
    }
    
    // /api/timelines/all-index/:sid 获取明星所有的信息 用于二级的页面 或者本页面
    func getTimeLinesAllInfo() {
        let params = [
            "sid": model.startSid
        ] as [String: Any]
        
        NetWorkManager.ydNetWorkRequest(.eventTimeLineAllInfo(params)) { requestObj in
            if requestObj.status == .success {
                let json: [[String: Any]] = requestObj.data?["list"] as! [[String: Any]]
                let datas = json.kj.modelArray(EventTimeLineModel.self)
                var count = 0
                for item in datas {
                    count += item.count ?? 0
                }
                self.allTimeDatas = datas
                shareNum = "\(count)"
            }
        }
    }
}

struct PageView: View {
    let item: EventListData
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical, showsIndicators: false) {
                // 展示阴历 阳历
                Text(item.solarDate ?? "")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
                    .bold()
                    .padding(.top, 200)
                
                Text(item.lunarDate ?? "")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .bold()
                    .padding(.bottom, 12)
                
                if (item.list ?? []).isEmpty {
                    ContentCell(data: nil, showAdd: true, showTitle: item.solarDate)
                        .padding(.bottom, 12)
                } else {
                    VStack(spacing: 0) {
                        ForEach(item.list ?? [], id: \.self) { content in
                            ContentCell(data: content, showAdd: false, showTitle: "")
                                .padding(.bottom, 12)
                        }
                    }
                    .padding(.bottom, 120)
                }
            }
            .simultaneousGesture(
                DragGesture()
                    .onChanged { _ in
                        // 开始拖动时收起键盘
                        isFocused = false
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                        to: nil,
                                                        from: nil,
                                                        for: nil)
                    }
            )
        }
        .environment(\.layoutDirection, .leftToRight)
    }
}

// 内容单元格  天假单元格
struct ContentCell: View {
    let data: EventListDetailsData?
    let showAdd: Bool
    let showTitle: String?
    var body: some View {
        HistoryItemView(data: data, showAdd: showAdd, showTitle: showTitle)
    }
}

#Preview {
    HistoryDetailsView()
}
