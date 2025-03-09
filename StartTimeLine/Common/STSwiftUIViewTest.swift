//
//  STSwiftUIViewTest.swift
//  StartTimeLine
//
//  Created by 卢仕彤 on 2024/12/19.
//

import SwiftUI

struct STSwiftUIViewTest: View {
    @State private var text = "微博"
    @State private var categories = ["11-01","2-01","3-1"]
    @State private var prop: [Double] = [10.0, 20.0, 30.0]
    
    var body: some View {
        STLineChartView(title: $text, categories: $categories, prop: $prop)
            .frame(width:  STHelper.screenWidth - 42,height: (STHelper.screenWidth - 42) * 192 / 305.0)
    }
}

#Preview {
    STSwiftUIViewTest()
}
