//
//  HistoryTabCardView.swift
//  StartTimeLine
//
//  Created by zhangjiahe17 on 2024/9/9.
//


import UIKit
import WebKit

public class HistoryTabCardView: UIView {
    // 点赞人数
    var likeNum: Int!
    // 日期
    var dateLb: UILabel!
    // 有文字状态
    var paraView: UIView!
    // 点赞按钮
    var likeBtn: UIButton!
    // 卡片内容部分
    var contentLb: UILabel!
    // 点赞人数视图
    var likeNumLb: UILabel!
    // 无文字状态
    var holderView: UIView!
    // 纠错按钮
    var correctBtn: UIButton!
    // 点赞状态
    var isLiked: Bool = false
    // 缩放倍数
    var cardScaleFactor: CGFloat?
    // 回复视图
    var replyTextView: UITextView!
    // 添加事件的点击事件
    var addEventBlock: (() -> Void)?
    // 展示弹窗
    var showAlertViewBlock: (() -> Void)?
    var placeHolderLb: UILabel!
    var editBeginBlock: (() -> Void)?
    
    // 整体用一个CollectionView实现左右滑切换日期
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setBgView()
        setImageBar()
        setDateBar()
        setContentBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        cardScaleFactor = self.bounds.size.width / ST_DP(343)
        self.setCornerRadius(ST_Scale_DP(12), masksToBounds: true)
    }
    
    func setBgView() {
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = .clear
        
        let effect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(bgView)
        sendSubviewToBack(bgView)
        bgView.addSubview(blurView)
        
        // 设置约束
        NSLayoutConstraint.activate([
            bgView.leftAnchor.constraint(equalTo: leftAnchor),
            bgView.rightAnchor.constraint(equalTo: rightAnchor),
            bgView.topAnchor.constraint(equalTo: topAnchor),
            bgView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            blurView.leftAnchor.constraint(equalTo: bgView.leftAnchor),
            blurView.rightAnchor.constraint(equalTo: bgView.rightAnchor),
            blurView.topAnchor.constraint(equalTo: bgView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bgView.bottomAnchor)
        ])
    }
    
    func setImageBar() {
        let imageBarView = UIView()
        imageBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageBarView)
        
        let todayIV = UIImageView(image: UIImage(named: "tab_bar_today"))
        todayIV.translatesAutoresizingMaskIntoConstraints = false
        imageBarView.addSubview(todayIV)
        
        let calendarIV = UIImageView(image: UIImage(named: "calendar"))
        calendarIV.translatesAutoresizingMaskIntoConstraints = false
        todayIV.addSubview(calendarIV)
        
        let todayLb = UILabel()
        todayLb.text = "那年今日"
        todayLb.font = .systemFont(ofSize: ST_Scale_DP(14))
        todayLb.textColor = UIColor(red: (15*16)/255, green: (5*16+15)/255, blue: (4*16+9)/255, alpha: 1.0)
        todayLb.translatesAutoresizingMaskIntoConstraints = false
        todayIV.addSubview(todayLb)
        
        let replyBtn = UIButton(type: .custom)
        replyBtn.setImage(UIImage(named: "reply"), for: .normal)
        replyBtn.translatesAutoresizingMaskIntoConstraints = false
        imageBarView.addSubview(replyBtn)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // ImageBarView 约束
            imageBarView.leftAnchor.constraint(equalTo: leftAnchor),
            imageBarView.rightAnchor.constraint(equalTo: rightAnchor),
            imageBarView.topAnchor.constraint(equalTo: topAnchor),
            imageBarView.heightAnchor.constraint(equalToConstant: ST_Scale_DP(40)),
            
            // TodayImageView 约束
            todayIV.leftAnchor.constraint(equalTo: imageBarView.leftAnchor),
            todayIV.topAnchor.constraint(equalTo: imageBarView.topAnchor),
            todayIV.bottomAnchor.constraint(equalTo: imageBarView.bottomAnchor),
            todayIV.widthAnchor.constraint(equalToConstant: ST_Scale_DP(123)),
            
            // CalendarImageView 约束
            calendarIV.leftAnchor.constraint(equalTo: todayIV.leftAnchor, constant: ST_DP(12)),
            calendarIV.topAnchor.constraint(equalTo: todayIV.topAnchor, constant: ST_DP(11)),
            calendarIV.widthAnchor.constraint(equalToConstant: ST_Scale_DP(18)),
            calendarIV.heightAnchor.constraint(equalToConstant: ST_Scale_DP(18)),
            
            // TodayLabel 约束
            todayLb.leftAnchor.constraint(equalTo: todayIV.leftAnchor, constant: ST_DP(34)),
            todayLb.centerYAnchor.constraint(equalTo: todayIV.centerYAnchor),
            todayLb.widthAnchor.constraint(equalToConstant: ST_Scale_DP(56)),
            todayLb.heightAnchor.constraint(equalToConstant: ST_Scale_DP(20)),
            
            // ReplyButton 约束
            replyBtn.rightAnchor.constraint(equalTo: imageBarView.rightAnchor, constant: -ST_DP(12)),
            replyBtn.centerYAnchor.constraint(equalTo: imageBarView.centerYAnchor),
            replyBtn.widthAnchor.constraint(equalToConstant: ST_Scale_DP(24)),
            replyBtn.heightAnchor.constraint(equalToConstant: ST_Scale_DP(24))
        ])
    }
    
    func setDateBar() {
        dateLb = UILabel()
        dateLb.translatesAutoresizingMaskIntoConstraints = false
        dateLb.text = "2019年7月31日"
        dateLb.font = .systemFont(ofSize: ST_Scale_DP(18))
        dateLb.textColor = .white
        dateLb.sizeToFit() // 仍然可以使用 sizeToFit 来计算文本的实际大小
        
        addSubview(dateLb)
        
        // 设置约束
        NSLayoutConstraint.activate([
            dateLb.leftAnchor.constraint(equalTo: leftAnchor, constant: ST_DP(12)),
            dateLb.topAnchor.constraint(equalTo: topAnchor, constant: ST_DP(52)),
            dateLb.widthAnchor.constraint(greaterThanOrEqualToConstant: 0) // 允许标签根据内容调整宽度
        ])
    }
    
    func setContentBar() {
        // 创建 contentView 并设置属性
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = ST_Scale_DP(12)
        contentView.clipsToBounds = true
        addSubview(contentView)

        // 有文字状态
        paraView = UIView()
        paraView.translatesAutoresizingMaskIntoConstraints = false
        paraView.isHidden = true
        contentView.addSubview(paraView)

        // 无文字状态
        holderView = UIView()
        holderView.translatesAutoresizingMaskIntoConstraints = false
        holderView.isHidden = true
        contentView.addSubview(holderView)

        // 正文内容
        contentLb = UILabel()
        contentLb.translatesAutoresizingMaskIntoConstraints = false
        contentLb.textColor = .black
        contentLb.numberOfLines = 0
        contentLb.lineBreakMode = .byTruncatingTail
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = ST_Scale_DP(13)
        contentLb.attributedText = NSAttributedString(
            string: "hahahaha",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: ST_Scale_DP(18)),
                .paragraphStyle: paraStyle
            ]
        )
        paraView.addSubview(contentLb)
        
        // 正文纠错
        correctBtn = UIButton()
        correctBtn.setImage(UIImage(named: "exclamation_mark"), for: .normal)
        paraView.addSubview(correctBtn)
        correctBtn.addTarget(self, action: #selector(popAlertView), for: .touchUpInside)
        correctBtn.translatesAutoresizingMaskIntoConstraints = false

        // 点赞按钮
        likeBtn = UIButton(type: .custom)
        likeBtn.translatesAutoresizingMaskIntoConstraints = false
        likeBtn.setImage(UIImage(named: "thumb_unlike"), for: .normal)
        likeBtn.layer.borderColor = CGColor(red: 239/255, green: 95/255, blue: 73/255, alpha: 1.0)
        likeBtn.layer.borderWidth = ST_DP(0.5)
        likeBtn.backgroundColor = UIColor(
            red: 15*16/255,
            green: (5*16+15)/255,
            blue: (4*16+9)/255,
            alpha: 0.03
        )
        likeBtn.addTarget(self, action: #selector(likeBtnAction), for: .touchUpInside)
        likeBtn.layer.cornerRadius = ST_Scale_DP(24) // 假设宽度和高度都是 48
        paraView.addSubview(likeBtn)

        // 点赞人数标签
        likeNumLb = UILabel()
        likeNumLb.translatesAutoresizingMaskIntoConstraints = false
        likeNum = 100
        likeNumLb.text = "----- \(likeNum ?? 0)人点赞 -----"
        likeNumLb.textColor = .gray
        likeNumLb.font = .systemFont(ofSize: ST_Scale_DP(13))
        paraView.addSubview(likeNumLb)

        // 回复文本视图
        replyTextView = UITextView()
        replyTextView.translatesAutoresizingMaskIntoConstraints = false
        replyTextView.layer.cornerRadius = ST_Scale_DP(12)
        replyTextView.font = .systemFont(ofSize: ST_Scale_DP(14))
        replyTextView.textColor = .gray
        replyTextView.delegate = self
        // 设置键盘消失模式
        replyTextView.keyboardDismissMode = .interactive
        replyTextView.contentInset = UIEdgeInsets(
            top: ST_Scale_DP(6),
            left: ST_Scale_DP(8),
            bottom: ST_Scale_DP(12),
            right: ST_Scale_DP(12)
        )
        replyTextView.backgroundColor = UIColor(
            red: 247/255,
            green: 248/255,
            blue: 250/255,
            alpha: 1.0
        )
        contentView.addSubview(replyTextView)

        // 回复占位符
        placeHolderLb = UILabel()
        placeHolderLb.translatesAutoresizingMaskIntoConstraints = false
        placeHolderLb.text = "你想对那年今日的“KAI或者自己”说点什么？"
        placeHolderLb.textColor = .gray
        placeHolderLb.font = .systemFont(ofSize: ST_Scale_DP(14))
        replyTextView.addSubview(placeHolderLb)

        // 更新占位符可见性
        updatePlaceholderVisibility()

        // 无文字状态下的兜底图
        let holderIV = UIImageView(image: UIImage(named: "empty_place_holder"))
        holderIV.translatesAutoresizingMaskIntoConstraints = false
        holderView.addSubview(holderIV)

        // 兜底文案
        let holderLb = UILabel()
        holderLb.translatesAutoresizingMaskIntoConstraints = false
        holderLb.text = "今日我想静静！好好爱自己哦！"
        holderLb.textColor = UIColor(
            red: (12*16+9)/255,
            green: (12*16+13)/255,
            blue: (13*16+4)/255,
            alpha: 1.0
        )
        holderLb.font = .systemFont(ofSize: ST_Scale_DP(13))
        holderView.addSubview(holderLb)

        // 兜底按钮
        let holderBtn = UIButton(type: .custom)
        holderBtn.translatesAutoresizingMaskIntoConstraints = false
        holderBtn.setImage(UIImage(named: "tips_plus"), for: .normal)
        holderBtn.setTitle("添加事件", for: .normal)
        holderBtn.addTarget(self, action: #selector(addEvent), for: .touchUpInside)
        holderBtn.setTitleColor(UIColor(
            red: (14*16+15)/255,
            green: (5*16+15)/255,
            blue: (4*16+9)/255,
            alpha: 1.0
        ), for: .normal)
        holderBtn.backgroundColor = UIColor(
            red: (14*16+15)/255,
            green: (5*16+15)/255,
            blue: (4*16+9)/255,
            alpha: 0.1
        )
        holderBtn.layer.cornerRadius = ST_Scale_DP(18) // 假设宽度和高度都是 36
        holderView.addSubview(holderBtn)

        // 设置约束
        NSLayoutConstraint.activate([
            // ContentView 约束
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: ST_DP(89)),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),

            
            /// 无文字
            // HolderView 约束
            holderView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            holderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ST_Scale_DP(23)),
            holderView.widthAnchor.constraint(equalToConstant: ST_Scale_DP(311)),
            holderView.heightAnchor.constraint(equalToConstant: ST_Scale_DP(236)),
            
            // HolderIV 约束
            holderIV.widthAnchor.constraint(equalToConstant: ST_Scale_DP(120)),
            holderIV.heightAnchor.constraint(equalToConstant: ST_Scale_DP(120)),
            holderIV.topAnchor.constraint(equalTo: holderView.topAnchor),
            holderIV.centerXAnchor.constraint(equalTo: holderView.centerXAnchor),

            // HolderLb 约束
            holderLb.centerXAnchor.constraint(equalTo: holderIV.centerXAnchor),
            holderLb.topAnchor.constraint(equalTo: holderIV.bottomAnchor, constant: ST_DP(4)),

            // HolderBtn 约束
            holderBtn.centerXAnchor.constraint(equalTo: holderIV.centerXAnchor),
            holderBtn.topAnchor.constraint(equalTo: holderLb.bottomAnchor, constant: ST_DP(24)),
            holderBtn.widthAnchor.constraint(equalToConstant: ST_Scale_DP(112)),
            holderBtn.heightAnchor.constraint(equalToConstant: ST_Scale_DP(36)),

            
            /// 有文字
            // ParaView 约束
            paraView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ST_Scale_DP(12)),
            paraView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            paraView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            paraView.heightAnchor.constraint(equalToConstant: ST_Scale_DP(240)),
            
            // ContentLb 约束
            contentLb.centerXAnchor.constraint(equalTo: paraView.centerXAnchor),
            contentLb.topAnchor.constraint(equalTo: paraView.topAnchor),
            contentLb.leftAnchor.constraint(equalTo: paraView.leftAnchor, constant: ST_Scale_DP(16)),
            contentLb.rightAnchor.constraint(equalTo: paraView.rightAnchor, constant: -ST_Scale_DP(16)),
            
            // 纠错按钮
            correctBtn.widthAnchor.constraint(equalToConstant: ST_Scale_DP(12)),
            correctBtn.heightAnchor.constraint(equalToConstant: ST_Scale_DP(12)),
            correctBtn.rightAnchor.constraint(equalTo: contentLb.rightAnchor),
            correctBtn.topAnchor.constraint(equalTo: contentLb.bottomAnchor),

            // LikeBtn 约束
            likeBtn.centerXAnchor.constraint(equalTo: paraView.centerXAnchor),
            likeBtn.bottomAnchor.constraint(equalTo: replyTextView.topAnchor, constant: -ST_DP(50)),
            likeBtn.widthAnchor.constraint(equalToConstant: ST_Scale_DP(48)),
            likeBtn.heightAnchor.constraint(equalToConstant: ST_Scale_DP(48)),

            // LikeNumLb 约束
            likeNumLb.centerXAnchor.constraint(equalTo: likeBtn.centerXAnchor),
            likeNumLb.topAnchor.constraint(equalTo: likeBtn.bottomAnchor, constant: ST_DP(8)), // 24 + 32

            
            /// 底部文本框
            // ReplyTextView 约束
            replyTextView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: ST_DP(16)),
            replyTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -ST_DP(16)),
            replyTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ST_Scale_DP(12)),
            replyTextView.heightAnchor.constraint(equalToConstant: ST_Scale_DP(80)),

            // PlaceHolderLb 约束
            placeHolderLb.leftAnchor.constraint(equalTo: replyTextView.leftAnchor, constant: ST_DP(4)),
            placeHolderLb.topAnchor.constraint(equalTo: replyTextView.topAnchor, constant: ST_DP(7)),
        ])
    }
}


