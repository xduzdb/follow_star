//
//  BaseVC.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/4.
//

import UIKit
import ObjectMapper

class BaseVC: UIViewController, UIGestureRecognizerDelegate {
    /** -------------------- 侧滑返回 2020年07月07日   ------------------------------**/
    /// 是否需要侧滑滑返回  默认允许侧滑返回
    var isNeedSideSlipBack: Bool = true
    private var isExchangeActivityStatus: Bool = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        // 开启右滑返回
        if isNeedSideSlipBack {
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIWindow.current?.endEditing(true)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if isNeedSideSlipBack {
            if let number = navigationController?.viewControllers.count, number > 1 {
                return true
            }
        }
        return false
    }

    /** -------------------- 侧滑返回   ------------------------------**/
    override func viewDidLoad() {
        super.viewDidLoad()


        // MARK: - - 用于页面 默认刷新时候是否展示 空态页面  用于（extension UIViewController: EmptyDataSetSource, EmptyDataSetDelegate ）
        view.backgroundColor = UIColor.white
        ydAddObserve(taget: self, selector: #selector(loginOrloginOutSuccess(_:)), name: "LoginOrLoginOut")
        NotificationCenter.default.addObserver(self, selector: #selector(appEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appEnterForeground), name:UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc func appEnterForeground() {
        
    }

    @objc func appEnterBackground() {
//        DDLOG(message: "进入后台")
        isExchangeActivityStatus = true
    }

    @objc func loginOrloginOutSuccess(_ noti: NSNotification) {
        
    }

    lazy var baseTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorColor = UIColor.clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()

    lazy var baseCollectionView: UICollectionView = {
        let layout = YBWaterFallFlowLayout()
        layout.dataSource = self
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension BaseVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    }
    
    
}
extension BaseVC:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell.init()
    }
   
}
extension BaseVC:YBWaterfallLayoutDataSource{
    func waterfallLayoutItemHeight(_ layout: YBWaterFallFlowLayout, indexPath: IndexPath) -> CGFloat {
        return 0
    }
    func numberOfColsInWaterfallLayout(_ layout: YBWaterFallFlowLayout) -> Int {
        return 2
    }
    func waterfallLayoutMinimumLineSpacing(_ layout: YBWaterFallFlowLayout) -> CGFloat {
        return 10.0
    }
    func waterfallLayoutMinimumInteritemSpacing(_ layout: YBWaterFallFlowLayout) -> CGFloat {
        return 10.0
    }
    func waterfallLayoutEdgeInset(_ layout: YBWaterFallFlowLayout) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
    }
}
