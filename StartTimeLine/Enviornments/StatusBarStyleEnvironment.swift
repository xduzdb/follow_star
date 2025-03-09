//
//  StatusBarStyleEnvironment.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/8/19.
//

import SwiftUI

extension EnvironmentValues {
    
    var statusBarStyle: StatusBarStyle { self[StatusBarStyle.Key.self] }
}

class StatusBarStyle {
    
    var getter: () -> UIStatusBarStyle = { .default }
    var setter: (UIStatusBarStyle) -> Void = { _ in }

    var current: UIStatusBarStyle {
        get { self.getter() }
        set { self.setter(newValue) }
    }
}

extension StatusBarStyle {
    
    struct Key: EnvironmentKey {
        static let defaultValue: StatusBarStyle = StatusBarStyle()
    }
}

