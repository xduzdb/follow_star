//
//  STTrailingView.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/8/13.
//

import SwiftUI

struct STTrailingView: View {
    var content: AnyView?
    
    var body: some View {
        if content != nil {
            content
        } else {
            Color.clear
        }
    }
}

struct STTrailingView_Previews: PreviewProvider {
    static var previews: some View {
        STTrailingView()
    }
}
