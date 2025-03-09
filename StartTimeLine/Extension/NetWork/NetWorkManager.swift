//
//  NetWorkManager.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/7.
//
import Moya
import ObjectMapper
import SwiftyJSON
import UIKit

typealias ResponseCallback = (NetResultModel) -> Void
typealias ProgressCallback = (CGFloat) -> Void
// 默认请求超时时常
private var requestTimeOut: Double = 15
let ApiManager = MoyaProvider<NetWorkServer>(endpointClosure: myEndpointClosure, requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)

// MARK: endpointClosure

private let myEndpointClosure = { (target: NetWorkServer) -> Endpoint in
    /// 这里的endpointClosure和网上其他实现有些不太一样。
    /// 主要是为了解决URL带有？无法请求正确的链接地址的bug
    let url = target.baseURL.absoluteString + target.path
    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: target.task,
        httpHeaderFields: target.headers
    )
    // 默认超时时常15  个别请求可独立设置
    switch target {
    default:
        requestTimeOut = 15 // 按照项目需求针对单个API设置不同的超时时长
        return endpoint
    }
}

// MARK: requestClosure

private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        // 设置请求时长
        request.timeoutInterval = requestTimeOut
        // 打印请求参数
        let token = UserDefaults.standard.string(forKey: kUserInfoToken) ?? ""
        if let requestData = request.httpBody {
            DDLOG(message: "[\(request.httpMethod ?? "")]：\(request.url!)" + "\n [token]:\(token) \n" + "\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
        } else {
            DDLOG(message: "\(request.url!)" + "\(String(describing: request.httpMethod))")
        }
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

// MARK: NetworkActivityPlugin插件用来监听网络请求

private let networkPlugin = NetworkActivityPlugin.init { changeType, _ in

    //        print("networkPlugin \(targetType)")
    // targetType 是当前请求的基本信息
    switch changeType {
    case .began:
        //        print("开始请求网络")
        //        globalQuene.async {
        //             let  _ = ydGetNetStatues()
        //        }
        //
        break
    case .ended:
        //        print("结束")
        break
    }
}

// MARK: 取消所有请求

func cancelAllRequest() {
    ApiManager.session.cancelAllRequests()
}

class NetWorkManager: NSObject {
    /// 先添加一个闭包用于成功时后台返回数据的回调
    /// 再次用一个方法封装provider.request()
    class func ydNetWorkRequest(_ target: NetWorkServer, isShowErrMsg: Bool = true, flag: Int = 0, progressClouse: ProgressCallback? = nil, completion: @escaping ResponseCallback) {
        let stateDate = Date().getMilliSecondStamp
        // 先判断网络是否有链接 没有的话直接返回--代码略
        ApiManager.request(target, progress: { obj in
            progressClouse?(CGFloat(obj.progress))
        }) { result in
            let endDate = Date().getMilliSecondStamp
            let aa = Date().getMillSecondStampTimeDifference(startStamp: stateDate, endStamp: endDate)
            DDLOG(message: "【url:\(target.baseURL)\(target.path)\n 请求时长：\(aa)ms \n")

            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusAndRedirectCodes()
                    successHandler(target, isShowErrMsg: isShowErrMsg, flag: flag, response: response, completion: completion)
                } catch {
                    let model = errorHandler(target: target, response: response)
                    if isShowErrMsg {
                        /// 延迟执行之前的代码
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            YDHUD.showOnlyText(message: model.msg)
                        }
                    }
                    completion(model)
                }
            case let .failure(error):
                let model = failureHandler(target: target, error: error)
                DDLOG(message: error.errorDescription ?? "")
                if isShowErrMsg {
                    YDHUD.showOnlyText(message: model.msg)
                }

                completion(model)
            }
        }
    }

    // MARK: - - SUCCESS

    private class func successHandler(_ target: NetWorkServer, isShowErrMsg: Bool = true, flag: Int = 0, response: Response, completion: @escaping ResponseCallback) {
        let model = NetResultModel()
        guard let jsonData = try? JSON(data: response.data) else {
            model.status = .error
            DDLOG(message: "解析异常")
            model.code = 0
            model.data = nil
            completion(model)
            return
        }
        if jsonData.isEmpty {
            // flag 不为0000 HUD显示错误信息
            model.status = .code_error
            model.data = nil
            model.code = jsonData["code"].intValue
            model.msg = jsonData["msg"].stringValue
            if isShowErrMsg {
                YDHUD.showOnlyText(message: model.msg)
            }
        } else {
            model.status = .success
            var dict = jsonData.dictionaryObject
            if jsonData.type == .array {
                dict = ["list": jsonData.arrayObject as Any]
            }
            model.data = dict
            model.msg = jsonData["msg"].stringValue
            model.code = jsonData["code"].intValue
            model.jsonStr = jsonData.rawString([writingOptionsKeys.castNilToNSNull: true])
        }
        completion(model)
    }

    // MARK: - - ERROR

    private class func errorHandler(target: NetWorkServer, response: Response?) -> NetResultModel {
        // https://www.jianshu.com/p/c077fec58d54  code 对照表
        let model = NetResultModel()
        let code: Int = response?.statusCode ?? 0
        var statusStr = ""
        model.status = .error

        // 拿到response的data里面的message

        guard let responseData = response?.data else {
            return model
        }

        // 将data数据转成json
        guard let jsonData = try? JSON(data: responseData) else {
            return model
        }

        switch code {
        case -1: // NSURLErrorUnknown
            statusStr = "未知错误"
        case -999: // NSURLErrorCancelled
            statusStr = "无效的URL地址"
        case -1000: // NSURLErrorBadURL
            statusStr = "无效的URL地址"
        case -1001: // NSURLErrorTimedOut
            statusStr = "网络不给力，请稍后再试"
        case -1002: // NSURLErrorUnsupportedURL
            statusStr = "不支持的URL地址"
        case -1003: // NSURLErrorCannotFindHost
            statusStr = "找不到服务器"
        case -1004: // NSURLErrorCannotConnectToHost
            statusStr = "连接不上服务器"
        case -1005: // NSURLErrorNetworkConnectionLost
            statusStr = "网络连接异常"
        case -1009: // NSURLErrorNotConnectedToInternet
            statusStr = "无网络连接"
        case -1011: // NSURLErrorBadServerResponse
            statusStr = "服务器响应异常"
        case 400 ... 499:
            // 如果jsonData["msg"]不为空，则取jsonData["msg"]的值，否则取statusStr
            statusStr = jsonData["message"].stringValue.isEmpty ? "请求错误" : jsonData["message"].stringValue
        case 500 ... 599:
            statusStr = "服务器错误"
        default:
            statusStr = ""
        }
        DDLOG(message: statusStr + "(code:\(code)) + ”\(target.baseURL)\(target.path)“")
        model.status = .error
        if statusStr.isEmpty {
            model.msg = ""
        } else {
            model.msg = statusStr + "(code:\(code))"
            model.code = code
        }
        return model
    }

    // MARK: - - FAILURE

    private class func failureHandler(target: NetWorkServer, error: MoyaError?) -> NetResultModel {
        DDLOG(message: "\nFAILURE:\(target.path)")
        let model = NetResultModel()
        model.status = .fail
        model.msg = ""
        switch error {
        case let .imageMapping(rsp):
            DDLOG(message: "Failed to map data to an Image.\(rsp)")
        case let .jsonMapping(rsp):
            DDLOG(message: "Failed to map data to JSON.\(rsp)")
        case let .stringMapping(rsp):
            DDLOG(message: "Failed to map data to a String.\(rsp)")
        case let .objectMapping(err, rsp):
            DDLOG(message: "Failed to map data to a Decodable object.\(err)--\(rsp)")
        case let .encodableMapping(err):
            DDLOG(message: "Failed to encode Encodable object into data.\(err)")
        case let .statusCode(rsp):
            DDLOG(message: "Status code didn't fall within the given range.\(rsp)")
        case let .underlying(err, _):
            let arr = err.localizedDescription.components(separatedBy: ":")
            if arr.count > 1 {
                let str = arr[1]
                model.msg = str.replacingOccurrences(of: "。", with: "")
            }
            DDLOG(message: model.msg)
        case let .requestMapping(str):
            DDLOG(message: "Failed to map Endpoint to a URLRequest.\(str)")
        case let .parameterEncoding(err):
            DDLOG(message: "Failed to encode parameters for URLRequest. \(err.localizedDescription)")
        case .none:
            break
        }
        DDLOG(message: "\n\n")
        return model
    }

    /// 无效token 处理逻辑
    private class func invalidTokenHandler(_ target: NetWorkServer, model: NetResultModel, flag: Int, jsonData: JSON, completion: @escaping ResponseCallback) {
        model.status = .code_error
        var dict = jsonData.dictionaryObject
        if (dict?["data"] as? NSNull) != nil {
            dict?["data"] = nil
        }
        model.data = dict
        model.msg = jsonData["msg"].stringValue
        model.code = jsonData["code"].intValue
        if flag >= 1 {
            UserSharedManger.shared.clearUserData()
            YDHUD.showOnlyText(message: model.msg)
            completion(model)
            return
        }

        guard let data = model.data?["data"] else {
            completion(model)
            return
        }
        let data1 = data as! [String: Any]
        let reason = data1["reason"] as? String
        switch reason {
        case "10033": // 需要更新token信息
            break
        case "10029": // 您已在其他同类设备登陆，请重新登录
            model.msg = "您已在其他同类设备登陆，请重新登录"
        case "10030": // 您已被限制登陆
            model.msg = "您已被限制登陆"
        default: // "10026", "10027", "10028": //请重新登录
            model.msg = "请重新登录"
        }
        if reason == "10033" {
            let refreshToken = data1["refreshToken"] as? String
            if refreshToken != nil {
                UserSharedManger.shared.saveUserToken(token: refreshToken)
                NetWorkManager.ydNetWorkRequest(target, flag: 1, completion: completion)
            } else {
                UserSharedManger.shared.clearUserData()
                YDHUD.showOnlyText(message: model.msg)
                completion(model)
            }
        } else {
            UserSharedManger.shared.clearUserData()
            YDHUD.showOnlyText(message: model.msg)
            completion(model)
        }
    }

    // 网络数据 本地缓存
    class func ydUserDefaultSave(model: NetResultModel?, key: String, resultClouse: ((Bool) -> Void)? = nil) {
        if model == nil || model?.data == nil {
            resultClouse?(false)
        }
        if model!.jsonStr != nil && model!.jsonStr!.count != 0 {
            mainUserDeafultSave { user in
                user.setValue(model!.jsonStr, forKey: key)
                resultClouse?(true)
            }
        } else {
            resultClouse?(false)
        }
    }

    // 本地缓存  取用
    class func ydUserDefaultRead(key: String) -> (NetResultModel?) {
        let jsonStr: String? = mainUserDefault.string(forKey: key)
        if jsonStr != nil {
            let jsonData = JSON(parseJSON: jsonStr!)
            let model = NetResultModel()
            model.status = .success
            model.data = jsonData.dictionaryObject
            model.msg = jsonData["msg"].stringValue
            model.code = jsonData["code"].intValue
            model.jsonStr = jsonStr
            return model
        } else {
            return nil
        }
    }
}
