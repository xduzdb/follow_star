import UIKit
import SwiftUI

public class STAlertView: UIView {
    // 定义标题和按钮的文本
    var titleText: String
    var leftBtnText: String
    var rightBtnText: String
    var alertView: UIView!
    var replyTextView: UITextView!
    
    // 遮照背景控制
    private let bgControl = UIControl()
    
    // 回调事件
    var leftAction: (() -> Void)?
    var rightAction: (() -> Void)?
    
    // 初始化传入标题和按钮文本
    init(title: String, leftBtn: String, rightBtn: String, leftAction: (() -> Void)?, rightAction: (() -> Void)?) {
        self.titleText = title
        self.leftBtnText = leftBtn
        self.rightBtnText = rightBtn
        self.leftAction = leftAction
        self.rightAction = rightAction
        super.init(frame: .zero)
        
        setAlertView()  // 设置弹窗视图
    }
    
    public override init(frame: CGRect) {
        self.titleText = "Title"
        self.leftBtnText = "Cancel"
        self.rightBtnText = "OK"
        super.init(frame: frame)
        setAlertView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 设置弹窗视图
    public func setAlertView() {
        // 设置 bgControl（遮照）
        bgControl.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        bgControl.alpha = 0.0
        bgControl.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)  // 点击遮照关闭弹窗
        
        // 设置弹窗背景
        alertView = UIView()
        alertView.backgroundColor = UIColor.white
        alertView.setCornerRadius(ST_DP(12), masksToBounds: true)
        
        // 标题标签
        let titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: ST_DP(18))
        
        // 纠错文本框
        replyTextView = UITextView()
        replyTextView.setCornerRadius(ST_DP(12), masksToBounds: true)
        replyTextView.font = .systemFont(ofSize: ST_DP(14))
        replyTextView.textColor = .gray
        replyTextView.contentInset = UIEdgeInsets(
            top: ST_DP(6),
            left: ST_DP(8),
            bottom: ST_DP(12),
            right: ST_DP(12)
        )
        replyTextView.backgroundColor = UIColor(
            red: 247/255,
            green: 248/255,
            blue: 250/255,
            alpha: 1.0
        )
        
        // 纠错占位符
        let placeHolderLb = UILabel()
        placeHolderLb.text = "请输入错误描述"
        placeHolderLb.textColor = .gray
        placeHolderLb.font = .systemFont(ofSize: ST_DP(14))
        
        // 更新占位符可见性
        updatePlaceholderVisibility()
        
        // 限制条件 500字以内
        let tipsLb = UILabel()
        tipsLb.text = "500字以内"
        tipsLb.textColor = ColorHex(hexStr: "C9CDD4")
        tipsLb.font = .systemFont(ofSize: ST_DP(11))
        
        // 横向分隔条
        let horizonBar = UIView()
        horizonBar.backgroundColor = ColorHex(hexStr: "D9D9D9")
        horizonBar.setCornerRadius(ST_DP(3), masksToBounds: true)
        
        // 左侧按钮
        let leftButton = UIButton(type: .system)
        leftButton.setTitle(leftBtnText, for: .normal)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        leftButton.backgroundColor = .white
        leftButton.layer.borderColor = ColorHex(hexStr: "EEEEEE").cgColor
        leftButton.layer.borderWidth = 1
        leftButton.setTitleColor(.black, for: .normal)
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        leftButton.setCornerRadius(ST_DP(8), masksToBounds: true)
        
        // 右侧按钮
        let rightButton = UIButton(type: .system)
        rightButton.setTitle(rightBtnText, for: .normal)
        rightButton.layer.backgroundColor = ColorHex(hexStr: "FF7E3F").cgColor //E84C4F
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightButton.setTitleColor(.white, for: .normal)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        rightButton.setCornerRadius(ST_DP(8), masksToBounds: true)
        
        // 按钮容器视图
        let buttonStackView = UIStackView(arrangedSubviews: [leftButton, rightButton])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = ST_DP(24)
        
        // 将元素添加到弹窗
        addSubview(bgControl)   // 添加遮照
        addSubview(alertView)   // 添加弹窗
        alertView.addSubview(titleLabel)
        alertView.addSubview(horizonBar)
        alertView.addSubview(buttonStackView)
        alertView.addSubview(replyTextView)
        alertView.addSubview(tipsLb)
        replyTextView.addSubview(placeHolderLb)
        
        // 关闭自动布局约束
        bgControl.translatesAutoresizingMaskIntoConstraints = false
        alertView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        horizonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        tipsLb.translatesAutoresizingMaskIntoConstraints = false
        replyTextView.translatesAutoresizingMaskIntoConstraints = false
        placeHolderLb.translatesAutoresizingMaskIntoConstraints = false
        
