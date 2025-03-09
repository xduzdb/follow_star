//
//  STCustomSheet.swift
//  StartTimeLine
//
//  Created by 卢仕彤 on 2025/1/8.
//

import SwiftUI


struct STCustomSheet<Content: View>: UIViewControllerRepresentable {
    var content: Content
    var onDismiss: () -> Void
    var height: CGFloat // 添加高度属性

    init(onDismiss: @escaping () -> Void, height: CGFloat, @ViewBuilder content: () -> Content) {
        self.onDismiss = onDismiss
        self.content = content()
        self.height = height // 初始化高度
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        let hostingController = UIHostingController(rootView: content)
        hostingController.view.backgroundColor = .clear // 设置背景透明
        controller.addChild(hostingController)
        controller.view.addSubview(hostingController.view)
        
        // 设置 hostingController.view 的高度
        hostingController.view.frame = CGRect(x: 0, y: 0, width: controller.view.bounds.width, height: height)
        hostingController.view.autoresizingMask = [.flexibleWidth] // 允许宽度自适应
        
        // 设置 modalPresentationStyle
        controller.modalPresentationStyle = .pageSheet // 或 .formSheet
        
        // 添加手势识别器以处理关闭
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.dismiss))
        controller.view.addGestureRecognizer(tapGesture)

        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // 更新视图控制器
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: STCustomSheet

        init(_ parent: STCustomSheet) {
            self.parent = parent
        }

        @objc func dismiss() {
            parent.onDismiss()
        }
    }

    static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: ()) {
        uiViewController.children.forEach { $0.removeFromParent() }
    }
}
