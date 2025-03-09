import SwiftUI
import UIKit
import LunarSwift

// 创建一个封装了 HistoryTabView 的 UIViewController
class HistoryTabViewController: UIViewController {
    
    var cardViews: [HistoryTabCardView] = []
    var historyTabView: HistoryTabView!
    var currentDateString: String!
    var curDate: Date!
    var endEditUIControl: UIControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHistoryTabView()
        setAvatarBtn()
        setUserInfo()
        addInitialCards()
        setCalendarViewGes()
        
        endEditUIControl = UIControl()
        self.view.addSubview(endEditUIControl)
        endEditUIControl.frame = self.view.bounds
        endEditUIControl.backgroundColor = .clear
        endEditUIControl.isHidden = true
        // 添加手势识别器，监听点击事件
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        endEditUIControl.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        // 隐藏所有活跃的输入法
        view.endEditing(true)
        endEditUIControl.isHidden = true
        self.view.frame.origin.y += ST_DP(200)
    }
    
    // 设置滑动手势
    func setCalendarViewGes() {
        let leftGes = UISwipeGestureRecognizer(target: self, action: #selector(changeDate))
        leftGes.direction = .left
        historyTabView.calendarView.addGestureRecognizer(leftGes)
        
        let rightGes = UISwipeGestureRecognizer(target: self, action: #selector(changeDate))
        rightGes.direction = .right
        historyTabView.calendarView.addGestureRecognizer(rightGes)
    }
    
    // 设置大事记卡片
    func setHistoryTabView() {
        // 初始化 HistoryTabView
        historyTabView = HistoryTabView(frame: view.bounds)
        // 设置 HistoryTabView 的布局
        historyTabView.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight
        ]
        view.addSubview(historyTabView)
        // 今天日期
        curDate = Date()
        setDate(date: curDate)
    }
    
    func setAvatarBtn() {
        historyTabView.avatarBtn.addTarget(self, action: #selector(jumpToEventList), for: .touchUpInside)
    }
    
    @objc public func jumpToEventList() {
        let eventListVC = EventListViewController()
        navigationController?.pushViewController(eventListVC, animated: true)
        NSLog("Button Clicked")
    }
    
    func addInitialCards() {
        getEventListRequest { [weak self] listData, error in
//            let text = listData?.text ?? ""
//            let likeCount = listData?.likeCount ?? 0
//            let isLike = listData?.isLike ?? true
            // 创建四个card，第四张和第三张完全重合
            for i in 0..<4 {
                var content: String
                switch i {
                case 0:
                    content = "激发了大家是否绝世独立放假啊啊减肥路上的减肥路上的肌肤拉萨的减肥了"
                case 1:
                    content = "激发了大家是"
                default:
                    content = "激发了大家是激发了大家是激发了大家是"
                }
                self?.addCardView(content: content)
            }
        }
    }
    
    func setUserInfo() {
        let userInfo = UserSharedManger.shared.getCurrentUserInfo()
        let avatarUrl = URL(string: userInfo?.avatar ?? "")!
        let nickname = userInfo?.nickname ?? "default" // change
        // 设置头像
        URLSession.shared.dataTask(with: avatarUrl) { [weak self] data, resp, error in
            guard let data = data, error == nil else {
                return
            }
            let image = UIImage(data: data)
            self?.historyTabView.avatarBtn.setImage(image, for: .normal)
        }
        // 设置昵称
        historyTabView.nameLb.text = nickname
    }
    
    func getEventListRequest(completion: @escaping (EventListData?, String?) -> Void) {
        // 重新设置时间格式
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "Asia/Shanghai")

        let dateForReq = dateFormatter.string(from: curDate)
        let params = [
            "date": dateForReq,
            "sid": "66e165a00002911ccdfc",
            "type": "current_day"
        ] as [String: Any]

        // 发送网络请求并处理响应
        NetWorkManager.ydNetWorkRequest(.eventList(params)) { resp in
            if resp.status == .success, let data = resp.data, let model = EventListData(JSON: data) {
                // 请求成功，通过completion传递数据
                completion(model, nil)
            } else {
                // 请求失败，通过completion传递错误消息
                completion(nil, resp.msg)
            }
        }
    }
}

// Action
extension HistoryTabViewController {
    // 滑动手势
    @objc public func changeDate(ges: UISwipeGestureRecognizer) {
        if ges.state == .ended {
            switch ges.direction {
            case .left:
                curDate = Calendar.current.date(
                    byAdding: .day,
                    value: 1,
                    to:curDate
                )
                setDate(date: curDate!)
            case .right:
                curDate = Calendar.current.date(
                    byAdding: .day,
                    value: -1,
                    to:curDate
                )
                setDate(date: curDate!)
            default:
                break
            }
        }
    }
    // 设置日期
    func setDate(date: Date) {
        // 设置日期格式化器
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "Asia/Shanghai")
        
