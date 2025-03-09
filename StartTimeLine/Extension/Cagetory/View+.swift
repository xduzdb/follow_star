//
//  View+.swift
//  OneDay
//
//  Created by aa on 2024/3/18.
//

import SwiftUI
import UIKit

@available(iOS 15.0.0, *)

enum CustomAlertType: Int {
    case None = -1

    case Loading = 100
    case Toast = 101
    case Alert = 102
}

extension View {
    func baseShadow(color: SwiftUI.Color = .black.opacity(0.3)) -> some View {
        modifier(BaseShadowModifier(color: color))
    }

    func strokeStyle(cornerRadius: CGFloat = 30) -> some View {
        modifier(StrokeStyle(cornerRadius: cornerRadius))
    }

    func iconStyle(size: CGFloat, cornerRadius: CGFloat) -> some View {
        modifier(IconStyle(size: size, cornerRadius: cornerRadius))
    }
}

extension View {
    func customAlert(_ alertType: Binding<CustomAlertType?>, message: String = "", sureButonStr: String = "确认订阅", finish: ((String?) -> ())? = nil) -> some View {
        ZStack {
            self
            let type = alertType.wrappedValue
            if type != nil && type != .None {
                if type == .Alert {
                    Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            alertType.wrappedValue = .None
                        }
                    CustomPopupView(showAlertType: alertType, message: message, sureButonStr: sureButonStr, finish: finish)
                        .popupAnimation()
                } else if type == .Toast {}
            }
        }
    }
}

struct CustomPopupView: View {
    @Binding var showAlertType: CustomAlertType?

    @State var message: String
    @State var sureButonStr: String

    var finish: ((String?) -> ())? = nil

    var body: some View {
        VStack(spacing: 0) {
                        Spacer()
            // 消息文本
            Text(message)
                .frame(alignment: .center)
                .multilineTextAlignment(.center)
                .foregroundColor(.color333333())
                .font(.system(size: 15))
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .frame(maxHeight: 120) // 限制文本最大高度
                .lineLimit(nil) // 允许多行

            Spacer()

            // 分割线
            Divider()

            // 按钮容器
            HStack(spacing: 0) {
                // 取消按钮
                Button("取消") {
                    showAlertType = nil
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.black)

                // 竖直分割线
                Divider()

                // 确认按钮
                Button(sureButonStr) {
                    showAlertType = nil
                    finish?(nil)
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.colorF05F49())
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
        }
        .frame(minHeight: 60, maxHeight: 125) // 设置整体弹框的最小和最大高度
        .background(Color.white)
        .cornerRadius(12)
        .frame(width: UIScreen.main.bounds.size.width - 80)
    }
}

struct PopupAnimationModifier: ViewModifier {
    @State private var isVisible: Bool = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isVisible ? 1 : 0.9)
            .onAppear {
                withAnimation(.linear(duration: 0.15)) { // easeIn easeInOut easeOut linear
                    isVisible = true
                }
            }
    }
}

extension View {
    func popupAnimation() -> some View {
        modifier(PopupAnimationModifier())
    }
}

struct DashedBorder: ViewModifier {
    let color: Color
    let cornerRadius: CGFloat
    let dashLength: CGFloat
    let dashGap: CGFloat
    let lineWidth: CGFloat

    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    style: SwiftUI.StrokeStyle( // 明确指定使用 SwiftUI.StrokeStyle
                        lineWidth: lineWidth,
                        dash: [dashLength, dashGap]
                    )
                )
                .foregroundColor(color)
        )
    }
}

// 扩展 View 以便更容易使用
extension View {
    func dashedBorder(
        color: Color = .gray,
        cornerRadius: CGFloat = 10,
        dashLength: CGFloat = 5,
        dashGap: CGFloat = 5,
        lineWidth: CGFloat = 1
    ) -> some View {
        modifier(DashedBorder(
            color: color,
            cornerRadius: cornerRadius,
            dashLength: dashLength,
            dashGap: dashGap,
            lineWidth: lineWidth
        ))
    }
}

extension View {
    
    @ViewBuilder
    func applyIf<T: View>(_ condition: Bool, apply: (Self) -> T) -> some View {
        if condition {
            apply(self)
        } else {
            self
        }
    }
    
    func shadowedStyle() -> some View {
        self
            .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 0)
            .shadow(color: .black.opacity(0.16), radius: 24, x: 0, y: 0)
    }
}



extension UIApplication {
    var keyWindow: UIWindow? {
        return connectedScenes
            .filter { $0 is UIWindowScene }
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
    }
}

extension View {
    func asImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        // Set the size of the view
        let targetSize = CGSize(width: 300, height: 300) // Set your desired size
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear // Optional: Set background color

        // Render the view to an image
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
        }
    }
}
