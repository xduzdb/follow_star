//
//  HomeView.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/8/3.
//

import FWPopupView
import SDWebImageSwiftUI
import SwiftUI
import WidgetKit

let topBackHeight = 420.0

struct HomeView: View {
    @State var hasScrolled = false
    @State var startDetailModel: StartUserModel?
    @State var startStatisticsModel: StartStatisticsModel?
    // 动态的列表
    @State var startDynamicList: [StartDynamicModel]?
    @State var contentHasScrolled = true
    @EnvironmentObject var model: Model

    @State private var lineOffset: CGFloat = -15
    @State private var lineWidth: CGFloat = 20
    @State private var selectedIndex: Int = 0

    @AppStorage(StartDataKey, store: UserDefaults(suiteName: AppGroupIdentifier))
    private var startStorage: Data?

    // 是否展示底部弹框设置相关
    @State private var showBottomSheet = false
    // 是否跳转到提醒设置页面
    @State private var navigateToNextRemindView = false
    // 更换订阅页面
    @State private var navigateToNextSubView = false
    // 更换封面
    @State private var navigateToChangeCoverView = false

    // 判断当前是否是开启通知
    @State private var isNotificationEnabled = false
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            // 提醒设置
            NavigationLink(destination: RemindSettingView(), isActive: $navigateToNextRemindView) {
                EmptyView()
            }

            NavigationLink(destination: SearchStartView(), isActive: $navigateToNextSubView) {
                EmptyView()
            }

            NavigationLink(destination: ChangeCoverView(), isActive: $navigateToChangeCoverView) {
                EmptyView()
            }

            // 可以滑动的视图
            ScrollView {
                scrollDetection

                // 顶部的详情
                topStartHomeView
                    .frame(maxHeight: 420)
                    .offset(y: -20)
                    .padding(.vertical, 0)

                socialDynamicView
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.vertical, 0)
                    .padding(.horizontal)

                // 底部 发布统计
                HomeStatisticsView(data: [1]) {
                    HomeStartStatisticsView(statisticsModel: startStatisticsModel)
                }
                .padding(.horizontal)
                .foregroundColor(.white)

                // 发布趋势
                HomeTrendView {
                    Text("")
                }
                .padding(.horizontal)
                .foregroundColor(.white)

