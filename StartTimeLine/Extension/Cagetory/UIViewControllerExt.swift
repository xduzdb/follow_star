//
//  UIViewControllerExt.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/16.
//

import Foundation
import UIKit

public struct CustomNavBadgeModel {
    //带角标的导航栏按钮 text  imageStr 设置独立类型 image 类型支持角标
    
    //文字  文字左边icon 文字大小 文字颜色
    var text:String?
    var textColor:UIColor?
    var textFont:UIFont?
    var textIcon:String?
    
    //图片+角标
    var imageStr:String?
    var badge:Int = 0
    init(text:String,textIcon:String? = nil,textColor:UIColor,textFont:UIFont) {
        self.text = text
        self.textIcon = textIcon
        self.textColor = textColor
        self.textFont = textFont
    }
    init(imageStr:String,badge:Int = 0) {
        self.imageStr = imageStr
        self.badge = badge
    }
}

fileprivate func currentController() -> UIViewController? {
    guard let keyWindow = UIWindow.current else {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    func currentController(with view: UIView, depth: Int) -> UIViewController? {
        guard depth < 3 else { return nil }
        for subview in view.subviews.reversed() {
            if let vc = subview.next as? UIViewController {
                return vc
            } else if let vc = currentController(with: subview, depth: depth + 1) {
                return vc
            }
        }
        return nil
    }
    return currentController(with: keyWindow, depth: 0)
}


public extension UIViewController {
    
    /// 当前 UIViewController
    static var current: UIViewController? {
        var result = currentController()
        if let tabBarController = result as? UITabBarController {
            result = tabBarController.selectedViewController
        }
        if let navigationController = result as? UINavigationController {
            result = navigationController.topViewController
        }
        return result
    }
    
    /// 返回上个页面
    /// - parameter animated: 是否动画
    func pop(animated flag: Bool) {
        guard let nc = self.navigationController else {
            self.dismiss(animated: flag, completion: nil)
            return
        }
        if (nc.viewControllers.count == 1) {
            self.dismiss(animated: flag, completion: nil)
        } else {
            nc.popViewController(animated: flag)
        }
    }
    
    //MARK: --设置导航栏右边图标按钮
    func setNavRightIconBtn(_ iconName: String){
        if iconName.isEmpty{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIView())
        }else{
            let itemButton = UIButton(type: .custom)
            itemButton.size = CGSize(width: 64, height: 44)
            itemButton.contentHorizontalAlignment = .center
            itemButton.setImage(UIImage(named: iconName), for: UIControl.State())
            itemButton.setImage(UIImage(named: iconName), for: .highlighted)
            itemButton.addTarget(self, action: #selector(navRightIconBtnAction), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: itemButton)
        }
    }
    //MARK: --设置导航栏右边图标按钮  多个按钮  带角标
    func setCustomBadgeNavRightIconsView(_ list: [CustomNavBadgeModel]){
        if list.count == 0{
            return
        }else{
            var items = [UIBarButtonItem(customView: UIView.init(frame: CGRect.init(x: 0, y: 0, width: 5, height: 44)))]  //添加一个空白view 抵消导航按钮的偏移
            for (idx,item) in list.enumerated() {
                let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 44))
                view.addClickListener(target: self, action: #selector(customNavRightIconBtnAction(_:)))
                view.tag = idx
                view.backgroundColor = .clear
                if let image = item.imageStr  {
                    let imageV = UIImageView.init(frame: CGRect.init(x: (view.width - 20)/2, y: (view.height - 20)/2, width: 20, height: 20  ))
                    imageV.image = UIImage.init(named: image)
                    imageV.isUserInteractionEnabled = true
                    view.addSubview(imageV)
                    var w = 0
                    var space = 2
                    var badgeStr  = ""
                    if item.badge<=0 {
                        w = 0
                    }else if item.badge<10{
                        w = 12
                        badgeStr = "\(item.badge)"
                    }else if item.badge < 100{
                        w = 16
                        badgeStr = "\(item.badge)"
                    }else{
                        w = 22
                        space = 0
                        
                        badgeStr = "99+"
                    }
                    let badgeLabel = UILabel.init(frame: CGRect.init(x: Int(view.width)/2 + space, y: (Int(view.height) - 12)/2 - 8, width: w, height: 12))
                    badgeLabel.text  = badgeStr
                    badgeLabel.textAlignment = .center
                    badgeLabel.font = UIFont.systemFont(ofSize: 8)
                    badgeLabel.textColor = .white
                    badgeLabel.backgroundColor = ColorHex(rgb: 0xFF453E)
                    badgeLabel.layer.cornerRadius = 6
                    badgeLabel.layer.masksToBounds = true
                    view.addSubview(badgeLabel)
                }else{
                    if let str = item.text {
                        var  x:CGFloat = 3.0
                        if let iconStr = item.textIcon, let image = UIImage.init(named: iconStr) {
                            let fontSize = ceil(item.textFont?.pointSize ?? 0)
                            let scale = image.size.height / image.size.width
                            let imageV = UIImageView.init(frame: CGRect.init(x: x, y: (view.height -  fontSize * scale)/2, width: fontSize, height: fontSize * scale  ))
                            x += ceil(fontSize * scale)
                            imageV.image = image
                            imageV.isUserInteractionEnabled = true
                            view.addSubview(imageV)
                        }
                        let w  = YDLableSizeUtil.getNormalStrWidth(str: str, h: 20, font: item.textFont!)
                        let lb = UILabel.init(frame: CGRect.init(x: x + 2, y: (view.height - 20)/2, width: w+2, height: 20))
                        lb.textAlignment = .right
                        lb.textColor = item.textColor
                        lb.font = item.textFont
                        lb.text = str
                        x += w
                        view.width = x + 6
                        
                        view.addSubview(lb)
                    }
                    
                }
                items.append(UIBarButtonItem(customView: view))
                
            }
            
            self.navigationItem.rightBarButtonItems = items
        }
    }
    
    
    
    
    //MARK: -- 设置导航栏有点文本按钮
    func setNavRightTitleBtn(_ title: String){
        if title.isEmpty{return}
        let itemButton = UIButton(type: .custom)
        //let w = String.getNormalStrWidth(str: title, attriStr: nil, font: UIFont.systemFont(ofSize: 16), h: 44) + 20
        let w = YDLableSizeUtil.getNormalStrWidth(str: title, h: 44, font: UIFont.systemFont(ofSize: 16)) + 20
        
        itemButton.size = CGSize(width: w, height: 44)
        itemButton.contentHorizontalAlignment = .center
        itemButton.setTitle(title, for: .normal)
        itemButton.setTitleColor(ColorHex(hexStr:"#2E2A20"), for: .normal)
        itemButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        itemButton.addTarget(self, action: #selector(navRightIconBtnAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: itemButton)
    }
    @objc func navRightIconBtnAction(){
        
    }
    @objc func customNavRightIconBtnAction(_ tap:UITapGestureRecognizer){
        
    }
    @objc func backClick(){
        guard let nc = self.navigationController else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        if (nc.viewControllers.count == 1) {
            self.dismiss(animated: true, completion: nil)
        } else {
            nc.popViewController(animated: true)
        }
    }
    ///pop跳转到指定页面
    @objc func popTargetPage(targetVC:AnyClass,animate:Bool){
        guard let nav = self.navigationController else {
            self.dismiss(animated: animate, completion: nil)
            return
        }
        if (nav.viewControllers.count == 1) {
            self.dismiss(animated: animate, completion: nil)
        } else {
            var  vc:UIViewController?
            for item in nav.viewControllers {
                if item.isKind(of: targetVC) {
                    vc = item
                }
            }
            if vc != nil {
                nav.popToViewController(vc!, animated: animate)
            }else{
                nav.pop(animated: animate)
            }
        }
    }
    @objc func netWorkStatusExchange(status:Int){
        
        
    }
    
}

