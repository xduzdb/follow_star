//
//  EventListViewController.swift
//  StartTimeLine
//
//  Created by 张家和 on 2024/10/6.
//

import UIKit

class EventListViewController: STBaseViewController {
    var baseTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorHex(hexStr: "F7F6FB")
        setBaseTable()
        setTopBarView()
    }
    
    func setTopBarView() {
        // 整个顶部导航栏
        let topBarView = UIView(
            frame: CGRect(
                x: 0,
                y: ST_DP(47),
                width: view.bounds.width,
                height: ST_DP(46)
            )
        )
        topBarView.backgroundColor = .clear
        
        // 头像部分
        // 背景
        let iconView = UIView(
            frame: CGRect(
                x: ST_DP(38),
                y: ST_DP(5),
                width: ST_DP(96),
                height: ST_DP(36)
            )
        )
        iconView.setCornerRadius(iconView.height/2, masksToBounds: true)
        iconView.backgroundColor = UIColor.white
        
        // 头像
        let avatarBtn = UIButton(frame: CGRect(x: ST_DP(2), y: ST_DP(2), width: ST_DP(32), height: ST_DP(32)))
        avatarBtn.backgroundColor = .blue // change .clear
        avatarBtn.layer.cornerRadius = avatarBtn.width/2
        avatarBtn.layer.masksToBounds = true
        
        // 名称
        let nameLb = UILabel(frame: CGRect(x: ST_DP(42), y: ST_DP(10), width: ST_DP(0), height: ST_DP(20)))
        nameLb.text = "神秘宝贝6547" // change 网络拿
        nameLb.textColor = .black
        nameLb.font = .boldSystemFont(ofSize: ST_DP(14))
        nameLb.numberOfLines = 1
        nameLb.lineBreakMode = .byTruncatingTail
        nameLb.sizeToFit()
        // change
        let maxWidth = 100.0 - 42.0 // 减去头像按钮之后的剩余宽度
        if nameLb.bounds.width > maxWidth {
            nameLb.frame.size.width = CGFloat(maxWidth)
        }
        
        view.addSubview(topBarView)
        topBarView.addSubview(iconView)
        iconView.addSubview(avatarBtn)
        iconView.addSubview(nameLb)
        
        // 兜底按钮
        let holderBtn = UIButton(
            frame: CGRect(
                x: ST_DP(260),
                y: ST_DP(5),
                width: ST_DP(99),
                height: ST_DP(36)
            )
        )
        holderBtn.setImage(UIImage(named: "plus_btn"), for: .normal)
        holderBtn.setTitle("添加事件", for: .normal)
        holderBtn.setTitleColor(.black, for: .normal)
        holderBtn.titleLabel?.font = .boldSystemFont(ofSize: ST_DP(14))
        holderBtn.imageEdgeInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: ST_DP(4)
        )
        holderBtn.backgroundColor = .white
        holderBtn.setCornerRadius(ST_DP(18), masksToBounds: true)
        topBarView.addSubview(holderBtn)
    }
    
    func setBaseTable() {
        baseTable = UITableView(
            frame: view.bounds,
            style: .grouped
        )
        baseTable.frame = self.view.bounds
//        baseTable.frame.origin.y = ST_DP(58+44)
        baseTable.delegate = self
        baseTable.dataSource = self
        baseTable.separatorStyle = .none
        baseTable.register(AllEventsTVCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(baseTable)
    }
    
    func setHeaderView(year: Int, cellNum: Int) -> UIView {
        if cellNum == 0 {
            let holderView = UIView()
            holderView.isHidden = true
            return holderView
        }
        let bgView = UIView(
            frame: CGRect(
                x: 0,
                y: ST_DP(58+44),
                width: view.width,
                height: ST_DP(40)
            )
        )
        
        let yearLb = UIButton(
            frame: CGRect(
                x: -ST_DP(20),
                y: 0,
                width: ST_DP(108),
                height: ST_DP(40)
            )
        )
        yearLb.isEnabled = false
        yearLb.setTitleColor(.white, for: .normal)
        yearLb.titleLabel?.font = .systemFont(ofSize: ST_DP(14))
        yearLb.setTitle("\(year)年", for: .normal)
        yearLb.setCornerRadius(ST_DP(20), masksToBounds: true)
        yearLb.backgroundColor = ColorHex(hexStr: "EF5F49")
        // 设置标题的边缘插入
        yearLb.titleEdgeInsets = UIEdgeInsets(top: 0, left: ST_DP(20), bottom: 0, right: 0)
        bgView.addSubview(yearLb)
        
        let numLb = UILabel(
            frame: CGRect(
                x: ST_DP(314),
                y: ST_DP(10),
                width: ST_DP(45),
                height: ST_DP(20)
            )
        )
        numLb.text = "共\(cellNum)个"
        numLb.textColor = ColorHex(hexStr: "C9CDD4")
        numLb.font = .systemFont(ofSize: ST_DP(14))
        numLb.textAlignment = .right
        bgView.addSubview(numLb)
        return bgView
    }
}

extension EventListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ST_DP(130)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EventListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 3 } // 2024年的事件数量
            else { return 5 } // 2023年的事件数量
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllEventsTVCell
        cell.dateStr = "2.21"
        cell.nameStr = "天白白"
        cell.noteStr = "参与的《青春环游记》第一季第2期参与的《青春环游记》第一季第2期"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
            case 0:
                return setHeaderView(year: 2024, cellNum: 3)
            case 1:
                return setHeaderView(year: 2023, cellNum: 3)
            default:
                return setHeaderView(year: 2022, cellNum: 0)
            }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ST_DP(56)
    }
}
