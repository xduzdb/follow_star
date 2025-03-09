import UIKit
import WebKit

class CustomWebView: UIView {
    
    private var webView: WKWebView!
    private var progressView: UIProgressView!
    private var observation: NSKeyValueObservation?
    var webViewTitleBlock: ((String) -> Void)?
    
    init(url: URL) {
        super.init(frame: .zero)
        setupUI(with: url)
        setupProgressObserver()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(with url: URL) {
        // 初始化进度条
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.tintColor = .systemBlue // 设置进度条颜色
        
        // 初始化 WKWebView
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加子视图
        addSubview(webView)
        addSubview(progressView)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // WebView 约束
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // 进度条约束
            progressView.topAnchor.constraint(equalTo: topAnchor),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2.0)
        ])
        
        // 加载指定的 URL
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func setupProgressObserver() {
        // 观察进度变化
        observation = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] _, _ in
            self?.updateProgress()
        }
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        // 当进度为 1.0 时，延迟隐藏进度条
        if progressView.progress == 1.0 {
            progressView.progress = 0.0
        } else {
            progressView.alpha = 1.0
        }
    }
    
    deinit {
        // 移除观察者
        observation?.invalidate()
    }
}

// WKNavigationDelegate
extension CustomWebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("加载失败: \(error.localizedDescription)")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("加载完成")
        progressView.progress = 0.0
        progressView.alpha = 0.0
        if let title = webView.title {
            print("Webpage title: \(title)")
            webViewTitleBlock?(title)
        }
    }
}
