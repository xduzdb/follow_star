//
//  CustomWebView.swift
//  StartTimeLine
//
//  Created by 张家和 on 2024/9/22.
//
import UIKit
import WebKit

class CustomWebView: UIView {
    
    private var webView: WKWebView!
    
    // 初始化方法，传入要加载的 URL
    init(url: URL) {
        super.init(frame: .zero)
        
        // 初始化 WKWebView
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加 WebView 到当前视图
        addSubview(webView)
        
        // 设置约束
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // 加载指定的 URL
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 遵守 WKNavigationDelegate 协议
extension CustomWebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("加载失败: \(error.localizedDescription)")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("加载完成")
    }
}
