//
//  YBWaterFallFlowLayout.swift
//  BestBuy-ios
//
//  Created by ZHOUYUBIN on 2020/9/28.
//  Copyright © 2020 ZHOUYUBIN. All rights reserved.
//

import UIKit

/// 瀑布流代理
@objc protocol YBWaterfallLayoutDataSource : class {
    
    /// 设置item 高度
    /// - Parameters:
    ///   - layout: 布局
    ///   - indexPath: 位置
    /// - Returns: item 的高度
    func waterfallLayoutItemHeight(_ layout : YBWaterFallFlowLayout, indexPath : IndexPath) -> CGFloat
    
    /// 瀑布流一共有多少列，默认时2列
    /// - Parameter layout: 布局
    /// - Returns: 列数
    @objc optional func numberOfColsInWaterfallLayout(_ layout : YBWaterFallFlowLayout) -> Int
    
    /// 最小两行之间的间距
    @objc optional func waterfallLayoutMinimumLineSpacing(_ layout : YBWaterFallFlowLayout) -> CGFloat
    /// 同一行相邻两个cell的最小间距
    @objc optional func waterfallLayoutMinimumInteritemSpacing(_ layout : YBWaterFallFlowLayout) -> CGFloat
    // item  边距
    @objc optional func waterfallLayoutEdgeInset(_ layout : YBWaterFallFlowLayout) -> UIEdgeInsets

    @objc optional func waterfallLayoutSizeForHeader(_ layout : YBWaterFallFlowLayout,referenceSizeForHeaderInSection section: Int) -> CGSize
    
    @objc optional func waterfallLayoutSizeForFooter(_ layout : YBWaterFallFlowLayout,referenceSizeForFooterInSection section: Int) -> CGSize
}
class YBWaterFallFlowLayout: UICollectionViewFlowLayout {
    // MARK: 对外提供属性
    // 瀑布流数据源代理
    weak var dataSource : YBWaterfallLayoutDataSource?
    // MARK: 私有属性
    // 布局属性数组
    private lazy var attrsArray : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    // 最高的高度
    private var maxH : CGFloat = 0
    
    //索引
    private var startIndex = 0
}
extension YBWaterFallFlowLayout {
    override func prepare() {
        super.prepare()
        //获取item的个数
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        
        //获取列数
        let cols = dataSource?.numberOfColsInWaterfallLayout?(self) ?? 2
        // 获取同一行最小行间距
        var waterfallLayoutMinimumInteritemSpacing: CGFloat = dataSource?.waterfallLayoutMinimumInteritemSpacing?(self) ?? 0.0
        // 获取最小间距
        var waterfallLayoutMinimumLineSpacing: CGFloat = dataSource?.waterfallLayoutMinimumLineSpacing?(self) ?? 0.0
        if waterfallLayoutMinimumInteritemSpacing <= 0.0{
            waterfallLayoutMinimumInteritemSpacing = self.minimumInteritemSpacing
        }
        if waterfallLayoutMinimumLineSpacing <= 0.0{
            waterfallLayoutMinimumLineSpacing = self.minimumLineSpacing
        }
        // item 边距
        var waterfallLayoutEdgeInset = dataSource?.waterfallLayoutEdgeInset?(self)
        if waterfallLayoutEdgeInset == nil{
            waterfallLayoutEdgeInset = self.sectionInset
        }
     
        let topSpace: CGFloat = waterfallLayoutEdgeInset?.top ?? 0.0
        let leftSpace: CGFloat = waterfallLayoutEdgeInset?.left ?? 0.0
        let rightSpace:CGFloat = waterfallLayoutEdgeInset?.right ?? 0.0
        //每一列的高度累计
        var colHeights = Array(repeating: topSpace, count: cols)
        
        let headerSize = dataSource?.waterfallLayoutSizeForHeader?(self, referenceSizeForHeaderInSection: 0)
        let footerSize = dataSource?.waterfallLayoutSizeForFooter?(self, referenceSizeForFooterInSection: 0)
        self.headerReferenceSize = headerSize ?? CGSize.zero
        self.footerReferenceSize = footerSize ?? CGSize.zero
        // 暂时只做一个 header  处理  （因为项目中目前最多就一个header）
        let headAttrs = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader , with: IndexPath.init(index: 0))
        headAttrs.frame = CGRect.init(x: 0, y: 0, width: self.headerReferenceSize.width, height: self.headerReferenceSize.height)
        
        //计算Item的宽度（屏幕宽度铺满）
        let itemW = (collectionView!.bounds.width - leftSpace - rightSpace - waterfallLayoutMinimumInteritemSpacing * CGFloat(cols - 1)) / CGFloat(cols)
        attrsArray = Array.init()
        attrsArray.append(headAttrs)
        //计算所有的item的属性
        for i in 0..<itemCount {
            // 设置每一个Item位置相关的属性
            let indexPath = IndexPath(item: i, section: 0)
            
            // 根据位置创建Attributes属性
            let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            // 获取CELL的高度
            guard let height = dataSource?.waterfallLayoutItemHeight(self, indexPath: indexPath) else {
                fatalError("请设置数据源,并且实现对应的数据源方法")
            }
            //取出当前列所属的列索引
            let index = i % cols
            
            //获取当前列的总高度
            var colH = colHeights[index]
            
            //将当前列的高度在加载当前ITEM的高度
            colH = colH + height + waterfallLayoutMinimumLineSpacing
            
            //重新设置当前列的高度
            colHeights[i % cols] = colH
            
            // 5.设置item的属性
            attrs.frame = CGRect(x: leftSpace + (waterfallLayoutMinimumInteritemSpacing + itemW) * CGFloat(index), y: headerReferenceSize.height + colH - height - waterfallLayoutMinimumLineSpacing, width: itemW, height: height)
            attrsArray.append(attrs)
        }
        
        // 4.记录最大值
        maxH = colHeights.max()!
        
        // 5.给startIndex重新复制
        startIndex = itemCount
    }
}

extension YBWaterFallFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: maxH + sectionInset.bottom - minimumLineSpacing + headerReferenceSize.height)
    }
}

