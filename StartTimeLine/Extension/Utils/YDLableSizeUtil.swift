//
//  YDLableSizeUtil.swift
//  StartTimeLine
//
//  Created by lushitong on 2024/9/16.
//
import UIKit

/// 此类作用：获取文本（包括富文本）的高度或者宽度
///
///
class YDLableSizeUtil: NSObject {
    
    /// 固定宽度获取字符串所占高度（不含富文本属性）
    /// - Parameters:
    ///   - str: 参与计算高度的字符串
    ///   - w: 固定的宽度
    ///   - font: 字体大小
    /// - Returns: 文本高度
    static func getNormalStrHeight(str: String, w: CGFloat ,font:UIFont) -> CGFloat{
        let h = getStrSize(str: str, w: w, h: CGFloat(MAXFLOAT), attributes: [NSAttributedString.Key.font: font]).height
        return CGFloat(ceilf(Float(h)))
    }
    /// 固定高度计算字符串所占宽度（不含富文本属性）
    /// - Parameters:
    ///   - str: 参与计算的字符串
    ///   - h: 固定的高度
    ///   - font: 字体
    /// - Returns: 文本的宽度
    static func getNormalStrWidth(str: String, h: CGFloat,font: UIFont) -> CGFloat{
        let w = getStrSize(str: str, w: CGFloat(MAXFLOAT), h: h, attributes: [NSAttributedString.Key.font: font]).width
        return CGFloat(floor(Float(w)))
    }
    /// 给定宽度获取富文本的高度
    /// - Parameters:
    ///   - attributStr: 富文本字符串
    ///   - w: 固定宽度
    /// - Returns: 高度
    static func getAttributeStrHeight(attributStr: NSMutableAttributedString,w: CGFloat) -> CGFloat{
        let h = getStrSize( attributStr: attributStr, w: w, h: CGFloat(MAXFLOAT)).height
        return CGFloat(ceilf(Float(h)))
    }
    /// 给定高度的获取富文本的宽度
    /// - Parameters:
    ///   - attributStr:  富文本字符串
    ///   - h: 固定的高度
    /// - Returns: 文本宽度
    static func getAttributeStrWidth(attributStr: NSMutableAttributedString,h: CGFloat) -> CGFloat{
        let w = getStrSize( attributStr: attributStr, w: CGFloat(MAXFLOAT), h: h).width
        return CGFloat(floor(Float(w)))
    }
    /// 获取字符串的Size
    /// - Parameters:
    ///   - str: 参与计算的字符串
    ///   - w: width
    ///   - h: height
    ///   - attributes: attributes
    /// - Returns: size
    private static func getStrSize(str: String? = nil,attributStr: NSMutableAttributedString? = nil, w:CGFloat,h: CGFloat,attributes:[NSAttributedString.Key : Any]? = nil) -> CGSize{
        if str != nil {
            return ((str ?? "") as NSString).boundingRect(with: CGSize.init(width: w, height: h), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: attributes, context: nil).size
        }
        if attributStr != nil{
            return attributStr?.boundingRect(with: CGSize.init(width: w, height: h), options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil).size ?? CGSize.zero
        }
        return CGSize.zero
        
    }
    /// 快速获取一些基本的富文本属性
    /// - Parameters:
    ///   - font: 字体大小
    ///   - lineSpacing: 行间距
    ///   - kern: 字符间距
    /// - Returns: Attributes
    static func getAttributes(font:UIFont, lineSpacing:CGFloat? = nil, kern:CGFloat? = nil) -> [NSAttributedString.Key : Any]{
        let atts = NSMutableDictionary.init()
        atts[NSAttributedString.Key.font] = font
        if lineSpacing != nil{
            let paragraphStyle = NSMutableParagraphStyle.init()
            paragraphStyle.lineSpacing = lineSpacing ?? 0
            atts[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        }
        if kern != nil{
            atts[NSAttributedString.Key.kern] = kern
        }
        return atts as! [NSAttributedString.Key : Any]
    }
    /// 根据Font 函数 获取最大行高
    /// - Parameters:
    ///   - font: UIfont
    ///   - line: 行数
    ///   - lineSpace: 行间距
    /// - Returns: 最大行高
    static func getStrMaxHeightWithLine(font: UIFont, line: Int,lineSpace: CGFloat) ->CGFloat{
        return  CGFloat((ceilf(Float(font.pointSize + lineSpace))) * Float(line))
    }
}
