//
//  MarqueeView.swift
//  StartTimeLine
//
//  Created by sto on 2024/11/8.
//

import SwiftUI

// 方法1：使用 struct 封装所有参数
struct MarqueeSettings {
    let text: String
    let fontSize: Double
    let textColor: Color
    let backgroundColor: Color
    let isBold: Bool
    let speed: Double
    let isReverse: Bool
    let selectedFont: FontType
}

struct MarqueeView: View {
    // 使用 @State 使属性可变，以便后续可能的调整
    @State private var settings: MarqueeSettings

    // 初始化方法
    init(settings: MarqueeSettings) {
        _settings = State(initialValue: settings)
    }

    var body: some View {
        VStack {
            // 展示跑马灯效果 后续可以支持图片 等待处理
            Marquee {
                Text(settings.text)
                    .fontWeight(settings.isBold ? .bold : .regular)
                    .foregroundColor(settings.textColor)
                    .font(settings.selectedFont.font(size: settings.fontSize))
            }
            .marqueeDuration(settings.speed)
            .marqueeDirection(settings.isReverse ? .left2right : .right2left)
            .background(settings.backgroundColor)
        }
        .navigationBarHidden(true) // 隐藏导航栏
        .edgesIgnoringSafeArea(.all) // 忽略安全区域，实现全屏效果
        .onAppear {
            // 进入页面时锁定横屏
            OrientationController.shared.lockOrientation(.landscape)
            // 设置屏幕常亮
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            // 离开页面时恢复竖屏
            OrientationController.shared.lockOrientation(.portrait)
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
}

// 添加屏幕方向控制器
class OrientationController: ObservableObject {
    static let shared = OrientationController()

    func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if #available(iOS 16.0, *) {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientation))
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
