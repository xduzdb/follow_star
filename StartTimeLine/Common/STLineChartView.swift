//
//  STLineChartView.swift
//  StartTimeLine
//
//  Created by Lushitong on 2024/12/19.
//

import AAInfographics
import SwiftUI

struct STLineChartView: UIViewRepresentable {
    
    typealias Context = UIViewRepresentableContext<STLineChartView>
    
    @Binding var title: String
    @Binding var categories: [String]
    @Binding var prop: [Double]
    
    func makeUIView(context: Context) -> AAChartView {
        let aaChartView = AAChartView()
        
        let chartModel = AAChartModel()
            .chartType(.spline) // 图表类型
            .title("") // 图表主标题
            .inverted(false) // 是否翻转图形
            .yAxisTitle("") // Y 轴标题
            .legendEnabled(true) // 是否启用图表的图例(图表底部的可点击的小圆点)
            .tooltipValueSuffix("次") // 浮动提示框单位后缀
            .categories(categories)
            .colorsTheme(["#1677FF"]) // 主题颜色数组
            .series([
                AASeriesElement()
                    .name(title)
                    .data(prop),
            ])
        
        aaChartView.aa_drawChartWithChartModel(chartModel)
        return aaChartView
    }
    
    public func updateUIView(_ uiView: AAChartView, context: Context) {}
}
