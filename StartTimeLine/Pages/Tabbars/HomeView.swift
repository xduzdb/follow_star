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
    @State var contentHasScrolled = false
    @EnvironmentObject var model: Model

    @State private var lineOffset: CGFloat = 35
    @State private var lineWidth: CGFloat = 20
    @State private var selectedIndex: Int = 1

    @State private var text = "微博"
    @State private var categories: [String] = []
    @State private var props: [Double] = []
    // 判断当前是否是开启通知
    @State private var isNotificationEnabled = false
    // 是不是第一次请求过
    @State private var requestStartId = ""

    // 是否展示底部弹框设置相关
    @Binding var showBottomSheet: Bool
    // 是否跳转到提醒设置页面
    @Binding var navigateToNextRemindView: Bool
    // 更换订阅页面
    @Binding var navigateToNextSubView: Bool
    // 更换封面
    @Binding var navigateToChangeCoverView: Bool

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            // 提醒设置
            NavigationLink(destination: Group {
                if !isNotificationEnabled {
                    RemindSettingView()
                } else {
                    UserPushNotificationsView()
                }
            }, isActive: $navigateToNextRemindView) {
                EmptyView()
            }

            NavigationLink(destination: SearchStartView(), isActive: $navigateToNextSubView) {
                EmptyView()
            }

            NavigationLink(destination: ChangeCoverView(startDetailModel: $startDetailModel), isActive: $navigateToChangeCoverView) {
                EmptyView()
            }

            // 可以滑动的视图
            ScrollView {
                ZStack(alignment: .top) {
                    scrollDetection
                        .frame(height: 0)

                    VStack(spacing: 12) {
                        topStartHomeView

                        socialDynamicView
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal)

                        // 底部 发布统计
                        HomeStatisticsView(data: 1.0) {
                            HomeStartStatisticsView(statisticsModel: startStatisticsModel)
                        }
                        .padding(.horizontal)

                        // 发布趋势
                        HomeTrendView(data: (startStatisticsModel?.history?.dates ?? []).count > 0 ? 1.0 : 0.0) {
                            STLineChartView(title: $text, categories: $categories, prop: $props)
                                .frame(height: 300)
                                .padding(.top, 12)
                        }
                        .padding(.horizontal)
                        .foregroundColor(.white)

                        Spacer()
                            .frame(height: 100)
                    }
                }
            }
            .ignoresSafeArea(.all, edges: .top)
            .coordinateSpace(name: "scroll")
        }
        .background(Color.mainBackColor())
        .ignoresSafeArea(.all, edges: .top)
        .overlay(HomeNaigtionBar(title: startDetailModel?.name ?? "", headUrl: startDetailModel?.avatar ?? "", contentHasScrolled: $contentHasScrolled, dismissModal: {
            showBottomSheet = true
        }))
        .onAppear {
            if requestStartId != model.startSid || requestStartId.isEmpty {
                checkNotificationStatus()
                getStartInfo()
                getAllHelpUrl()
            }
        }
    }

    // 用户的背景图 以及 头像还有名字
    var topStartHomeView: some View {
        ZStack(content: {
            GeometryReader { geometry in
                let minY = geometry.frame(in: .global).minY
                ZStack {
                    CachedImage(url: model.coverUlr ?? "", cornerRadius: 0)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width,
                               height: geometry.size.height + (minY > 0 ? minY : 0))
                        .clipped()
                        .offset(y: minY > 0 ? -minY : 0)
                }
            }

            // 添加一个从上到下的渐变
            VStack {
                Spacer()
                LinearGradient(gradient: Gradient(colors: [
                    Color.clear,
                    Color.mainBackColor().opacity(0.1),
                    Color.mainBackColor().opacity(0.2),
                    Color.mainBackColor().opacity(0.3),
                    Color.mainBackColor().opacity(0.5),
                    Color.mainBackColor().opacity(0.8),
                    Color.mainBackColor().opacity(0.9),
                    Color.mainBackColor().opacity(1),
                ]),
                startPoint: .top,
                endPoint: .bottom)
                    .frame(width: SCREEN_WIDTH, height: 180)
            }

            HStack(spacing: 0) {
                VStack(alignment: .leading) {
                    Spacer()
                    CachedImage(url: startDetailModel?.avatar ?? "", cornerRadius: 56 / 2.0)
                        .frame(width: 56.0, height: 56.0)
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

                    Text(startDetailModel?.name ?? "")
                        .font(.system(size: 28)).bold()
                }
                .padding(.leading, 28)
                .padding(.bottom, 0)

                Spacer()
            }
        })
        .frame(height: topBackHeight)
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
                        VStack(spacing: 0) {
                            HStack(spacing: 6) {
                                Image(systemName: "flame.fill") // 使用系统图标
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                                    .padding(.zero)

                                Button {
                                    YDToast.showCenterWithText(text: "功能开发中")
                                } label: {
                                    Text("1分钟")
                                        .foregroundColor(selectedIndex == 0 ? .color333333() : .black.opacity(0.4))
                                        .font(.system(size: selectedIndex == 0 ? 16 : 14))
                                        .bold()
                                }

                                // 设置宽高的不同
                                Rectangle()
                                    .frame(width: 1.4, height: 12)
                                    .cornerRadius(0.7)
                                    .foregroundColor(Color.black.opacity(0.2))
                                    .padding(.horizontal, 0)

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
                                .padding(.top, -4)
                        }
                    }
                    .padding(.top, 12)
                    .padding(.leading, 12)
                    .padding(.trailing, 12)

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
                            HomeDynamicView(dynamic: item)
                        }
                    }
                })
            }
            if !self.isNotificationEnabled {
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
        .padding(.vertical, 0)
    }

    var scrollDetection: some View {
        GeometryReader { proxy in
            let offset = proxy.frame(in: .named("scroll")).minY
            Color.clear.preference(key: ScrollPreferenceKey.self, value: offset)
        }
        .padding(.all, 0)
        .frame(height: 0)
        .onPreferenceChange(ScrollPreferenceKey.self) { value in
            withAnimation(.easeInOut) {
                if value < -topBackHeight {
                    contentHasScrolled = true
                } else {
                    contentHasScrolled = false
                }
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
        let centerItemView = HomeBottomAddSubscribeView(itemHeight: 280, sub: {
            customPopupView.hide()
            navigateToNextSubView = true
        })
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
        vProperty.touchWildToHide = "0"
        vProperty.maskViewColor = UIColor(white: 0, alpha: 0.5)
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
                    let params = ["sid": requestObj.data?["sid"] ?? ["sid": "1"]] as [String: Any]
                    if let sid = requestObj.data?["sid"] as? String {
                        if sid == requestStartId {
                            
                        } else {
                            model.startSid = sid
                            getHomeWdiget()
                            getCurrentDynamic(sid: sid)
                            getStatrDynamicStatistic(sid: sid)
                            NetWorkManager.ydNetWorkRequest(.getStartDetails(params), isShowErrMsg: false, completion: { requestObj in
                                if requestObj.status == .success {
                                    // 解析当前的明星信息 StartUserModel 使用KKJSON接
                                    self.startDetailModel = requestObj.data?.kj.model(StartUserModel.self)
                                    Model().savaCurrentStartInfo(data: requestObj.data ?? [:])
                                    model.coverUlr = self.startDetailModel?.coverUrl
                                    model.currentStartDetailModel = self.startDetailModel
                                    requestStartId = model.startSid
                                }
                            })
                        }
                    } else {
                        model.startSid = ""
                    }
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
        NetWorkManager.ydNetWorkRequest(.notice, isShowErrMsg: false, completion: { requestObj in
            if requestObj.status == .success {
                // 刷新首页的Widget
                let model = requestObj.data?.kj.model(StartWidgetInfoModel.self)
                var oneDayModel = OneDayModel(text: model?.text ?? "", imageUrl: model?.star?.widgetAvatar ?? "", type: model?.type ?? "")
                oneDayModel.refreshOptions = .all
                saveCacheModel(mode: oneDayModel)
            } else {}
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

    // 获取当前的社交动态 6746e9d100026267c34f 杨紫
    func getCurrentDynamic(sid: String) {
        let params = ["sid": sid] as [String: Any]
        NetWorkManager.ydNetWorkRequest(.startPost(params), completion: { requestObj in
            if requestObj.status == .success {
                if requestObj.data == nil {
                    self.startDynamicList = []
                } else {
                    if let data = requestObj.data,
                       let list = data["list"] as? [[String: Any]]
                    {
                        self.startDynamicList = list.kj.modelArray(StartDynamicModel.self)
                    } else {
                        self.startDynamicList = [] // Optionally set to an empty array or handle as needed
                    }
                }
            } else {
                self.startDynamicList = []
            }
        })
    }

    // 明星动态统计
    func getStatrDynamicStatistic(sid: String) {
        let params = ["sid": sid] as [String: Any]
        NetWorkManager.ydNetWorkRequest(.startDynamicStatistics(params), completion: { requestObj in
            if requestObj.status == .success {
                self.startStatisticsModel = requestObj.data?.kj.model(StartStatisticsModel.self)
                self.text = "微博"
                self.categories = self.startStatisticsModel?.history?.dates ?? []
                self.props = self.startStatisticsModel?.history?.items?.first?.data ?? []
            }
        })
    }

    func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isNotificationEnabled = settings.authorizationStatus == .authorized
            }
        }
    }

    // 获取各种帮助与反馈的URL
    func getAllHelpUrl() {
        NetWorkManager.ydNetWorkRequest(.allHelpUrl) { requestObj in
            if requestObj.status == .success {
                model.feedBackModel = requestObj.data?.kj.model(FeebBackModel.self)
            }
        }
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
                .padding(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0))

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
            }
        }
        .padding(.bottom, 40)
        .background(Color.mainBackColor())
    }
}

