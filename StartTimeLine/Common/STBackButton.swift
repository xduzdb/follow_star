//
//  STBackButton.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/8/13.
//

import SwiftUI

struct STBackButton: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var named: String?
    var isBlack: Bool = true
    var foreground: Color = .black
    var buttonAction: LBTopBlock?
    
    init(named: String? = nil, isBlack: Bool, foreground: Color, buttonAction: LBTopBlock? = nil) {
        self.named = named
        self.isBlack = isBlack
        self.foreground = foreground
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        Button {
            if let action = buttonAction {
                action()
            } else {
                self.presentationMode.wrappedValue.dismiss()
            }
        } label: {
            backImage()
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 11.0, height: 18.0)
                .foregroundColor(foreground)
                .padding(.leading, 5.0)
        }
    }
    
    
    // 按钮相关
    
    private func backImage() -> Image {
        if named != nil {
            return Image(named!)
        } else {
            return Image(uiImage: LBBarImage(name: "nav_back"))
        }
    }
    
    private func LBBarImage(name: String) -> UIImage {
        return UIImage(named: name)!
    }
}

