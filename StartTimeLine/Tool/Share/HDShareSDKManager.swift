//
//  HDShareSDKManager.swift
//  StartTimeLine
//
//  Created by 卢仕彤 on 2025/1/8.
//

import Foundation

enum LQShareSession {
    case wechatSession, wechatTimeline, wechatFavorite, sina
}

class HDShareSDKManager {
    func shareImage(_ image: Any, to session: LQShareSession, success: (() -> Void)? = nil, failed: (() -> Void)? = nil) {
        let shareParams = NSMutableDictionary()
        shareParams.ssdkSetupShareParams(byText: "", images: image, url: nil, title: nil, type: SSDKContentType.image)

        ShareSDK.share(shareSession(session), parameters: shareParams) { state, _, _, error in

            if state == SSDKResponseState.success {
                if let handle = success {
                    handle()
                }
            } else {
                if let handle = failed {
                    handle()
                }
            }
        }
    }

    func shareSession(_ type: LQShareSession) -> SSDKPlatformType {
        switch type {
        case .wechatSession:
            return SSDKPlatformType.subTypeWechatSession
        case .wechatTimeline:
            return SSDKPlatformType.subTypeWechatTimeline
        case .wechatFavorite:
            return SSDKPlatformType.subTypeWechatFav
        case .sina:
            return SSDKPlatformType.typeSinaWeibo
        }
    }
}
