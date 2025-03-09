//
//  UIWindowExt.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/4.
//

import UIKit

public extension UIWindow {
    
    /// 当前 UIWindow
    static var current: UIWindow? {
        let frontToBackWindows = UIApplication.shared.windows.reversed()
        for window in frontToBackWindows {
            if window.isKeyWindow, window.windowLevel == UIWindow.Level.normal, window.screen == UIScreen.main, !window.isHidden && window.alpha > 0 {
                return window
            }
        }
        return nil
    }
    
}
