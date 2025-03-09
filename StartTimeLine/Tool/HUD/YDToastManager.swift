//
//  YDToastManager.swift
//  BestBuy-ios
//
//  Created by ZHOUYUBIN on 2020/9/3.
//  Copyright © 2020 ZHOUYUBIN. All rights reserved.
//

import UIKit

/// 管理toast 显示  避免重叠
class YDToastManager: NSObject {
    static let shared = YDToastManager()
    var curToast:YDToast?
    func setToast(_ toast: YDToast){
        if curToast != nil{
            curToast?.dismissToast()
            curToast = nil
        }
        curToast = toast
    }
    private override init() {
        super.init()
    }
    
}

