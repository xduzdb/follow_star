import SwiftUI

// MARK: Extension
extension View {
    /// 小组件背景
    func widgetBackground(_ backgroundView: @autoclosure () -> some View) -> some View {
        return background(backgroundView())
    }
    
    /// 忽略小组件间距
    func disableWidgetContentMargins() -> some View {
        return self
    }
}

extension WidgetConfiguration {
    /// 忽略小组件间距
    func disableWidgetContentMargins() -> some WidgetConfiguration {
        return self
    }
}
