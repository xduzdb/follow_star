//
//  HistoryItemView.swift
//  StartTimeLine
//
//  Created by Lushitong on 2024/12/27.
//

import SwiftUI

struct HistoryItemView: View {
    @State var data: EventListDetailsData?
    let showAdd: Bool
    let showTitle: String?

    @State private var showBottomSheet = false
    @State private var nickname: String = ""
    @State private var showAddEvent = false
    @State private var showShareView = false
    
    var body: some View {
        VStack {
            // 使用示例3：自定义内边距
            BlurredRectangle(
                cornerRadius: 12,
                horizontalPadding: 0,
                verticalPadding: 0
            ) {
                VStack(alignment: .leading) {
                    HStack {
                        ZStack(alignment: .leading) {
                            String.BundleImageName("tab_bar_today")
                                .resizable()
                                .frame(width: 123, height: 40)
                            
                            HStack(spacing: 0) {
                                String.BundleImageName("calendar")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .padding(.leading, 12)
                             
                                Text("那年今日")
                                    .font(.system(size: 14))
                                    .bold()
                                    .foregroundColor(.colorF05F49())
                                    .padding(.leading, 4)
                            }
                            .padding(.top, 4)
                            .padding(.zero)
                        }
                        
                        Spacer()
                        
                        if !showAdd {
                            String.BundleImageName("reply")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.trailing, 12)
                                .background(
                                    NavigationLink(
                                        destination: HistoryShareView(data: data), // 如果需要传递 model
                                        isActive: $showShareView
                                    ) { EmptyView() }
                                )
                                .onTapGesture {
                                    showShareView = true
                                }
                        }
                    }
                    
                    if showAdd {
                        Text(showTitle ?? "")
                            .font(.system(size: 18))
                            .bold()
                            .foregroundColor(.white)
                            .padding(.bottom, 1)
                            .padding(.leading, 12)
                    }
                    
                    if showAdd {
                        HStack {
                            Spacer()
                            VStack {
                                String.BundleImageName("empty_place_holder")
                                    .resizable()
                                    .frame(width: 120, height: 120)
                                
                                Text("今日我想静静！好好爱自己哦！")
                                    .font(.system(size: 13))
                                    .foregroundColor(.colorC9CDD4())
                                
                                // 添加时间
                                HStack {
                                    String.BundleImageName("tips_plus")
                                        .resizable()
                                        .frame(width: 16, height: 15)
                                    
                                    Text("添加事件")
                                        .font(.system(size: 15))
                                        .foregroundColor(.colorEF5F49())
                                }
                                .background(
                                    WebViewNavigationLink(
                                        urlString: getShowAddUrl(),
                                        isActive: $showAddEvent
                                    )
                                )
                                .onTapGesture {
                                    showAddEvent = true
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.colorEF5F49().opacity(0.1))
                                .cornerRadius(16)
                                .padding(.top, 12)
                                .padding(.bottom, 40)
                                
                                STTextView(
                                    text: $nickname,
                                    placeholder: "哇！那年今日这么特别，说点什么吧！",
                                    maxLength: 400,
                                    height: 80,
                                    isHorCener: false,
                                    backgroundColor: Color.colorEEEEEE(),
                                    placeholderColor: Color.colorC9CDD4(),
                                    cornerRadius: 12,
                                    fontSize: 14
                                ) { submittedText in
                                    nickname = submittedText
                                }
                                .ignoresSafeArea(.keyboard) // 方案1：忽略键盘安全区域
                                .padding(.horizontal, 0)
                                .padding(.bottom, 12)
                            }
                            Spacer()
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                        
                    } else {
                        Text((data?.date ?? "").formatDateString())
                            .font(.system(size: 18))
                            .bold()
                            .foregroundColor(.white)
                            .padding(.bottom, 1)
                            .padding(.leading, 12)
                        
                        // 底部一个全部的页面
                        VStack(alignment: .leading, spacing: 8) {
                            // 主要内容
                            (Text("\(data?.text ?? "")")
                                .font(.system(size: 18))
                                .bold()
                                .foregroundColor(.color1D2129())
                                + Text(" ")
                                + Text(Image(systemName: "info.circle"))
                                .foregroundColor(.gray)
                            )
                            .onTapGesture {
                                showBottomSheet = true
                            }
                            .lineSpacing(8)
                            .multilineTextAlignment(.leading)
                                    
                            // 底部信息 居中的显示
                            VStack(spacing: 8) {
                                HStack {
                                    Spacer()
                                    ZStack {
                                        // 外圈圆圈
                                        if !(data?.isLike ?? false) {
                                            Circle()
                                                .stroke(Color.colorF05F49(), lineWidth: 1)
                                                .frame(width: 48, height: 48)
                                        } else {
                                            Circle()
                                                .foregroundColor(Color.colorF05F49()) // 使用 foregroundColor 设置填充颜色
                                                .frame(width: 48, height: 48)
                                        }
                                        
                                        Image((data?.isLike ?? false) ? "thumb_like" : "thumb_unlike")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                    }
         
                                    Spacer()
                                }
                                .onTapGesture {
                                    if data?.isLike ?? false {
                                        data?.likesCount = (data?.likesCount ?? 0) - 1
                                        unlike()
                                    } else {
                                        data?.likesCount = (data?.likesCount ?? 0) + 1
                                        like()
                                    }
                                    data?.isLike = !(data?.isLike ?? false)
                                }
                                
                                HStack {
                                    DashedLine()
                                        .frame(height: 1)
                                    
                                    Text("\(data?.likesCount ?? 0)人点赞")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 13))
                                        .padding(.horizontal, 8)
                                    
                                    DashedLine()
                                        .frame(height: 1)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 24)
                            }
                            .padding(.vertical, 24)
                            
                            // 底部输入框
                            STTextView(
                                text: $nickname,
                                placeholder: "哇！那年今日这么特别，说点什么吧！",
                                maxLength: 400,
                                height: 80,
                                isHorCener: false,
                                backgroundColor: Color.colorEEEEEE(),
                                placeholderColor: Color.colorC9CDD4(),
                                cornerRadius: 12,
                                fontSize: 14
                            ) { submittedText in
                                nickname = submittedText
                            }
                            .ignoresSafeArea(.keyboard) // 方案1：忽略键盘安全区域
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                    }
                }
                .sheet(isPresented: $showBottomSheet) {
                    HistoryFixEventView { text in
                        showBottomSheet = false
                        if text.count > 0 {
                            fixEvent(text: text)
                        }
                    }
                    .modifier(AlertModifier(height: 380))
                }
            }
        }
    }
    
    // 获取当前的链接
    func getShowAddUrl() -> String {
        let token = UserSharedManger.shared.getUserToken() ?? ""
        let urlString = eventUrlStr(token: token)
        return urlString
    }
    
    // 纠错功能
    func fixEvent(text: String) {
        let params = ["comment": text, "type": "2", "timeline_id": data?.id ?? 0] as [String: Any]
        NetWorkManager.ydNetWorkRequest(.commentsEvent(params), isShowErrMsg: false, completion: { requestObj in
            if requestObj.status == .success {
                YDToast.showCenterWithText(text: "修改成功")
            } else {}
        })
    }
    
    // 点赞功能
    func like() {
        let params = ["timeline_id": data?.id ?? 0] as [String: Any]
        NetWorkManager.ydNetWorkRequest(.likeTimeLine(params), isShowErrMsg: false, completion: { requestObj in
            if requestObj.status == .success {}
        })
    }
    
    // 取消点赞
    func unlike() {
        let params = ["id": data?.id ?? 0] as [String: Any]
        NetWorkManager.ydNetWorkRequest(.unLikeTimeLine(params), isShowErrMsg: false, completion: { requestObj in
            if requestObj.status == .success {}
        })
    }
}