                // 底部增加100 高度
                Spacer()
                    .frame(height: 200)
            }
            .coordinateSpace(name: "scroll")
        }
        .background(Color.mainBackColor())
        .ignoresSafeArea(.all, edges: .top)
        .overlay(HomeNaigtionBar(title: startDetailModel?.name ?? "", headUrl: startDetailModel?.avatar ?? "", contentHasScrolled: $contentHasScrolled, dismissModal: {
            showBottomSheet = true
        }))
        .sheet(isPresented: $showBottomSheet) {
            StarAlertView(pushTypeAction: { index in
                showBottomSheet = false
                if index == 0 {
                    navigateToNextRemindView = true
                } else if index == 1 {
                    navigateToNextSubView = true
                } else {
                    navigateToChangeCoverView = true
                }
            })
            .modifier(AlertModifier())
        }
        .onAppear {
            getStartInfo()
            checkNotificationStatus()
            getCurrentDynamic()
        }
    }

    // 用户的背景图 以及 头像还有名字
    var topStartHomeView: some View {
        ZStack {
            WebImage(url: URL(string: startDetailModel?.cover?.url ?? startDetailModel?.avatar ?? "")) { image in
                // 图片等比例缩放模式
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: SCREEN_WIDTH, height: topBackHeight, alignment: .center)
                    .clipped()

            } placeholder: {
                Rectangle()
                    .frame(width: SCREEN_WIDTH, height: topBackHeight, alignment: .center)
                    .foregroundColor(.gray)
            }

            HStack(spacing: 0) {
                VStack(alignment: .leading) {
                    Spacer()
                    WebImage(url: URL(string: startDetailModel?.avatar ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 56, height: 56, alignment: .center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 34.0)
                                    .stroke(LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.0)
                            )
                    } placeholder: {
                        Rectangle()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 56, height: 56, alignment: .center)
                            .foregroundColor(.gray)
                    }

                    Text(startDetailModel?.name ?? "")
                        .font(.system(size: 28)).bold()
                }
                .padding(.leading, 28)
                .padding(.zero)
                Spacer()
            }
        }
    }

    // 社交动态的view
    var socialDynamicView: some View {
        VStack(spacing: 0) {
            ZStack {
                VStack(alignment: .leading, content: {
                    HStack(alignment: .center) {
                        Text("社交动态")
                            .font(.system(size: 16))
                            .bold()

                        Spacer()

                        // 是24小时还是 1分钟
                        VStack {
                            HStack {
                                Image(systemName: "flame.fill") // 使用系统图标
                                    .foregroundColor(.red)
                                    .font(.system(size: 16))
                                    .padding(.zero)

                                Text("一分钟")
                                    .foregroundColor(selectedIndex == 0 ? .color333333() : .black.opacity(0.4))
                                    .font(.system(size: selectedIndex == 0 ? 16 : 14))
                                    .bold()
                                    .onTapGesture {
                                        withAnimation {
                                            selectedIndex = 0
                                            lineOffset = -15
                                        }
                                    }

                                Text("24小时")
                                    .font(.system(size: selectedIndex == 1 ? 16 : 14))
                                    .bold()
                                    .foregroundColor(selectedIndex == 1 ? .color333333() : .black.opacity(0.4))
                                    .onTapGesture {
                                        withAnimation {
                                            selectedIndex = 1
                                            lineOffset = 40
                                        }
                                    }
                            }
                            .padding(.zero)

                            // 可滑动的横线
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.red)
                                .frame(width: lineWidth, height: 4)
                                .offset(x: lineOffset)
                                .animation(.easeInOut, value: lineOffset)
                                .padding(.top, -10)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.leading, 12)
                    .padding(.trailing, 20)

                    // 如果是空的 显示空视图
                    if (startDynamicList ?? []).isEmpty {
                        HStack(alignment: .center) {
                            Spacer()
                            VStack {
                                String.BundleImageName("home_empty")
                                    .frame(width: 120, height: 80)

                                Text("暂无动态")
                                    .font(.system(size: 13))
                                    .foregroundColor(.color666666())
                                    .padding(.zero)

                                Text(selectedIndex == 0 ? "1分钟内暂未发布任何内容" : "24小时内暂未发布任何内容")
                                    .font(.system(size: 13))
                                    .foregroundColor(.color999999())
                                    .padding()
                            }
                            Spacer()
                        }
                    } else {
                        // LazyVGrid 展示列表
                        ForEach(startDynamicList ?? [], id: \.self) { item in
                            HomeDynamicView(dynamic: item) // 使用 HomeDynamicView 显示每个动态
                        }
                    }
                })
            }
            // 是否开启通知
            if !isNotificationEnabled
            {
                ZStack {
                    RoundedRectangle(cornerRadius: 0)
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [.startBackColor(), .endBackColor()]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(width: .infinity, height: 48)

                    HStack(content: {
                        String.BundleImageName("home_voice_icon")
                            .frame(width: 20, height: 20)

                        Text("开通消息通知，获取实时新动态")
                            .font(.system(size: 14))
                            .foregroundColor(.white)

                        Spacer()
                        // 右边的按钮 去设置 背景是白色
                        Button(action: {
                            navigateToNextRemindView = true
                        }) {
                            Text("去设置")
                                .font(.system(size: 14))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .cornerRadius(12)
                        }

                    })
                    .padding(.horizontal)
                }
            }
        }
        .frame(width: .infinity)
        .frame(minHeight: 270)
        .padding(.vertical, 0)
    }

    var scrollDetection: some View {
        GeometryReader { proxy in
            let offset = proxy.frame(in: .named("scroll")).minY
            Color.clear.preference(key: ScrollPreferenceKey.self, value: offset)
        }
        .onPreferenceChange(ScrollPreferenceKey.self) { value in
            withAnimation(.easeInOut) {
                if value < 0 {
                    contentHasScrolled = true
                } else {
                    contentHasScrolled = false
                }
            }
        }
    }
    
    func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isNotificationEnabled = settings.authorizationStatus == .authorized
            }
        }
    }

    // 展示开始分钟监控的弹框
    func showStartMinuteAlert() {
        let customPopupView = FWCustomSheetView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 56, height: 360))
        let centerItemView = HomeCenterItemView(itemHeight: 370)
            .edgesIgnoringSafeArea(.all)
        let hostingController = UIHostingController(rootView: centerItemView)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        customPopupView.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: customPopupView.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: customPopupView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: customPopupView.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: customPopupView.bottomAnchor),
        ])

        hostingController.view.layer.cornerRadius = 15
        hostingController.view.backgroundColor = .alertBackColor()
        customPopupView.addSubview(hostingController.view)
        customPopupView.layer.cornerRadius = 15

        let vProperty = FWPopupViewProperty()
        vProperty.popupCustomAlignment = .center
        vProperty.backgroundColor = UIColor.alertBackColor()
        vProperty.popupAnimationType = .scale3D
        vProperty.maskViewColor = UIColor(white: 0, alpha: 0.5)
        vProperty.touchWildToHide = "1"
        vProperty.popupViewEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        vProperty.animationDuration = 0.25
        customPopupView.vProperty = vProperty

        customPopupView.show()
    }

    // 展示添加订阅的
    func showAddSubscribeAlert() {
        let customPopupView = FWCustomSheetView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 260))
        let centerItemView = HomeBottomAddSubscribeView(itemHeight: 280)
            .edgesIgnoringSafeArea(.all)
        let hostingController = UIHostingController(rootView: centerItemView)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        customPopupView.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: customPopupView.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: customPopupView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: customPopupView.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: customPopupView.bottomAnchor),
        ])

        hostingController.view.layer.cornerRadius = 15
        hostingController.view.backgroundColor = .white
        customPopupView.addSubview(hostingController.view)
        customPopupView.layer.cornerRadius = 15

        let vProperty = FWPopupViewProperty()
        vProperty.popupCustomAlignment = .bottomCenter
        vProperty.backgroundColor = UIColor.white
        vProperty.popupAnimationType = .position
        vProperty.maskViewColor = UIColor(white: 0, alpha: 0.5)
        vProperty.touchWildToHide = "1"
        vProperty.popupViewEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        vProperty.animationDuration = 0.25
        customPopupView.vProperty = vProperty

        customPopupView.show()
    }

    // 获取明星的最新信息 判断是否订阅了明星
    func getStartInfo() {
        NetWorkManager.ydNetWorkRequest(.subscribeStart, completion: { requestObj in
            if requestObj.status == .success {
                // 如果订阅了某个明星 则显示某个明星
                if requestObj.jsonStr?.isEmpty == true {
                    getHomdeDefaultStart()
                    showAddSubscribeAlert()
                } else {
                    // 拿到requestObj.data.sid 进行网络请求
                    let params = ["sid": requestObj.data?["sid"] ?? ["sid": "1"]] as [String: Any]
                    if let sid = requestObj.data?["sid"] as? String {
                        model.startSid = sid
                        getHomeWdiget()
                        getCurrentDynamic()
                        getStatrDynamicStatistic()

                    } else {
                        model.startSid = "" // 或者您可以设置为其他默认值
                    }
                    NetWorkManager.ydNetWorkRequest(.getStartDetails(params), isShowErrMsg: false, completion: { requestObj in
                        if requestObj.status == .success {
                            // 解析当前的明星信息 StartUserModel 使用KKJSON接
                            self.startDetailModel = requestObj.data?.kj.model(StartUserModel.self)
                        } else {
                        }
                    })
                }

            } else {
                // 如果没有订阅明星 则获取首页默认的明星
                if requestObj.code == 404 {
                    getHomdeDefaultStart()
                }
            }
        })
    }

    // 获取挂件的信息
    func getHomeWdiget() {
        if model.startSid.isEmpty {
            return
        }

        NetWorkManager.ydNetWorkRequest(.notice, isShowErrMsg: false, completion: { requestObj in
            if requestObj.status == .success {
                // 刷新首页的Widget
                let model = requestObj.data?.kj.model(StartWidgetInfoModel.self)
                var oneDayModel = OneDayModel(text: model?.text ?? "", imageUrl: model?.star?.avatar ?? "", type: model?.type ?? "")
                oneDayModel.refreshOptions = .all
                saveCacheModel(mode: oneDayModel)
            } else {
            }
        })
    }

    // 获取首页默认的明星
    func getHomdeDefaultStart() {
        NetWorkManager.ydNetWorkRequest(.defaultStart, completion: { requestObj in
            if requestObj.status == .success {
                self.startDetailModel = requestObj.data?.kj.model(StartUserModel.self)
            }
        })
    }

    // 获取当前的社交动态
    func getCurrentDynamic() {
        if model.startSid.isEmpty {
            return
        }

        let params = ["sid": model.startSid] as [String: Any]
        NetWorkManager.ydNetWorkRequest(.startPost(params), completion: { requestObj in
            if requestObj.status == .success {
                // 转换为startDynamicList
                let json: [[String: Any]] = requestObj.data?["list"] as! [[String: Any]]
                self.startDynamicList = json.kj.modelArray(StartDynamicModel.self)
            }
        })
    }

    // 明星动态统计
    func getStatrDynamicStatistic() {
        if model.startSid.isEmpty {
            return
        }
        let params = ["sid": model.startSid] as [String: Any]
        NetWorkManager.ydNetWorkRequest(.startDynamicStatistics(params), completion: { requestObj in
            if requestObj.status == .success {
                self.startStatisticsModel = requestObj.data?.kj.model(StartStatisticsModel.self)
            }
        })
    }
}

