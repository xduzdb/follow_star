//
//  HistoryTabView.swift
//  StartTimeLine
//
//  Created by zhangjiahe17 on 2024/9/9.
//

import Foundation
import UIKit

public class HistoryTabView: UIView {
    // 背景图
    var bgView: UIView!
    // 阳历
    var dateSolarLb: UILabel!
    // 阴历
    var dateLunarLb: UILabel!
    // 日期
    var calendarView: UIView!
    // 头像
    var avatarBtn: UIButton!
    // 昵称
    var nameLb: UILabel!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setBgView()
        // 顶部状态栏
        setTopBarView()
        setCalendarView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBgView() {
        bgView = UIImageView(image: UIImage(named: "hot")) // change 网络加载
        bgView.frame = CGRect(x: 0, y: 0, width: ST_DP(375), height: ST_DP(815))
        bgView.backgroundColor = .clear
        addSubview(bgView)
    }
    
    func setTopBarView() {
        // 整个顶部导航栏
        let topBarView = UIView(frame: CGRect(x: 0, y: ST_DP(44), width: bounds.width, height: ST_DP(44)))
        topBarView.backgroundColor = .clear
        addSubview(topBarView)
        
        // 头像部分
        // 背景
        let iconView = UIView(frame: CGRect(x: ST_DP(16), y: ST_DP(4), width: ST_DP(96), height: ST_DP(36)))
        iconView.setCornerRadius(iconView.height/2, masksToBounds: true)
        iconView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        // 头像
        avatarBtn = UIButton(frame: CGRect(x: ST_DP(2), y: ST_DP(2), width: ST_DP(32), height: ST_DP(32)))
        avatarBtn.backgroundColor = .blue // change .clear
        avatarBtn.layer.cornerRadius = avatarBtn.width/2
        avatarBtn.layer.masksToBounds = true
        
        // 名称
        nameLb = UILabel(frame: CGRect(x: ST_DP(42), y: ST_DP(10), width: ST_DP(0), height: ST_DP(20)))
        nameLb.text = "哈哈哈" // change 网络拿
        nameLb.textColor = .white
        nameLb.font = .boldSystemFont(ofSize: ST_DP(14))
        nameLb.numberOfLines = 1
        nameLb.lineBreakMode = .byTruncatingTail
        nameLb.sizeToFit()
        // change
        let maxWidth = 120.0 - 42.0 // 减去头像按钮之后的剩余宽度
        if nameLb.bounds.width > maxWidth {
            nameLb.frame.size.width = CGFloat(maxWidth)
        }
        
        topBarView.addSubview(iconView)
        iconView.addSubview(avatarBtn)
        iconView.addSubview(nameLb)
        
        // 分享部分
        let launchBtn = UIButton(frame: CGRect(x: ST_DP(239), y: ST_DP(12), width: ST_DP(20), height: ST_DP(20)))
        launchBtn.setImage(UIImage(named: "launch"), for: .normal)

        let shareBgView = UIView(frame: .zero)
        shareBgView.bounds.size = CGSize(width: ST_DP(36), height: ST_DP(36))
        shareBgView.center = CGPoint(x: launchBtn.center.x, y: launchBtn.center.y)
        shareBgView.layer.cornerRadius = shareBgView.height/2
        shareBgView.layer.masksToBounds = true
        shareBgView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        topBarView.addSubview(shareBgView)
        topBarView.addSubview(launchBtn)
        
        // 颜料桶部分
        let editBgBtn = UIButton(frame: CGRect(x: ST_DP(287), y: ST_DP(12), width: ST_DP(20), height: ST_DP(20)))
        editBgBtn.setImage(UIImage(named: "edit_bg_colors"), for: .normal)

        let editBgView = UIView(frame: .zero)
        editBgView.bounds.size = CGSize(width: ST_DP(36), height: ST_DP(36))
        editBgView.center = CGPoint(x: editBgBtn.center.x, y: editBgBtn.center.y)
        editBgView.layer.cornerRadius = shareBgView.height/2
        editBgView.layer.masksToBounds = true
        editBgView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        topBarView.addSubview(editBgView)
        topBarView.addSubview(editBgBtn)
        
        // 帮助
        let helpBtn = UIButton(frame: CGRect(x: ST_DP(335), y: ST_DP(12), width: ST_DP(20), height: ST_DP(20)))
        helpBtn.setImage(UIImage(named: "edit_bg_colors"), for: .normal)

        let helpBgView = UIView(frame: .zero)
        helpBgView.bounds.size = CGSize(width: ST_DP(36), height: ST_DP(36))
        helpBgView.center = CGPoint(x: helpBtn.center.x, y: helpBtn.center.y)
        helpBgView.layer.cornerRadius = shareBgView.height/2
        helpBgView.layer.masksToBounds = true
        helpBgView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        topBarView.addSubview(helpBgView)
        topBarView.addSubview(helpBtn)
    }
    
    func setCalendarView() {
        calendarView = UIView()
        // 阳历
        dateSolarLb = UILabel()
        // 阴历
        dateLunarLb = UILabel()
        dateSolarLb.text = "2024年7月31日"
        dateSolarLb.font = .systemFont(ofSize: 24)
        dateSolarLb.textColor = .white
        
        dateLunarLb.text = "农历六月二十六"
        dateLunarLb.font = .systemFont(ofSize: 14)
        dateLunarLb.textColor = .white
        dateSolarLb.sizeToFit()
        dateLunarLb.sizeToFit()
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        dateSolarLb.translatesAutoresizingMaskIntoConstraints = false
        dateLunarLb.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(calendarView)
        calendarView.addSubview(dateSolarLb)
        calendarView.addSubview(dateLunarLb)
        
        NSLayoutConstraint.activate([
            calendarView.widthAnchor.constraint(equalToConstant: self.width),
            calendarView.heightAnchor.constraint(equalToConstant: ST_DP(58)),
            calendarView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            calendarView.topAnchor.constraint(equalTo: self.topAnchor, constant: ST_DP(107)),
            
            dateSolarLb.heightAnchor.constraint(equalToConstant: ST_DP(34)),
            dateSolarLb.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dateSolarLb.topAnchor.constraint(equalTo: calendarView.topAnchor),
            
            dateLunarLb.heightAnchor.constraint(equalToConstant: ST_DP(20)),
            dateLunarLb.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dateLunarLb.topAnchor.constraint(equalTo: dateSolarLb.bottomAnchor, constant: ST_DP(4))
        ])
    }
}
