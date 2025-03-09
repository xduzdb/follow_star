//
//  STBackGroundView.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/8/13.
//

import SwiftUI

// 默认的背景
struct STBackgroundView: View {
    var content: AnyView?
    
    var body: some View {
        if content != nil {
            content
        } else {
            Color.clear
        }
    }
}

struct LBBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        STBackgroundView()
    }
}
