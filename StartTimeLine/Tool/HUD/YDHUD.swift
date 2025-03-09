//
//  YDHUD.swift
//  BestBuy-ios
//
//  Created by ice on 2020/4/29.
//  Copyright © 2020 ice. All rights reserved.
//

import SVProgressHUD
import UIKit

public enum YDToastType: Int {
    case top = 0
    case center = 1
    case bottom = 2
}

class YDHUD: NSObject {
    class func show(message: String? = nil, isUserInteractionEnabled: Bool = true) {
        showHUD()
    }

    class func showOnlyText(message: String? = nil, attributStr: NSMutableAttributedString? = nil, alignment: YDToastType = .center, duration: CGFloat = 2.0, view: UIView? = nil) {
        SVProgressHUD.dismiss()
        if String.yd_isEmpty(str: message), attributStr == nil {
            return
        }
        if alignment == .top {
            YDToast.showTopWithText(text: message, attributStr: attributStr, duration: duration, view: view)
    
        } else if alignment == .bottom {
            YDToast.showBottomWithText(text: message, attributStr: attributStr, duration: duration, view: view)
        } else if alignment == .center {
            YDToast.showCenterWithText(text: message, attributStr: attributStr, duration: duration, view: view)
        }
    }

    class func dismiss() {
        hideHUD()
    }

    class func showHUD() {
        mainQuene.async {
            YBHUD.shared.show()
        }
    }

    class func hideHUD() {
        mainQuene.async {
            YBHUD.shared.hide()
        }
    }
}
