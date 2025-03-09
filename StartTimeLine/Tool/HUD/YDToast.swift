//
//  YDToast.swift
//  BestBuy-ios
//
//  Created by dory on 2020/6/3.
//  Copyright © 2020 ZHOUYUBIN. All rights reserved.
//

import UIKit
/// Toast默认停留时间
let toastDispalyDuration: CGFloat = 2.0
/// Toast背景颜色
let toastBackgroundColor: UIColor = .black
///  顶部导航栏
let topBarHigh: CGFloat = SCREEN_HEIGHT >= 812 ? 88 : 64
let toastMaxWidth: CGFloat = SCREEN_WIDTH - 100
let toastMinHeight: CGFloat = 35

class YDToast: NSObject {
    var contentView: UIButton
    var duration: CGFloat = toastDispalyDuration
    init(text: String) {
        let size = YDToast.getToastLabSize(text)
        let textLabel = UILabel(frame: CGRect(x: 20, y: 0, width: size.width, height: size.height))
        textLabel.backgroundColor = UIColor.clear
        textLabel.textColor = UIColor.white
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.text = text
        textLabel.numberOfLines = 0
        contentView = UIButton(frame: CGRect(x: 0, y: 0, width: textLabel.frame.size.width + 40, height: textLabel.frame.size.height))
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = toastBackgroundColor
        contentView.alpha = 0.6
        contentView.addSubview(textLabel)
        // contentView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        super.init()
        contentView.addTarget(self, action: #selector(toastTaped), for: .touchDown)
        /// 添加通知获取手机旋转状态.保证正确的显示效果
        NotificationCenter.default.addObserver(self, selector: #selector(toastTaped), name: UIDevice.orientationDidChangeNotification, object: UIDevice.current)
    }

    init(attributedString: NSMutableAttributedString) {
        let size = YDToast.getToastAttbsLabSize(attributedString)
        let textLabel = UILabel(frame: CGRect(x: 20, y: 0, width: size.width, height: size.height))
        textLabel.backgroundColor = UIColor.clear
        textLabel.textColor = UIColor.white
        textLabel.textAlignment = .center
        textLabel.attributedText = attributedString
        textLabel.numberOfLines = 0
        contentView = UIButton(frame: CGRect(x: 0, y: 0, width: textLabel.frame.size.width + 40, height: textLabel.frame.size.height))
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = toastBackgroundColor
        contentView.alpha = 0.6
        contentView.addSubview(textLabel)
        super.init()
        contentView.addTarget(self, action: #selector(toastTaped), for: .touchDown)
        /// 添加通知获取手机旋转状态.保证正确的显示效果
        NotificationCenter.default.addObserver(self, selector: #selector(toastTaped), name: UIDevice.orientationDidChangeNotification, object: UIDevice.current)
    }
    
    static func getToastAttbsLabSize(_ attributStr: NSMutableAttributedString) -> CGSize {
        var toastW: CGFloat = 0.0
        var toastH: CGFloat = 0.0
        let w = YDToast.getTitleAttsLabW(attributStr, height: toastMinHeight)
        if w > toastMaxWidth {
            toastH = YDToast.getTitleAttsLabH(attributStr, width: toastMaxWidth) + 20
            toastW = toastMaxWidth
        } else {
            toastH = toastMinHeight
            toastW = w + 10
        }
        return CGSize(width: toastW, height: toastH)
    }

    static func getToastLabSize(_ str: String) -> CGSize {
        var toastW: CGFloat = 0.0
        var toastH: CGFloat = 0.0
        let w = YDToast.getTitleLabW(str, height: toastMinHeight)
        if w > toastMaxWidth {
            toastH = YDToast.getTitleLabH(str, width: toastMaxWidth) + 20
            toastW = toastMaxWidth
        } else {
            toastH = toastMinHeight
            toastW = w
        }
        return CGSize(width: toastW, height: toastH)
    }

    static func getTitleAttsLabH(_ attributStr: NSMutableAttributedString, width: CGFloat) -> CGFloat {
        return attributStr.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size.height
    }

    static func getTitleAttsLabW(_ attributStr: NSMutableAttributedString, height: CGFloat) -> CGFloat {
        return attributStr.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size.width
    }

    static func getTitleLabH(_ str: String, width: CGFloat) -> CGFloat {
        let labH = (str as NSString).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil).size.height
        return labH
    }

    static func getTitleLabW(_ str: String, height: CGFloat) -> CGFloat {
        let labW = (str as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil).size.width
        return labW
    }
    
    @objc func toastTaped() {
        hideAnimation()
    }

    func deviceOrientationDidChanged(notify: Notification) {
        hideAnimation()
    }

    @objc func dismissToast() {
        contentView.removeFromSuperview()
    }

    func setDuration(duration: CGFloat) {
        self.duration = duration
    }

    func showAnimation() {
        UIView.beginAnimations("show", context: nil)
        UIView.setAnimationCurve(UIView.AnimationCurve.easeIn)
        UIView.setAnimationDuration(0.3)
        contentView.alpha = 1.0
        UIView.commitAnimations()
    }

    @objc func hideAnimation() {
        UIView.beginAnimations("hide", context: nil)
        UIView.setAnimationCurve(UIView.AnimationCurve.easeOut)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStop(#selector(dismissToast))
        UIView.setAnimationDuration(0.3)
        contentView.alpha = 0.0
        UIView.commitAnimations()
    }

    func show(view: UIView? = nil) {
        if view != nil {
            contentView.center = view!.center
            view!.addSubview(contentView)
            showAnimation()
            perform(#selector(hideAnimation), with: nil, afterDelay: TimeInterval(duration))
        } else {
            let window: UIWindow = .current!
            contentView.center = window.center
            window.addSubview(contentView)
            showAnimation()
            perform(#selector(hideAnimation), with: nil, afterDelay: TimeInterval(duration))
        }
    }

    func showFromTopOffset(top: CGFloat, view: UIView? = nil) {
        if view != nil {
            contentView.center = CGPoint(x: view!.center.x, y: top + contentView.frame.size.height/2)
            view!.addSubview(contentView)
            showAnimation()
            perform(#selector(hideAnimation), with: nil, afterDelay: TimeInterval(duration))
        } else {
            let window: UIWindow = .current!
            contentView.center = CGPoint(x: window.center.x, y: top + contentView.frame.size.height/2)
            window.addSubview(contentView)
            showAnimation()
            perform(#selector(hideAnimation), with: nil, afterDelay: TimeInterval(duration))
        }
    }

    func showFromBottomOffset(bottom: CGFloat, view: UIView? = nil) {
        if view != nil {
            contentView.center = CGPoint(x: view!.center.x, y: view!.frame.size.height - (bottom + contentView.frame.size.height/2))
            view!.addSubview(contentView)
            showAnimation()
            perform(#selector(hideAnimation), with: nil, afterDelay: TimeInterval(duration))
        } else {
            let window: UIWindow = .current!
            contentView.center = CGPoint(x: window.center.x, y: window.frame.size.height - (bottom + contentView.frame.size.height/2))
            window.addSubview(contentView)
            showAnimation()
            perform(#selector(hideAnimation), with: nil, afterDelay: TimeInterval(duration))
        }
    }

    // MARK: 中间显示

    class func showCenterWithText(text: String? = nil, attributStr: NSMutableAttributedString? = nil, view: UIView? = nil) {
        YDToast.showCenterWithText(text: text, attributStr: attributStr, duration: CGFloat(toastDispalyDuration), view: view)
    }

    class func showCenterWithText(text: String? = nil,
                                  attributStr: NSMutableAttributedString? = nil,
                                  duration: CGFloat,
                                  view: UIView? = nil)
    {
        if String.yd_isEmpty(str: text), attributStr == nil {
            return
            
        } else {
            if !String.yd_isEmpty(str: text) {
                let toast: YDToast = .init(text: text ?? "")
                toast.setDuration(duration: duration)
                YDToastManager.shared.setToast(toast)
                toast.show(view: view)
            } else {
                guard let atts = attributStr else {
                    return
                }
                let toast = YDToast(attributedString: atts)
                toast.setDuration(duration: duration)
                YDToastManager.shared.setToast(toast)
                toast.show(view: view)
            }
        }
    }

    // MARK: 上方显示

    class func showTopWithText(text: String? = nil, attributStr: NSMutableAttributedString? = nil, view: UIView? = nil) {
        YDToast.showTopWithText(text: text, attributStr: attributStr, topOffset: 50.0 + topBarHigh, duration: toastDispalyDuration, view: view)
    }

    class func showTopWithText(text: String? = nil, attributStr: NSMutableAttributedString? = nil, duration: CGFloat, view: UIView? = nil) {
        YDToast.showTopWithText(text: text, attributStr: attributStr, topOffset: 50.0 + topBarHigh, duration: duration, view: view)
    }

    class func showTopWithText(text: String? = nil, attributStr: NSMutableAttributedString? = nil, topOffset: CGFloat, view: UIView? = nil) {
        YDToast.showTopWithText(text: text, attributStr: attributStr, topOffset: topOffset, duration: toastDispalyDuration, view: view)
    }

    class func showTopWithText(text: String? = nil,
                               attributStr: NSMutableAttributedString? = nil,
                               topOffset: CGFloat,
                               duration: CGFloat,
                               view: UIView? = nil)
    {
        if String.yd_isEmpty(str: text), attributStr == nil {
            return
            
        } else {
            if !String.yd_isEmpty(str: text) {
                let toast = YDToast(text: text ?? "")
                toast.setDuration(duration: duration)
                YDToastManager.shared.setToast(toast)
                toast.showFromTopOffset(top: topOffset, view: view)
            } else {
                guard let atts = attributStr else {
                    return
                }
                let toast = YDToast(attributedString: atts)
                toast.setDuration(duration: duration)
                YDToastManager.shared.setToast(toast)
                toast.showFromTopOffset(top: topOffset, view: view)
            }
        }
    }

    // MARK: 下方显示

    class func showBottomWithText(text: String? = nil, attributStr: NSMutableAttributedString? = nil, view: UIView? = nil) {
        YDToast.showBottomWithText(text: text, attributStr: attributStr, bottomOffset: 100.0, duration: toastDispalyDuration, view: view)
    }

    class func showBottomWithText(text: String? = nil, attributStr: NSMutableAttributedString? = nil, duration: CGFloat, view: UIView? = nil) {
        YDToast.showBottomWithText(text: text, attributStr: attributStr, bottomOffset: 100.0, duration: duration, view: view)
    }

    class func showBottomWithText(text: String? = nil, attributStr: NSMutableAttributedString? = nil, bottomOffset: CGFloat, view: UIView? = nil) {
        YDToast.showBottomWithText(text: text, attributStr: attributStr, bottomOffset: bottomOffset, duration: toastDispalyDuration, view: view)
    }

    class func showBottomWithText(text: String? = nil,
                                  attributStr: NSMutableAttributedString? = nil,
                                  bottomOffset: CGFloat,
                                  duration: CGFloat,
                                  view: UIView? = nil)
    {
        if String.yd_isEmpty(str: text), attributStr == nil {
            return
        } else {
            if !String.yd_isEmpty(str: text) {
                let toast = YDToast(text: text ?? "")
                toast.setDuration(duration: duration)
                YDToastManager.shared.setToast(toast)
                toast.showFromBottomOffset(bottom: bottomOffset, view: view)
            } else {
                guard let atts = attributStr else {
                    return
                }
                let toast = YDToast(attributedString: atts)
                toast.setDuration(duration: duration)
                YDToastManager.shared.setToast(toast)
                toast.showFromBottomOffset(bottom: bottomOffset, view: view)
            }
        }
    }
}

class YBHUD: NSObject {
    var hudImg: UIImageView
    var hudView: UIButton
    var hudBgView: UIView
    static var shared = YBHUD()
    override init() {
        hudView = UIButton(frame: UIScreen.main.bounds)
        hudView.backgroundColor = .clear
        hudBgView = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        hudBgView.center = hudView.center
        hudBgView.backgroundColor = .black
        hudBgView.setCornerRadius(10, masksToBounds: false)
        hudBgView.setShadow(color: ColorHex(hexStr: "CCCCCC"), offset: CGSize(width: -2.0, height: 2.0), radius: 8, opacity: 0.3)
        hudView.addSubview(hudBgView)
        
        hudImg = UIImageView(frame: CGRect(x: 15, y: 30, width: 60, height: 30))
        hudBgView.addSubview(hudImg)
        var images = [UIImage]()
        for idx in 0 ... 119 {
            if let aImage = UIImage(named: "loading_\(idx)") {
                images.append(aImage)
            }
        }
        hudImg.animationDuration = 3.5
        hudImg.animationRepeatCount = 0
        hudImg.animationImages = images
        hudImg.startAnimating()
        super.init()
    }

    func showAnimation() {
        UIView.beginAnimations("show", context: nil)
        UIView.setAnimationCurve(UIView.AnimationCurve.easeIn)
        UIView.setAnimationDuration(0.3)
        hudBgView.alpha = 1.0
        UIView.commitAnimations()
    }

    @objc func hideAnimation() {
        UIView.beginAnimations("hide", context: nil)
        UIView.setAnimationCurve(UIView.AnimationCurve.easeOut)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStop(#selector(dismiss))
        UIView.setAnimationDuration(0.3)
        hudBgView.alpha = 0.0
        UIView.commitAnimations()
    }

    @objc func dismiss() {
        hudView.removeFromSuperview()
    }

    func show() {
        let window = UIWindow.current!
        hudView.center = window.center
        window.addSubview(hudView)
        showAnimation()
//        DDLOG(message: "============================HUD 显示了============================")
        
        // self.perform(#selector(hideAnimation), with: nil, afterDelay: TimeInterval(3))
    }

    func hide() {
//        DDLOG(message: "============================HUD 关闭了============================")
        hideAnimation()
    }
}
