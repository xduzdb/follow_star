//
//  ApiHost.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/2.
//

import Moya
import UIKit

// api的接口
let HostUrl = "https://serv.xingshiji.cc"

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
    case changeSubscribe
    case uploadFile(file: UIImage, type: String)
    case uploadImage(file: UIImage, type: String)

    case startPost([String: Any])
    case startDynamicStatistics([String: Any])

    // 明星模块
    case startSearch([String: Any])
    case startUserCover([String: Any])
    case setStartUserCover([String: Any])

    // 用户模块
    case aboutUs
    case connect
    case userLogOff
    case setAvator([String: Any])
    case updateNickName([String: Any])
    case userFixPassword([String: Any])

    // 推送
    case userDevices([String: Any])
    case userSubscribeNotice
    case subScribeNotice([String: Any])

    // 挂件的模块
    case notice

    // 大事记模块
    case eventList([String: Any]) // 指定日期事件列表
    case eventTimeLineAllInfo([String: Any])
    case commentsEvent([String: Any])
    case likeTimeLine([String: Any])
    case unLikeTimeLine([String: Any])

    // 其他的模块
    case allHelpUrl
    case share

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
             .changeSubscribe,
             .eventTimeLineAllInfo,
             .share,
             .allHelpUrl,

             .subscribeStart:

            return .get
        case .subScribeNotice,
             .unLikeTimeLine:
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
            let .userDevices(parames),
            let .subScribeNotice(parames),
            let .setStartUserCover(parames),
            let .setAvator(parames),
            let .updateNickName(parames),
            let .userFixPassword(parames),
            let .commentsEvent(parames),
            let .likeTimeLine(parames),
            let .resetPassword(parames):
            return .requestData(ydDictToData(dict: parames))

        case let .startSearch(parames),
             let .startDynamicStatistics(parames),
             let .eventList(parames),
             let .eventTimeLineAllInfo(parames),
             let .unLikeTimeLine(parames),
             let .startUserCover(parames):
            return .requestParameters(parameters: parames, encoding: URLEncoding.default)

        case let .uploadFile(file, type),
             let .uploadImage(file, type):
            let timeInterval: TimeInterval = Date().timeIntervalSince1970
            let timeStamp = Int(timeInterval)
            var formDatas = [MultipartFormData]()
            let imageData = file.pngData()
            let fileName = "iOS_\(timeStamp).png"
            let formData = MultipartFormData(provider: .data(imageData!), name: "file", fileName: fileName, mimeType: "image/png")
            formDatas.append(formData)
            return .uploadCompositeMultipart(formDatas, urlParameters: ["type": type])

        default:
            return .requestPlain
        }
    }

    public var headers: [String: String]? {
        let token = Model().token ?? ""
        return ["Content-Type": "application/json",
                "Authorization": "Bearer \(token)",
                "Platform": "iOS",
                "Channel": "1"]
    }

    public var baseURL: URL {
        return URL(string: HostUrl)!
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
            return "/api/timelines?sid=\(dict["sid"] ?? "")"
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
        case let .setStartUserCover(dict):
            return "/api/stars/\(dict["sid"] ?? "")/subscribe/cover"
        case .changeSubscribe:
            return "/api/stars/subscribe/change-subscribe"
        case .uploadFile:
            return "/api/covers"
        case .uploadImage:
            return "/api/upload/image"
        case .userLogOff:
            return "/api/users"
        case .allHelpUrl:
            return "/api/pages/help"
        case .updateNickName:
            return "/api/users/nickname"
        case .setAvator:
            return "/api/users/avatar"
        case .userFixPassword:
            return "/api/users/password"
        case .commentsEvent:
            return "/api/timeline/comments"
        case .likeTimeLine:
            return "/api/timeline/likes"
        case let .unLikeTimeLine(dict):
            return "/api/timeline/likes/\(dict["id"] ?? "")"
        case let .eventTimeLineAllInfo(dict):
            return "/api/timelines/all-index/\(dict["sid"] ?? "")"
        case .share:
            return "/api/shares"
        }
    }
}
