//
//  View+StatusBar.swift
//  StartTimeLine
//
//  Created by 卢仕彤 on 2025/1/1.
//

import SwiftUI

class StatusBarController: UIViewController {
    var style: UIStatusBarStyle = .lightContent
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        style
    }
}

struct StatusBarModifier: ViewModifier {
    let style: UIStatusBarStyle
    
    func body(content: Content) -> some View {
        content
            .background(
                StatusBarConfigurator(style: style)
            )
    }
}

struct StatusBarConfigurator: UIViewControllerRepresentable {
    let style: UIStatusBarStyle
    
    func makeUIViewController(context: Context) -> StatusBarController {
        let controller = StatusBarController()
        controller.style = style
        return controller
    }
    
    func updateUIViewController(_ uiViewController: StatusBarController, context: Context) {
        uiViewController.style = style
        uiViewController.setNeedsStatusBarAppearanceUpdate()
    }
}

extension View {
    func statusBarStyle(_ style: UIStatusBarStyle) -> some View {
        modifier(StatusBarModifier(style: style))
    }
}
