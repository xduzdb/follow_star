//
//  ConstWebString.swift
//  StartTimeLine 
//
//  Created by Lushitong on 2024/12/20.
//

import Foundation

// 网页相关的内容
let webHostUrl = "https://serv.xingshiji.cc"

// 用户协议
let userAgreeUrl = {
    return "\(webHostUrl)/static/res/terms/user_agreement.html"
}

// 隐私政策
let privateUrl = {
    return  "\(webHostUrl)/static/res/terms/privacy_policy.html"
}

func eventUrlStr(token:String) -> String {
    return "\(webHostUrl)/activity/login?token=\(token)&redirect=\(webHostUrl)/activity/clue-view"
}

// C 位的URL
func cShowURl() -> String {
    return "https://support.qq.com/products/676752"
}

