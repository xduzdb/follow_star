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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // 兼容iOS10
        automaticallyAdjustsScrollViewInsets = true
        // 导航不透明，而且保证页面（0,0）开始
        navigationController?.navigationBar.isTranslucent = false
        extendedLayoutIncludesOpaqueBars = true
        modalPresentationStyle = .fullScreen
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self != self.navigationController?.viewControllers.first {
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
    
    public override func viewDidAppear(_ animated: Bool) {
        // [LaunchTimeCount launchTime:3];
        isViewShow = true
        super.viewDidAppear(animated)
        if navigationController?.viewControllers.count == 1 {
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        } else {
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
        //不添加这句话  左滑返回会失效
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        isViewShow = false
        super.viewWillDisappear(animated)
    }
    
    @objc public func leftBtnPressed(button: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