struct AlertModifier: ViewModifier {
    let height: CGFloat

    init(height: CGFloat = 360) {
        self.height = height
    }

    func body(content: Content) -> some View {
        if #available(iOS 16, *) {
            content
                .presentationDetents([.height(height)]) // iOS 16 and later
        } else {
            content
                .frame(height: height) // Fallback for iOS 15
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
//    HomeView(startDetailModel: nil)
}

struct ScrollPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct PopupBottomSecond: View {
    var body: some View {
        VStack(spacing: 12) {
            Image("chest")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 156, maxHeight: 156)

            Text("Personal offer")
                .foregroundColor(.black)
                .font(.system(size: 24))
                .padding(.top, 4)

            Text("Say hello to flexible funding – you're pre-screened for an exclusive personal loan offer through TD Bank. Enter your Personal Offer Code to get started.")
                .foregroundColor(.black)
                .font(.system(size: 16))
                .opacity(0.6)
                .multilineTextAlignment(.center)
                .padding(.bottom, 12)

            Text("Read More")
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .cornerRadius(12)
                .foregroundColor(.white)
                .padding(.horizontal, 64)
        }
        .padding(EdgeInsets(top: 37, leading: 24, bottom: 40, trailing: 24))
        .background(Color.white.cornerRadius(20))
    }
}
