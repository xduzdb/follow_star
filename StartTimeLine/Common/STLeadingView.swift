//
//  STLeadingView.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/8/13.
//

import SwiftUI

struct STLeadingView: View {
    var content: AnyView?
    
    var body: some View {
        if content != nil {
            content
        } else {
            Color.clear
        }
    }
}

struct LBLeadingView_Previews: PreviewProvider {
    static var previews: some View {
        STLeadingView()
    }
}
