//
//  UITapGestureRecognizer+Extension.swift
//  BestBuy-ios
//
//  Created by dory on 2020/7/10.
//  Copyright © 2020 ZHOUYUBIN. All rights reserved.
//

import Foundation
import UIKit
var params_key = "UITapGestureRecognizer_params_key"
extension UITapGestureRecognizer{
    var params: Any?{
        set {
            objc_setAssociatedObject(self, &params_key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        
        get {
            if let rs = objc_getAssociatedObject(self, &params_key) {
                return rs
            }
            return nil
        }
    }
}
