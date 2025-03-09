//
//  CustomFieldModifier.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/2.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.primary)
            .padding(15)
            .background(Color.hex("F7F6FB"))
            .cornerRadius(20)
            .modifier(OutlineOverlay(cornerRadius: 20))
    }
}

extension View {
    func customField(icon: String) -> some View {
        self.modifier(TextFieldModifier())
    }
}