        currentDateString = dateFormatter.string(from: date)
        historyTabView.dateSolarLb.text = currentDateString
        // 使用 LunarSwift 获取阴历日期
        let lunar = Lunar.fromDate(date: date)
        let lunarMonth = lunar.monthInChinese
        let lunarDay = lunar.dayInChinese
        historyTabView.dateLunarLb.text = "农历" + lunarMonth + "月" + lunarDay
        
        for card in cardViews {
            card.dateLb.text = currentDateString
        }
    }
    
    // 添加卡片-遍历每个卡片
    func addCardView(content: String) {
        // 创建新卡片并设置其属性
        let newCard = HistoryTabCardView(frame: calculateFrameForNewCard())
        newCard.centerX = view.centerX
        newCard.dateLb.text = currentDateString
        newCard.loadContentLbText(contenText: content)
        newCard.addEventBlock = { [weak self] in
            guard let self = self else { return }
            handleButtonTap()
        }
        
        newCard.showAlertViewBlock = { [weak self] in
            guard let self = self else { return }
            
            // 创建自定义 AlertView
            let alertView = STAlertView(title: "纠错", leftBtn: "取消", rightBtn: "提交", leftAction: nil, rightAction: nil)
            
            // 获取应用程序的关键窗口
            if let keyWindow = UIApplication.shared.keyWindow {
                // 将 alertView 添加到关键窗口上
                keyWindow.addSubview(alertView)
                // 确保 alertView 在窗口层级结构的顶部
                alertView.bringSubviewToFront(keyWindow)
                // 展示 alertView
                alertView.showAlert(on: keyWindow)
            }
        }
        
        // 添加手势识别器
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        newCard.addGestureRecognizer(panGes)
        
        // 将新卡片添加到视图层次结构和卡片数组中
        if let lastCardView = cardViews.last {
            historyTabView.insertSubview(newCard, belowSubview: lastCardView)
            cardViews.append(newCard)
        } else {
            historyTabView.addSubview(newCard)
            cardViews.append(newCard)
        }
        // 开始编辑
        newCard.editBeginBlock = { [weak self] in
            self?.endEditUIControl.isHidden = false
            self?.view.frame.origin.y -= ST_DP(200)
        }
    }
    
    // 计算卡片尺寸
    func calculateFrameForNewCard() -> CGRect {
        let count = cardViews.count
        // 根据已有卡片的数量计算新卡片的位置和大小
        if let lastCard = cardViews.last {
            var newFrame = lastCard.frame
            // 如果是最新的第四张，重叠
            if count >= 3 {
                return newFrame
            }
            newFrame.size.width *= 0.9
            newFrame.origin.y += ST_DP(16)
            return newFrame
        } else {
            return CGRect(
                x: ST_DP(16),
                y: ST_DP(184),
                width: ST_DP(343),
                height: ST_DP(445)
            ) // 初始位置
        }
    }
    
    // 拖拽卡片动作
    @objc func handleSwipeGesture(gesture: UIPanGestureRecognizer) {
        guard let card = gesture.view as? HistoryTabCardView
        else { return }
        
        let card1 = cardViews[1]
        let card2 = cardViews[2]
        
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            card.center = CGPoint(
                x: card.center.x + translation.x,
                y: card.center.y + translation.y
            )
        case .ended:
            UIView.animate(withDuration: 0.1) {
                card.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                card2.frame = card1.frame
                card1.frame = CGRect(
                    x: ST_DP(16),
                    y: ST_DP(184),
                    width: ST_DP(343),
                    height: ST_DP(445)
                )
                
            }
            createLastNewCard()
            cardViews.remove(at: 0)
        default:
            break
        }
        gesture.setTranslation(.zero, in: view)
    }
    
    // 更新最后一张卡片
    func createLastNewCard() {
        addCardView(content: "")
    }
    
    // 添加事件
    @objc func handleButtonTap() {
        let newViewController = CustomWebViewController(
            url: URL(string: "https://www.baidu.com")!
        )
        newViewController.view.backgroundColor = .white
        newViewController.title = "New Screen"
        
        // 通过导航控制器推送视图控制器
        navigationController?.pushViewController(newViewController,animated: true)
    }
}

// 创建 UIViewControllerRepresentable 结构体
struct HistoryTVWrapper: UIViewControllerRepresentable {
    
    func makeUIViewController(
        context: Context
    ) -> HistoryTabViewController {
        return HistoryTabViewController()
    }
    
    func updateUIViewController(
        _ uiViewController: HistoryTabViewController,
        context: Context
    ) {
        // 更新视图控制器的属性或处理逻辑
    }
}
