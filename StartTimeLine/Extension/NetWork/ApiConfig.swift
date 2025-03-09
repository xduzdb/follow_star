//
//  ApiConfig.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/5.
//

import Foundation

// MARK: 字典转字符串

func ydDicValueString(_ dic: [String: Any]) -> String? {
    let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
    let str = String(data: data!, encoding: String.Encoding.utf8)
    return str
}

// MARK: 字符串转字典

func ydStringValueDic(_ str: String) -> [String: Any]? {
    let data = str.data(using: String.Encoding.utf8)
    if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
        return dict
    }
    return nil
}

func ydDictToData(dict: [String: Any]?) -> Data! {
    if dict != nil, JSONSerialization.isValidJSONObject(dict as Any) {
        let data = (try? JSONSerialization.data(withJSONObject: dict!, options: .prettyPrinted)) as NSData?
        return data! as Data
    } else {
        DDLOG(message: "请求参数为 nil !!!")
        return Data()
    }
}

func ydArryToData(list: [Any?]?) -> Data! {
    if list != nil, JSONSerialization.isValidJSONObject(list!) {
        let data = (try? JSONSerialization.data(withJSONObject: list!, options: .prettyPrinted)) as NSData?
        return data! as Data
    } else {
        DDLOG(message: "请求参数为 nil !!!")
        return Data()
    }
}