struct BlurredRectangle<Content: View>: View {
    let content: Content
    var cornerRadius: CGFloat = 12
    var horizontalPadding: CGFloat = 15
    var verticalPadding: CGFloat = 12
    var blurStyle: UIBlurEffect.Style = .regular
    var overlayOpacity: Double = 0.1
    var borderWidth: CGFloat = 0.5
    var borderOpacity: Double = 0.2
    
    init(
        cornerRadius: CGFloat = 12,
        horizontalPadding: CGFloat = 15,
        verticalPadding: CGFloat = 12,
        blurStyle: UIBlurEffect.Style = .regular,
        overlayOpacity: Double = 0.1,
        borderWidth: CGFloat = 0.5,
        borderOpacity: Double = 0.2,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.cornerRadius = cornerRadius
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.blurStyle = blurStyle
        self.overlayOpacity = overlayOpacity
        self.borderWidth = borderWidth
        self.borderOpacity = borderOpacity
    }
    
    var body: some View {
        content
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(
                ZStack {
                    // 高斯模糊层，增加不透明度
                    Rectangle()
                        .fill(.ultraThinMaterial) // 毛玻璃效果
                        
                    // 添加一个轻微的白色叠加层，增加亮度
                    Rectangle()
                        .fill(Color.white.opacity(0.4))
                }
                .allowsHitTesting(false) // 允许点击穿透
            )
            .cornerRadius(cornerRadius)
            .frame(width: UIScreen.main.bounds.width - 30)
    }
}

struct CommentInputView: View {
    @State private var text: String = ""
    @FocusState private var isFocused: Bool
    let maxLength: Int = 200
    var onSubmit: (String) -> Void
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            if #available(iOS 16.0, *) {
                TextField("哇！那年今日这么特别，说点什么吧！", text: $text, axis: .vertical)
                    .textFieldStyle(.plain)
                    .lineLimit(5)
                    .focused($isFocused)
                    .padding()
                    .frame(height: 100)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .onChange(of: text) { newValue in
                        if newValue.count > maxLength {
                            text = String(newValue.prefix(maxLength))
                        }
                    }
            } else {
                // Fallback on earlier versions
                TextEditor(text: $text)
                    .frame(height: 100)
                    .focused($isFocused)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        Group {
                            if text.isEmpty {
                                Text("哇！那年今日这么特别，说点什么吧！")
                                    .foregroundColor(Color(.placeholderText))
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 8)
                            }
                        }
                        .allowsHitTesting(false)
                        .padding(.leading, 4)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    )
                    .onChange(of: text) { newValue in
                        if newValue.count > maxLength {
                            text = String(newValue.prefix(maxLength))
                        }
                    }
            }
        }
        .padding(.vertical, 0)
    }
}

struct DashedLine: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: geometry.size.height/2))
                path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height/2))
            }
            .stroke(style: SwiftUI.StrokeStyle(
                lineWidth: 1,
                dash: [4]
            ))
            .foregroundColor(.gray)
        }
    }
}

#Preview {
    HistoryItemView(data: EventListDetailsData(id: "12"), showAdd: true, showTitle: "13123")
}
