//
//  Ber.swift
//  StartTimeLine
//
//  Created by Lushitong on 2024/12/31.
//

import SwiftUI

// 自定义一个二次贝塞尔曲线形状，继承自Shape协议
struct Ber: View {
    @State private var curveFactorValue: CGFloat = 20

        var body: some View {
            VStack {
                WaveShape()
                    .fill(Color.red)
                    .frame(height: 200)
                    .padding()
            }
        }
}



struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // 开始点（左上角）
        path.move(to: CGPoint(x: 0, y: 0))
        
        // 上边直线
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        
        // 右边直线
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        
        // 波浪曲线（从右到左）
        let curveHeight = rect.height * 0.01 // 波浪高度
        
        path.addCurve(
            to: CGPoint(x: 0, y: rect.height), // 终点（左下角）
            control1: CGPoint(x: rect.width * 0.75, y: curveHeight), // 第一个控制点
            control2: CGPoint(x: rect.width * 0.25, y: curveHeight)  // 第二个控制点
        )
        
        // 闭合路径
        path.closeSubpath()
        
        return path
    }
}
#Preview {
    Ber()
}
