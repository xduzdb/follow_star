//
//  UIView+Extension.swift
//  BestBuy-ios
//
//  Created by ice on 2020/4/14.
//  Copyright © 2020年 ice. All rights reserved.
//

import UIKit

@objc public extension UIView {
    
    /// x
    var x: CGFloat {
        get {
            return frame.minX
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.x    = newValue
            frame                 = tempFrame
        }
    }
    
    /// y
    var y: CGFloat {
        get {
            return frame.minY
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.y    = newValue
            frame                 = tempFrame
        }
    }
    
    /// top
    var top : CGFloat {
        get {
            return y
        }
        set(newVal) {
            y = newVal
        }
    }
    
    /// bottom
    var bottom : CGFloat {
        get {
            return y + height
        }
        set(newVal) {
            y = newVal - height
        }
    }
    
    /// left
    var left : CGFloat {
        get {
            return frame.maxX
        }
        set(newVal) {
            x = newVal
        }
    }
    
    /// right
    var right : CGFloat {
        get {
            return frame.maxX
        }
        set(newVal) {
            x = newVal - width
        }
    }
    
    /// height
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.height = newValue
            frame                 = tempFrame
        }
    }
    
    /// width
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.width  = newValue
            frame                 = tempFrame
        }
    }
    
    /// size
    var size: CGSize {
        get {
            return frame.size
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size        = newValue
            frame                 = tempFrame
        }
    }
    
    /// centerX
    var centerX: CGFloat {
        get {
            return center.x
        }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.x            = newValue
            center                  = tempCenter
        }
    }
    
    /// centerY
    var centerY: CGFloat {
        get {
            return center.y
        }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.y            = newValue
            center                  = tempCenter;
        }
    }
    
}

public extension UIView {
    //添加点击事件
    func addClickListener(target: AnyObject, action: Selector,params:Any? = nil){
        
        let tapG = UITapGestureRecognizer(target: target, action: action)
        tapG.numberOfTapsRequired = 1
        isUserInteractionEnabled = true
        addGestureRecognizer(tapG)
    }
    
    /// 移除所有子视图
    func removeAllSubviews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    //    //xib设置圆角
    //    @IBInspectable var cornerRadius: CGFloat {
    //        get {
    //            return layer.cornerRadius
    //        }
    //
    //        set {
    //            layer.cornerRadius = newValue
    //            layer.masksToBounds = newValue > 0
    //        }
    //    }
    
    /// 圆角设置
    func setCornerRadius(_ cornerRadius: CGFloat, masksToBounds: Bool = true) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = masksToBounds
    }
    
    /// 圆角设置
    func setCornerRadius(_ cornerRadius: CGFloat, byRoundingCorners corners: UIRectCorner) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer(layer: self.layer)
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    /// 边框设置
    func setBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    /// 投影设置
    /// - parameter color: 颜色
    /// - parameter offset: 偏移
    /// - parameter radius: 模糊半径
    /// - parameter opacity: 不透明度
    func setShadow(color: UIColor, offset: CGSize, radius: CGFloat, opacity: Float) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
    }
    
}




public protocol StoryboardLoadable {}
public extension StoryboardLoadable where Self: UIViewController {
    /// 提供 加载方法
    static func loadStoryboard() -> Self {
        return UIStoryboard(name: "\(self)", bundle: nil).instantiateViewController(withIdentifier: "\(self)") as! Self
    }
}

public protocol NibLoadable {}
public extension NibLoadable {
    static func loadViewFromNib() -> Self {
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.last as! Self
    }
}

public protocol RegisterCellFromNib {}
public extension RegisterCellFromNib {
    
    static var identifier: String { return "\(self)" }
    
    static var nib: UINib? { return UINib(nibName: "\(self)", bundle: nil) }
}

public extension UITableView {
    /// 注册 cell 的方法
    func bl_registerCell<T: UITableViewCell>(cell: T.Type) where T: RegisterCellFromNib {
        if let nib = T.nib { register(nib, forCellReuseIdentifier: T.identifier) }
        else { register(cell, forCellReuseIdentifier: T.identifier) }
    }
    
    /// 从缓存池池出队已经存在的 cell
    func bl_dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: RegisterCellFromNib {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
    //从xib 多个cell中获取自己需要的 cell
    func getNibFromXibCell(nib:String,identifier:String,index:Int,traget:Any) -> Any?{
        let cell:Any? = self.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            
            guard let bundle = Bundle.main.loadNibNamed(nib, owner: traget, options: nil) else{
                return nil
            }
            let ary = bundle as NSArray
            if index >= ary.count {
                return nil
            }
            return ary.object(at: index)
//            for item in ary {
//                let model = item as? UITableViewCell
//                if model?.reuseIdentifier == identifier {
//                    return item
//                }
//            }
//           return nil
        }else{
            return cell
        }
        
    }
}

public extension UICollectionView {
    /// 注册 cell 的方法
    func bl_registerCell<T: UICollectionViewCell>(cell: T.Type) where T: RegisterCellFromNib {
        if let nib = T.nib { register(nib, forCellWithReuseIdentifier: T.identifier) }
        else { register(cell, forCellWithReuseIdentifier: T.identifier) }
    }
    
    /// 从缓存池池出队已经存在的 cell
    func bl_dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: RegisterCellFromNib {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
    
    /// 注册头部
    func bl_registerSupplementaryHeaderView<T: UICollectionReusableView>(reusableView: T.Type) where T: RegisterCellFromNib {
        // T 遵守了 RegisterCellOrNib 协议，所以通过 T 就能取出 identifier 这个属性
        if let nib = T.nib {
            register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.identifier)
        } else {
            register(reusableView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.identifier)
        }
    }
    
    /// 获取可重用的头部
    func bl_dequeueReusableSupplementaryHeaderView<T: UICollectionReusableView>(indexPath: IndexPath) -> T where T: RegisterCellFromNib {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
}



