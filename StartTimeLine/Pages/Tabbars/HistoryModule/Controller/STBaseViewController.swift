//
//  STBaseViewController.swift
//  StartTimeLine
//
//  Created by 张家和 on 2024/9/23.
//

// 打开H5页面
import UIKit

@objc public class STBaseViewController: UIViewController, UINavigationControllerDelegate {
    //    let switchStatus: Bool = ViewController().switchTheme.isOn
    
    var rightBtnTitleColor: UIColor?
    var rightBtn: UIButton?
    var isViewShow = false
    var leftBtn: UIButton?

    
    private let navigationTitleColor: UIColor = .black // 可以根据需要修改颜色
    private let navigationTitleFont: UIFont = .systemFont(ofSize: 18, weight: .medium)
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // 导航不透明，而且保证页面（0,0）开始
        navigationController?.navigationBar.isTranslucent = false
        extendedLayoutIncludesOpaqueBars = true
        modalPresentationStyle = .fullScreen
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        // 设置导航栏标题样式
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [
                .foregroundColor: navigationTitleColor,
                .font: navigationTitleFont
            ]
              
            // 设置导航栏背景色
            navigationBar.backgroundColor = .white
              
            // 如果需要移除导航栏底部线条
            // navigationBar.shadowImage = UIImage()
            // navigationBar.setBackgroundImage(UIImage(), for: .default)
        }
    }
    
    // 提供一个设置标题的公共方法
    @objc public func setNavigationTitle(_ title: String) {
        self.title = title
        let titleLabel = UILabel(frame:CGRect(
            x: ST_DP(13 + 12),
            y: ST_DP(48),
            width: STHelper.screenWidth - ST_DP(26 * 2),
            height: ST_DP(40)
        ))
        titleLabel.textColor = UIColor.text333Color()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
        titleLabel.text = title
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
    }
        
    // 提供一个设置标题颜色的公共方法
    @objc public func setNavigationTitleColor(_ color: UIColor) {
        var titleTextAttributes = navigationController?.navigationBar.titleTextAttributes ?? [:]
        titleTextAttributes[.foregroundColor] = color
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
    }
        
    // 提供一个设置标题字体的公共方法
    @objc public func setNavigationTitleFont(_ font: UIFont) {
        var titleTextAttributes = navigationController?.navigationBar.titleTextAttributes ?? [:]
        titleTextAttributes[.font] = font
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self != navigationController?.viewControllers.first {
            setLeftBtn(named: "nav_back")
        }
    }
    
    @objc public func setLeftBtn(named name: String) {
        let backBtn = UIButton(
            frame: CGRect(
                x: ST_DP(13),
                y: ST_DP(58),
                width: ST_DP(12),
                height: ST_DP(24)
            )
        )
        backBtn.setImage(UIImage(named: name), for: .normal)
        backBtn.addTarget(self, action: #selector(leftBtnPressed(button:)), for: .touchUpInside)
        view.addSubview(backBtn)
    }
    
    
    override public func viewDidAppear(_ animated: Bool) {
        // [LaunchTimeCount launchTime:3];
        isViewShow = true
        super.viewDidAppear(animated)
        if navigationController?.viewControllers.count == 1 {
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        } else {
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
        // 不添加这句话  左滑返回会失效
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        isViewShow = false
        super.viewWillDisappear(animated)
    }
    
    @objc public func leftBtnPressed(button: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
