//
//  CustomWebViewController.swift
//  StartTimeLine
//
//  Created by 张家和 on 2024/9/23.
//

import UIKit

class CustomWebViewController: STBaseViewController {
    
    private var url: URL
    
    // 通过构造器接收 URL
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置背景颜色
        view.backgroundColor = .white
        
        // 初始化并添加 CustomWebView
        let customWebView = CustomWebView(url: url)
        customWebView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customWebView)
        
        // 设置 CustomWebView 的约束
        NSLayoutConstraint.activate([
            customWebView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            customWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customWebView.leftAnchor.constraint(equalTo: view.leftAnchor),
            customWebView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        // 设置返回按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "nav_back", style: .plain, target: self, action: #selector(didTapBack))
    }
    
    // 返回按钮点击事件
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}
