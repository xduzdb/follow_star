//
//  ApiHost.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/2.
//

import Moya
import UIKit

// api的接口
let HostUrl = "http://114.116.247.103:2500"

// app的状态码
let CODE_ERROR_UNKNOW = "5002" // 未知错误
let CODE_PARAMETER_ERROR = "5001" // 参数错误
let CODE_SYSTEM_ERROR = "5000" // 服务器错误

let CODE_NO_DATA = "4000" // 无数据

public enum NetWorkServer {
    case phoneCode([String: Any]) // 发送手机验证码

    // 登录模块
    case loginPhoneCode([String: Any]) // 手机号验证码登录
    case loginPassword([String: Any]) // 手机号密码登录
    case resetPassword([String: Any]) // 手机号密码登录

    // 明星模块
    case getStartDetails([String: Any])
    case searechStart([String: Any])
    case subscribeStart
    case defaultStart
    case subscribe([String: Any])
    // /api/stars/posts?sid=66e1659500028dc42a64
    case startPost([String: Any])
    case startDynamicStatistics([String: Any])

    // 明星模块
    case startSearch([String: Any])
    case startUserCover([String: Any])

    // 用户模块
    case aboutUs
    case connect
    case userLogOff

    // 推送
    case userDevices([String: Any])
    case userSubscribeNotice
    case subScribeNotice([String: Any])

    // 挂件的模块
    case notice

    // 大事记模块
    case eventList([String: Any]) // 指定日期事件列表

    case getUserInfo
}

extension NetWorkServer: TargetType {
    public var method: Moya.Method {
        switch self {
        case .getUserInfo,
             .getStartDetails,
             .defaultStart,
             .aboutUs,
             .connect,
             .userSubscribeNotice,
             .notice,
             .eventList,
             .startSearch,
             .startUserCover,
             .startPost,
             .startDynamicStatistics,
             .subscribeStart:

            return .get
        case .subScribeNotice:
            return .put
        case .userLogOff:
            return .delete
        default:
            return .post
        }
    }

    public var task: Moya.Task {
        switch self {
        case
            let .phoneCode(parames),
            let .loginPhoneCode(parames),
            let .loginPassword(parames),
            let .subscribe(parames),
            let .eventList(parames),
            let .userDevices(parames),
            let .subScribeNotice(parames),
            let .resetPassword(parames):
            return .requestData(ydDictToData(dict: parames))

        case let .startSearch(parames),
             let .startDynamicStatistics(parames),
             let .startUserCover(parames):
            return .requestParameters(parameters: parames, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }

    public var headers: [String: String]? {
        let token = UserDefaults.standard.string(forKey: kUserInfoToken) ?? ""
        return ["Content-Type": "application/json",
                "Authorization": "Bearer \(token)",
                "Platform": "iOS",
                "Channel": "1"]
    }

    public var baseURL: URL {
        return URL(string: "http://114.116.247.103:2500")!
    }

    public var path: String {
        switch self {
        case .phoneCode:
            return "/api/phone-code"
        case .loginPhoneCode:
            return "/api/login/phone-code"
        case .loginPassword:
            return "/api/login/password"
        case .resetPassword:
            return "/api/login/password/reset"
        case .getUserInfo:
            return "/api/users/me"
        case let .getStartDetails(dict):
            return "/api/stars/\(dict["sid"] ?? "")"
        case let .searechStart(dict):
            return "api/stars/search?name=\(dict["name"] ?? "")"
        case .subscribeStart:
            return "/api/stars/subscribe/star"
        case .defaultStart:
            return "/api/stars/default"
        case .aboutUs:
            return "/api/users/about"
        case .connect:
            return "/api/users/connect"
        case .notice:
            return "/api/widget/notice"
        case let .eventList(dict):
            return "/api/timelines?date=\(dict["date"] ?? "")&sid=\(dict["sid"] ?? "")&type=\(dict["type"] ?? "")"
        case let .subscribe(dict):
            return "/api/stars/\(dict["sid"] ?? "")/subscribe"
        case let .subScribeNotice(dict):
            return "/api/stars/subscribe/notice/\(dict["id"] ?? "")"
        case .userDevices:
            return "/api/user-devices"
        case .userSubscribeNotice:
            return "/api/stars/subscribe/notice"
        case .startSearch:
            return "/api/stars/search"
        case .startUserCover:
            return "/api/covers"
        case let .startPost(dict):
            return "/api/stars/posts?sid=\(dict["sid"] ?? "")"
        case let .startDynamicStatistics(dict):
            return "/api/stars/\(dict["sid"] ?? "")/post-stats"
        case .userLogOff:
            return "/api/users"
        }
    }
}
