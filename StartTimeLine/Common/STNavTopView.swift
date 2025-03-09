//
//  STNavTopView.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/8/13.
//

import SwiftUI

/// 自定义顶部视图
public struct NavTopView<Content>: View where Content: View {
    // 标题
    private var title: String = ""

    private var isDefaultTitleView: Bool = true
    
    private var titleView: STBackgroundView
    
    private var forgeground: Color = .black
    
    private var backColor: Color = .colorF5F5F5()
    
    private var background: STBackgroundView
    
    private var hiddenLine: Bool = true
    
    private var hasBackButton: Bool = true
    
    private var backButtonImageName: String?
    
    private var backButtonAction: LBTopBlock? = nil
    
    private var isBakcButtonBlack: Bool = true
    
    private var ignoringTopArea: Bool = true
    
    private var leadingView: STLeadingView
    
    private var trailingView: STTrailingView
    
    private var leadingMaxWidth: CGFloat = 80.0
    
    private var trailingMaxWidth: CGFloat = 80.0
    
    // 是不是debug状态
    private var isDebug: Bool = false
    
    private let content: Content
    
    public var body: some View {
        ZStack(alignment: .top) {
            ZStack {
                Color.clear
                self.content
            }
            .padding(.top, self.ignoringTopArea ? 0.0 : STHelper.NavigationBar.bottom)
            .frame(maxWidth: STHelper.screenHeight)
            
            ZStack(alignment: .bottom) {
                VStack {
                    HStack(alignment: .center, spacing: 0) {
                        HStack(spacing: 0) {
                            if self.hasBackButton {
                                STBackButton(named: self.backButtonImageName, isBlack: self.isBakcButtonBlack, foreground: self.forgeground, buttonAction: self.backButtonAction)
                            }
                            self.leadingView
                            Spacer()
                        }
                        .padding(.leading, 15.0)
                        .frame(maxWidth: self.leadingMaxWidth)
                        .background(self.isDebug ? Color.red : self.backColor)
                        
                        // 文字的显示
                        self.titleView
                            .frame(maxWidth: .infinity)
                            .background(self.isDebug ? Color.green : self.backColor)
                        
                        // trailing
                        HStack(spacing: 0) {
                            Spacer()
                            self.trailingView
                        }
                        .padding(.trailing, 15)
                        .frame(maxWidth: self.trailingMaxWidth)
                        .background(self.isDebug ? Color.red : self.backColor)
                    }
                    .frame(height: STHelper.NavigationBar.height)
                    .padding(.bottom, 0)
                    .foregroundColor(self.forgeground)
                    .background(self.backColor)
                    .clipped()
                }
                .padding(.top, STHelper.SafeArea.top)
                .foregroundColor(self.forgeground)
                .background(self.backColor)
                
                if !self.hiddenLine {
                    Divider()
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}

public extension NavTopView {
    init(@ViewBuilder content: () -> Content) {
        self.background = STBackgroundView()
        self.titleView = STBackgroundView()
        self.leadingView = STLeadingView()
        self.trailingView = STTrailingView()
        self.content = content()
    }
    
    func foreground(_ foreground: Color) -> NavTopView {
        var result = self
        result.forgeground = foreground
        if self.isDefaultTitleView {
            result.titleView.content = AnyView(LBDefaultTitleView(title: self.title, foreground: foreground))
        }
        return result
    }
    
    // 标题
    func title(_ title: String) -> NavTopView {
        var result = self
        result.title = title
        result.titleView.content = AnyView(LBDefaultTitleView(title: title, foreground: self.forgeground))
        return result
    }
    
    // 底下的线
    func hiddenLine(_ hidden: Bool) -> NavTopView {
        var result = self
        result.hiddenLine = hidden
        return result
    }
    
    func backColor(_ backColor: Color) -> NavTopView {
        var result = self
        result.backColor = backColor
        return result
    }
    
    // TODO: 设置返回的图片样式
//    public func backButtonImage(_ name:String) -> NavTopView {
//        var result = self
//        return result
//    }
    
    // 返回按钮
    func backButtonHidden(_ hidden: Bool) -> NavTopView {
        var result = self
        result.hasBackButton = !hidden
        return result
    }
    
    // 颜色相关
    func ignoringTopArea(_ ingore: Bool) -> NavTopView {
        var result = self
        result.ignoringTopArea = ingore
        return result
    }
    
    func maxWidth(leading: CGFloat = 80, trailing: CGFloat = 80) -> NavTopView {
        var result = self
        result.leadingMaxWidth = leading
        result.trailingMaxWidth = trailing
        return result
    }
    
    // 设置背景
    func background<Background>(_ background: Background) -> NavTopView where Background: View {
        var result = self
        result.background.content = AnyView(background)
        return result
    }

    func debug(_ debug: Bool) -> NavTopView {
        var result = self
        #if DEBUG
        result.isDebug = debug
        #endif
        return result
    }
    
    // titleView
    func navigationBarTitleView<Content: View>(@ViewBuilder titleView: () -> Content) -> NavTopView {
        let titleV = titleView()
        var result = self
        result.isDefaultTitleView = false
        result.titleView.content = AnyView(titleV)
        return result
    }
    
    /// navigationBarItems  leading & trailing
    func wrNavigationBarItems<Leading: View, Trailing: View>(
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing)
        -> some View
    {
        let vL = leading()
        let vT = trailing()
        var result = self
        result.leadingView.content = AnyView(vL)
        result.trailingView.content = AnyView(vT)
        return result
    }

    /// navigationBarItems leading
    func wrNavigationBarItems<Content: View>(@ViewBuilder leading: () -> Content) -> some View {
        let v = leading()
        var result = self
        result.leadingView.content = AnyView(v)
        return result
    }

    /// navigationBarItems trailing
    func wrNavigationBarItems<Content: View>(@ViewBuilder trailing: () -> Content) -> some View {
        let v = trailing()
        var result = self
        result.trailingView.content = AnyView(v)
        return result
    }
}

struct LBDefaultTitleView: View {
    let title: String
    let foreground: Color
    var body: some View {
        Text(self.title)
            .lineLimit(1)
            .foregroundColor(self.foreground)
            .font(.system(size: 17).bold())
    }
}
