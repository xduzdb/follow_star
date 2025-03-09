import SwiftUI

@available(iOS 17.0, *)
@available(iOSApplicationExtension 17.0, *)
struct DisableWidgetContentMargins: ViewModifier {
    @Environment(\.widgetContentMargins) var margins
    
    func body(content: Content) -> some View {
        content.padding(0)
    }
}


extension View {
    /// 小组件背景
    func widgetBackground(_ backgroundView: @autoclosure () -> some View) -> some View {
        if #available(iOS 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView()
            }
        } else {
            return background(backgroundView())
        }
    }
    
    /// 忽略小组件间距
    func disableWidgetContentMargins() -> some View {
        if #available(iOS 17.0, *) {
            return modifier(DisableWidgetContentMargins())
        } else {
            return self
        }
    }
}

extension WidgetConfiguration {
    /// 忽略小组件间距
    func disableWidgetContentMargins() -> some WidgetConfiguration {
        if #available(iOSApplicationExtension 17.0, *) {
            return self.contentMarginsDisabled()
        } else {
            return self
        }
    }
}
