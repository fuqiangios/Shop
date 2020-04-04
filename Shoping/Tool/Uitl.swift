//
//  Uitl.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/22.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class Uitl: NSObject {
    class func findFirstLetterFromString(aString: String) -> String {
        //多音字处理，根据需要添自行加
        func polyphoneStringHandle(nameString: String, pinyinString: String) -> String {
            if nameString.hasPrefix("长") {return "chang"}
            if nameString.hasPrefix("沈") {return "shen"}
            if nameString.hasPrefix("厦") {return "xia"}
            if nameString.hasPrefix("地") {return "di"}
            if nameString.hasPrefix("重") {return "chong"}
            return pinyinString
        }
        
        //转变成可变字符串
        let mutableString = NSMutableString.init(string: aString)

        //将中文转换成带声调的拼音
        CFStringTransform(mutableString as CFMutableString, nil,      kCFStringTransformToLatin, false)

        //去掉声调
        let pinyinString = mutableString.folding(options:          String.CompareOptions.diacriticInsensitive, locale:   NSLocale.current)

        //将拼音首字母换成大写
        let strPinYin = polyphoneStringHandle(nameString: aString,    pinyinString: pinyinString).uppercased()

        //截取大写首字母
        let firstString = strPinYin.substring(to:     strPinYin.index(strPinYin.startIndex, offsetBy: 1))

        //判断首字母是否为大写
        let regexA = "^[A-Z]$"
        let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
        return predA.evaluate(with: firstString) ? firstString : "#"
    }
}