// Action
extension HistoryTabCardView {
    @objc func popAlertView() {
        showAlertViewBlock?()
    }
    
    @objc func addEvent() {
        addEventBlock?()
    }
    
    func loadContentLbText(contenText: String?) {
        if  contenText == nil || contenText?.isEmpty == true  {
            // 当 contentText 是 nil 或空字符串时，隐藏 UILabel
            paraView.isHidden = true
            holderView.isHidden = false
        } else {
            paraView.isHidden = false
            holderView.isHidden = true
            // 当 contentText 不为空时，显示文本
            contentLb.text = contenText
            contentLb.sizeToFit()
        }
    }
    
    func updatePlaceholderVisibility() {
        placeHolderLb.isHidden = !replyTextView.text.isEmpty
    }
    
    @objc func likeBtnAction() {
        isLiked = !isLiked
        if isLiked {
            likeNum = likeNum + 1
            UIView.animate(withDuration: 0.3) { [self] in
                likeBtn.setImage(UIImage(named: "thumb_like"), for: .normal)
                likeBtn.backgroundColor = UIColor(red: 239/255, green: 95/255, blue: 73/255, alpha: 1.0)
                likeNumLb.text = "----- \(likeNum ?? 0)人点赞 -----"
            }
        } else {
            likeNum = likeNum - 1
            UIView.animate(withDuration: 0.3) { [self] in
                likeBtn.setImage(UIImage(named: "thumb_unlike"), for: .normal)
                likeBtn.backgroundColor = UIColor(
                    red: 15*16/255,
                    green: (
                        5*16+15
                    )/255,
                    blue: (
                        4*16+9
                    )/255,
                    alpha: 0.03
                )
                likeBtn.layer.borderColor = CGColor(red: 239/255, green: 95/255, blue: 73/255, alpha: 1.0)
                likeBtn.layer.borderWidth = ST_DP(0.5)
                likeNumLb.text = "----- \(likeNum ?? 0)人点赞 -----"
            }
        }
    }
}

// 代理
extension HistoryTabCardView: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderVisibility()
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        editBeginBlock?()
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        updatePlaceholderVisibility()
    }
}

// 通用
extension HistoryTabCardView {
    public func ST_Scale_DP(_ x: CGFloat) -> CGFloat {
        return (x * SCREEN_WIDTH * (cardScaleFactor ?? 1)) / 375.0
    }
}
