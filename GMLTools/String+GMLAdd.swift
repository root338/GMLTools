//
//  String+GMLAdd.swift
//  MLAddressBook
//
//  Created by apple on 2018/10/24.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation


// MARK: - String Transform
extension String {
    
    /// 字符串转换失败
    ///
    /// - isEmpty: 字符串为空
    /// - countOutOfRange: 转换超出范围
    /// - transformError: 执行过程中转换失败
    enum MLStringTransformError: Error {
        case isEmpty
        case countOutOfRange
        case transformError
    }
    
    /// 字符串转拼音
    ///
    /// - Parameter isStripCombiningMarks: 是否去除重音
    /// - Returns: 返回一个字符串
    /// - Throws: MLStringTransformError 类型错误
    func gml_transformToPinyin(isStripCombiningMarks: Bool = true) throws -> String {
        
        let resultValue = try gml_transform()
        if isStripCombiningMarks {
            guard self != resultValue else {
                return resultValue
            }
            return try resultValue.gml_transform(kCFStringTransformStripCombiningMarks as String)
        }else {
            return resultValue
        }
    }
    
    func gml_transform(_ transform: String = kCFStringTransformToLatin as String) throws -> String  {
        return try gml_transform(range: CFRangeMake(0, self.count), transform: transform, reverse: false)
    }
    
    /// 转换指定区域内的字符串
    ///
    /// - Parameters:
    ///   - range: 转换的区域
    ///   - transform: 转换类
    ///   - reverse: 是否返回反转的结果
    /// - Returns: 返回转换
    /// - Throws: MLStringTransformError 类型错误
    func gml_transform(range: CFRange, transform: String = kCFStringTransformToLatin as String, reverse: Bool = false) throws -> String {
        guard !self.isEmpty else {
            throw MLStringTransformError.isEmpty
        }
        
        guard range.length >= 0, range.location >= 0, range.location + range.length <= self.count else {
            throw MLStringTransformError.countOutOfRange
        }
        let str : CFMutableString = NSMutableString(string: self) as CFMutableString
        var tmpRange = range
        let resultValue = CFStringTransform(str, &tmpRange, transform as CFString, reverse)
        guard resultValue else {
            throw MLStringTransformError.transformError
        }
        return str as String
    }
}