// 生成一个view 里面包含一个label 一个button 一个imageview
struct StarAlertView: View {
    var pushTypeAction: (Int) -> Void
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: 50, height: 6)
                .cornerRadius(3)
                .foregroundColor(Color.hex("D9D9D9"))
                .padding(EdgeInsets(top: 6, leading: 0, bottom: 24, trailing: 0))

            VStack(spacing: 16) {
                HomeBottomSheetItemView(title: "提醒设置", subTitle: "提醒设置", leftImageName: "home_notication")
                    .onTapGesture {
                        pushTypeAction(0)
                    }
                HomeBottomSheetItemView(title: "更换订阅", subTitle: "提醒设置", leftImageName: "home_subscribe")
                    .onTapGesture {
                        pushTypeAction(1)
                    }
                HomeBottomSheetItemView(title: "更换封面", subTitle: "提醒设置", leftImageName: "home_cover")
                    .onTapGesture {
                        pushTypeAction(2)
                    }
                Spacer()
            }
            Spacer()
        }
        .background(Color.mainBackColor())
        .padding(.zero)
    }
}

struct AlertModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16, *) {
            content
                .presentationDetents([.height(360)]) // iOS 16 and later
        } else {
            content
                .frame(height: 360) // Fallback for iOS 15
        }
    }
}

// 保存的Widget
extension HomeView {
    func saveCacheModel(mode: OneDayModel) {
        OneDayStore.cacheModel(mode)
        reloadWidget()
    }

    func reloadWidget() {
        WidgetCenter.shared.getCurrentConfigurations { result in
            guard case let .success(widgets) = result else { return }
            guard let widget = widgets.first(where: { $0.family == .systemMedium }) else { return }
            WidgetCenter.shared.reloadTimelines(ofKind: widget.kind)
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
}

#Preview {
    HomeView(startDetailModel: nil)
}

struct ScrollPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
