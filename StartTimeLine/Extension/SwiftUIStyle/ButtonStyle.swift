//
//  ButtonStyle.swift
//  StartTimeLine
//
//  Created by sto on 2024/9/17.
//

import SwiftUI

// 主要的按钮style 加入自定义圆角的大小

struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.startBackColor(), Color.endBackColor()]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
            .overlay(
                configuration.label
                    .foregroundColor(.white)
                    .padding()
            )
    }
}

struct GradientCornerRadiusButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.startBackColor(), Color.endBackColor()]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12)) // 修改这里
            .overlay(
                configuration.label
                    .foregroundColor(.white)
                    .padding()
            )
    }
}

struct GradientWidthCornerRadiusButtonStyle: ButtonStyle {
    var width: CGFloat
    var height: CGFloat
    var cornerRadius: CGFloat
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: width, height: height)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.startBackColor(), Color.endBackColor()]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius)) // 修改这里
    }
}

// 次要的按钮
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.colorEEEEEE())
            .clipShape(Capsule())
            .overlay(
                configuration.label
                    .foregroundColor(.white)
                    .padding()
            )
    }
}
