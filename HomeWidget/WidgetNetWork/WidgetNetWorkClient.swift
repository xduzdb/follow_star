//
//  WidgetNetWorkClient.swift
//  StartTimeLine
//
//  Created by sto on 2024/10/25.
//

import Foundation

let widgetHostUrl = "http://114.116.247.103:2500"
let widgetNoticeUrl = "/api/widget/notice"

extension URLRequest {
    private static var baseURLStr: String { return widgetHostUrl + widgetNoticeUrl }

    static func quoteFromNet() -> URLRequest {
        .init(url: URL(string: baseURLStr)!)
    }
}

// 小组件的请求
public final class WidgetNetWorkClient {
    private let session: URLSession = .shared

    enum NetworkError: Error {
        case noData
    }

    func executeRequest(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        session.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            completion(.success(data))
        }.resume()
    }
}

public struct WidgeQuoteServer {
    static func getQuote(client: WidgetNetWorkClient, completion: ((OneDayModel) -> Void)?) {
        // 获取token
        quoteRequest(.quoteFromNet(),
                     on: client,
                     completion: completion)
    }

    private static func quoteRequest(_ request: URLRequest,
                                     on client: WidgetNetWorkClient,
                                     completion: ((OneDayModel) -> Void)?) {
        // 获取 token
        if let userDefaults = UserDefaults(suiteName: AppGroupIdentifier) {
            let token = userDefaults.string(forKey: kUserInfoToken)
            print("Retrieved token: \(token ?? "nil")")

            // 创建一个可变的请求以添加 header
            var requestWithToken = request
            if let token = token {
                requestWithToken.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                requestWithToken.setValue("Content-Type", forHTTPHeaderField: "application/json")
                requestWithToken.setValue("Platform", forHTTPHeaderField: "iOS")
                requestWithToken.setValue("Channel", forHTTPHeaderField: "1")
            }

            // 使用带有 token 的请求
            client.executeRequest(request: requestWithToken) { result in
                switch result {
                case let .success(data):
                    do {
                        // 将数据转换为字典
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            // 处理字典数据
                            print("Received JSON Dictionary: \(json)")
                            let decoder = JSONDecoder()
                            let quoteItem = try decoder.decode(OneDayModel.self, from: data)

                            completion?(quoteItem)
                        } else {
                            print("Failed to convert data to dictionary")
                        }
                    } catch {
                        print("JSON parsing error: \(error.localizedDescription)")
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
