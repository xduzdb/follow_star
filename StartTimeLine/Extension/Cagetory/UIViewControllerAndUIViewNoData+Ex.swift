//
//  UIViewControllerAndUIViewNoData+Ex.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/5.
//

import UIKit
 private var UIViewControllerIsShowEmptyStatusKey: String = "UIViewControllerIsShowEmptyStatusKey"


extension UIViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    var isShowEmptyStatus:Bool? {
            get {
                return (objc_getAssociatedObject(self, &UIViewControllerIsShowEmptyStatusKey) as? Bool)
            }
            set(newValue) {
                objc_setAssociatedObject(self, &UIViewControllerIsShowEmptyStatusKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
    }
    //MARK: - DZNEmptyDataSetSource
    //默认字符串。
    @objc public func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?{
        return nil
    }
    //默认描述
    @objc public func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?{
        return nil
    }
    //默认图片
    @objc public func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage?{
        return nil
    }
    //默认文字颜色
    @objc public func imageTintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor?{
        return nil
    }
    //默认动画
    @objc public func imageAnimation(forEmptyDataSet scrollView: UIScrollView) -> CAAnimation?{
        return nil
    }
    //btn 文字
    @objc public func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString?{
        return nil
    }
    //btn 图片
    @objc public func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage?{
        return nil
    }
    //btn 背景图
    @objc public func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage?{
        return nil
    }
    //背景色
    @objc public func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor?{
        return ColorHex(rgb: 0xf4f4f4)
    }
    //自定义view
    @objc public func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView?{
        
        return nil
    }
    // 偏移
    @objc public func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat{
        let  root = ydGetCurrentRootViewController()
//             let root = (appDelegate.window?.rootViewController)!
             if root.isKind(of: UITabBarController.self) {
                 let tab = root as! UITabBarController
                 if !tab.tabBar.isHidden {
                     return -tab.tabBar.frame.size.height
                 }
             }
             return 0
    }
    // 间隔
    @objc public func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat{
        return 0
    }
    //MARK: - DZNEmptyDataSetDelegate
    //是否应渲染并显示空页面。默认为true。
    @objc public func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return false
    }
     //显示时是否应淡入 动画效果
    @objc public func emptyDataSetShouldFadeIn(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    //当项目数大于0时是否仍应显示空数据集。默认值为false。
    @objc public func emptyDataSetShouldBeForcedToDisplay(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    //是否允许触摸
    @objc public  func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    //是否允许滚动
    @objc public func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    //是否展示图片动画
    @objc public func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    //点击了页面
    @objc public func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        
    }
    //点击了按钮
    @objc public func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        
    }
    //将要出现
    @objc public func emptyDataSetWillAppear(_ scrollView: UIScrollView) {
        
    }
    //已经出现
    @objc public func emptyDataSetDidAppear(_ scrollView: UIScrollView) {
        
    }
    //页面将要消失
    @objc public func emptyDataSetWillDisappear(_ scrollView: UIScrollView) {
        
    }
    //页面消失
    @objc public func emptyDataSetDidDisappear(_ scrollView: UIScrollView) {
        
    }
}
