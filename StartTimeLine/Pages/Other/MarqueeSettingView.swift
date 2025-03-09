//
//  MarqueeSettingView.swift
//  StartTimeLine
//
//  Created by sto on 2024/11/8.
//

import SwiftUI

// 修改 FontCategory 枚举，添加 CaseIterable 协议
enum FontCategory: String, CaseIterable {
    case system = "系统字体"
    case basic = "基础字体"
    case decorative = "装饰字体"
    case chinese = "中文字体"
    case monospaced = "等宽字体"
}

enum FontType: String, CaseIterable {
    case system = "System"

    // 英文基础字体
    case helvetica = "Helvetica"
    case helveticaNeue = "Helvetica Neue"
    case arial = "Arial"
    case timesNewRoman = "Times New Roman"
    case georgia = "Georgia"
    case futura = "Futura"
    case menlo = "Menlo"

    // 装饰性英文字体
    case zapfino = "Zapfino"
    case chalkboard = "Chalkboard SE"
    case noteworthy = "Noteworthy"
    case bradleyHand = "Bradley Hand"
    case copperplate = "Copperplate"
    case optima = "Optima"
    case papyrus = "Papyrus"
    case partyLET = "Party LET"
    case snellRoundhand = "Snell Roundhand"

    // 中文字体
    case pingFangSC = "PingFang SC"
    case pingFangTC = "PingFang TC"
    case sTHeitiSC = "STHeiti SC"
    case sTHeitiTC = "STHeiti TC"
    case sTKaiti = "STKaiti"
    case sTSong = "STSong"
    case sTFangsong = "STFangsong"
    case gKKaiExtB = "GB18030 Bitmap"
    case heiTC = "Heiti TC"
    case heiSC = "Heiti SC"

    // 等宽字体
    case courierNew = "Courier New"
    case monaco = "Monaco"
    case americanTypewriter = "American Typewriter"

    // 获取实际字体
    func font(size: Double) -> Font {
        switch self {
        case .system:
            return .system(size: size)
        default:
            return .custom(rawValue, size: size)
        }
    }

    // 获取字体分类
    var category: FontCategory {
        switch self {
        case .system:
            return .system
        case .helvetica, .helveticaNeue, .arial, .timesNewRoman, .georgia, .futura, .menlo:
            return .basic
        case .zapfino, .chalkboard, .noteworthy, .bradleyHand, .copperplate, .optima, .papyrus, .partyLET, .snellRoundhand:
            return .decorative
        case .pingFangSC, .pingFangTC, .sTHeitiSC, .sTHeitiTC, .sTKaiti, .sTSong, .sTFangsong, .gKKaiExtB, .heiTC, .heiSC:
            return .chinese
        case .courierNew, .monaco, .americanTypewriter:
            return .monospaced
        }
    }
}

struct MarqueeSettingView: View {
    @State var marqueeText: String = ""
    @State private var selectedFont: FontType = .system
    // 可以配置 文字 文字颜色 背景 字体大小 背景颜色 是否加粗
    @State var textFontSize: Double = 12
    @State var textColor: Color = Color.white
    @State var backColor: Color = Color.black
    @State var isBold: Bool = false
    @State var speedText: Double = 1.0
    // 是否倒转
    @State var isRever: Bool = false

    var body: some View {
        NavTopView {
            VStack(spacing: 0) {
                HStack(spacing: 2) {
                    VStack(alignment: .leading, content: {
                        TextField("请输入滑动的文字", text: $marqueeText)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )

                        Text("字体大小:\(Int(textFontSize))")
                            .bold()

                        Slider(value: $textFontSize, in: 12 ... 300, step: 1)

                        Text("字体滚动速度:\(21 - Int(speedText))")
                            .bold()

                        Slider(value: $speedText, in: 1 ... 20, step: 1)

                        // 添加Switch控件组
                        Group {
                            HStack {
                                Text("字体选择")
                                    .bold()
                                Spacer()
                                Picker("字体", selection: $selectedFont) {
                                    ForEach(FontCategory.allCases, id: \.self) { category in
                                        Section(header: Text(category.rawValue)) {
                                            ForEach(FontType.allCases.filter { $0.category == category }, id: \.self) { font in
                                                Text(font.rawValue)
                                                    .font(font.font(size: 16))
                                                    .tag(font)
                                            }
                                        }
                                    }
                                }
                            }
                            // 控制文字是否加粗
                            HStack {
                                Text("文字加粗")
                                    .bold()
                                Spacer()
                                Toggle("", isOn: $isBold)
                                    .labelsHidden()
                            }

                            // 控制滚动方向
                            HStack {
                                Text("反向滚动")
                                    .bold()
                                Spacer()
                                Toggle("", isOn: $isRever)
                                    .labelsHidden()
                            }
                        }

                        // 选择颜色的组件
                        // 添加颜色选择器组
                        Group {
                            // 文字颜色选择器
                            HStack {
                                Text("文字颜色")
                                    .bold()
                                Spacer()
                                ColorPicker("", selection: $textColor)
                                    .labelsHidden()
                            }

                            // 背景颜色选择器
                            HStack {
                                Text("背景颜色")
                                    .bold()
                                Spacer()
                                ColorPicker("", selection: $backColor)
                                    .labelsHidden()
                            }
                        }

                        NavigationLink(destination: MarqueeView(settings: MarqueeSettings(text: marqueeText, fontSize: textFontSize, textColor: textColor, backgroundColor: backColor, isBold: isBold, speed: speedText, isReverse: isRever, selectedFont: selectedFont))) {
                            Text("展示滑动")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .disabled(marqueeText.isEmpty)

                        Spacer()
                    })
                    .padding()
                }
                .frame(maxHeight: .infinity)

                // 底部是展示区
                HStack {
                    Marquee {
                        Text(marqueeText)
                            .font(selectedFont.font(size: textFontSize))
                            .fontWeight(isBold ? .bold : .regular) // 根据isBold状态设置字重
                            .foregroundColor(textColor)
                            .font(.system(size: textFontSize))
                    }
                    .marqueeDuration(speedText)
                    .marqueeDirection(isRever ? .left2right : .right2left)
                    .background(backColor)
                }
                .frame(maxHeight: .infinity)
            }
        }
        .title("手持弹幕")
        .ignoringTopArea(false)
    }
}

#Preview {
    MarqueeSettingView()
}
