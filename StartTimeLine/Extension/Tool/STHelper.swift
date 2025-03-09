//
//  STHelper.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/8/13.
//

import UIKit

public typealias LBTopBlock = () -> Void

enum STHelper {
    static let screenHeight: CGFloat = UIScreen.main.bounds.size.height
    static let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    
    enum SafeArea {
        static var top: CGFloat {
            UIWindow.keyWindow?.safeAreaInsets.top ?? 0
        }
        
        static var safeTop: CGFloat {
            iPhoneXSeries ? 44.0 : 0
        }
    }
    
    enum StatusBar {
        static var window = UIApplication.shared.windows.first
        static var topPadding = window?.safeAreaInsets.top
        static let height = topPadding
    }
    
    enum NavigationBar {
        static let height: CGFloat = 44.0
        static let bottom: CGFloat = height + StatusBar.height!
    }
    
    static var iPhoneXSeries: Bool {
        if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.phone {
            debugPrint("not iphone")
        }
        
        if #available(iOS 11.0, *) {
            if let bottom = UIWindow.keyWindow?.safeAreaInsets.bottom, bottom > 0 {
                return true
            }
        } else {
            debugPrint("iOS11 previews")
        }
        
        return false
    }
}

extension UIWindow {
    static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