        // 设置遮照尺寸和居中位置
        NSLayoutConstraint.activate([
            // 遮照铺满整个屏幕
            bgControl.widthAnchor.constraint(equalTo: self.widthAnchor),
            bgControl.heightAnchor.constraint(equalTo: self.heightAnchor),
            bgControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bgControl.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            // 弹窗宽度为屏幕宽度，底部弹出
            alertView.widthAnchor.constraint(equalTo: self.widthAnchor),
            alertView.heightAnchor.constraint(equalToConstant: ST_DP(409)),
            alertView.leftAnchor.constraint(equalTo: self.leftAnchor),
            alertView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        // 弹窗内容布局
        NSLayoutConstraint.activate([
            // 标题在顶部，水平居中 36 25 12 52
            titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: ST_DP(52)),
            titleLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: ST_DP(12)),
            titleLabel.widthAnchor.constraint(equalToConstant: ST_DP(36)),
            titleLabel.heightAnchor.constraint(equalToConstant: ST_DP(25)),
            
            /// 文本框
            // ReplyTextView 约束
            replyTextView.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: ST_DP(12)),
            replyTextView.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -ST_DP(12)),
            replyTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ST_DP(22)),
            replyTextView.heightAnchor.constraint(equalToConstant: ST_DP(140)),

            // PlaceHolderLb 约束
            placeHolderLb.leftAnchor.constraint(equalTo: replyTextView.leftAnchor, constant: ST_DP(4)),
            placeHolderLb.topAnchor.constraint(equalTo: replyTextView.topAnchor, constant: ST_DP(7)),
            
            // 约束条件
            tipsLb.topAnchor.constraint(equalTo: replyTextView.bottomAnchor, constant: ST_DP(8)),
            tipsLb.rightAnchor.constraint(equalTo: replyTextView.rightAnchor),
            tipsLb.heightAnchor.constraint(equalToConstant: ST_DP(20)),
            
            // 分隔条 48 6
            horizonBar.topAnchor.constraint(equalTo: alertView.topAnchor, constant: ST_DP(12)),
            horizonBar.heightAnchor.constraint(equalToConstant: ST_DP(6)),
            horizonBar.widthAnchor.constraint(equalToConstant: ST_DP(48)),
            horizonBar.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            
            // 按钮位于分隔条下方，充满宽度 16 75
            buttonStackView.topAnchor.constraint(equalTo: replyTextView.bottomAnchor, constant: ST_DP(75)),
            buttonStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: ST_DP(16)),
            buttonStackView.heightAnchor.constraint(equalToConstant: ST_DP(53)),
            buttonStackView.widthAnchor.constraint(equalToConstant: ST_DP(343))
        ])
    }
    
    // 左侧按钮点击事件
    @objc private func leftButtonTapped() {
        leftAction?() // 执行左侧按钮的回调
        dismissAlert()
    }
    
    // 右侧按钮点击事件
    @objc private func rightButtonTapped() {
        rightAction?() // 执行右侧按钮的回调
        dismissAlert()
    }
    
    
    // 显示弹窗
    public func showAlert(on view: UIView) {
        self.frame = view.bounds
        view.addSubview(self)
        
        // 初始状态：弹窗在屏幕底部，遮照透明
        self.alertView.alpha = 1.0
        self.alertView.transform = CGAffineTransform(translationX: 0, y: view.frame.height) // 从底部弹出
        bgControl.alpha = 0.0  // 遮照开始透明
        
        // 动画展示：遮照渐渐显示，弹窗从底部弹出
        UIView.animate(withDuration: 0.3, animations: {
            self.bgControl.alpha = 1.0  // 遮照渐显
        })
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.alertView.transform = .identity  // 弹窗从底部弹出到原位
        }, completion: nil)
    }
    
    // 关闭弹窗
    @objc public func dismissAlert() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.bgControl.alpha = 0.0  // 遮照渐隐
            self.alertView.transform = CGAffineTransform(translationX: 0, y: self.frame.height)  // 弹窗下移消失
        }, completion: { _ in
            self.removeFromSuperview()  // 动画结束后移除弹窗
        })
    }
    
    func updatePlaceholderVisibility() {
        guard let placeHolderLb = replyTextView.subviews.first(where: { $0 is UILabel }) as? UILabel else {
            return
        }
        placeHolderLb.isHidden = !replyTextView.text.isEmpty
    }
}

// 代理
extension STAlertView: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderVisibility()
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        updatePlaceholderVisibility()
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        updatePlaceholderVisibility()
    }
}

