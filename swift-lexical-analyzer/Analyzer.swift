//
//  Analyzer.swift
//  swift-lexical-analyzer
//
//  Created by 戚译中 on 2019/3/21.
//  Copyright © 2019 戚译中. All rights reserved.
//

import Foundation

class Analyzer {
    
    private let symbols: [String: Int] = ["main": 3, "int": 3, "if": 3, "else": 3, "while": 3, "do": 3, "return": 3 , "<": 4, ">": 4, "!=": 4, ">=": 4, "<=": 4, "==": 4, "+": 4, "+=": 4, "-": 4, "*": 4, "/": 4, "=": 4, ",": 5, ";": 5, "(": 5, ")": 5, "{": 5, "}": 5]
    
    private var code: String = ""
    
    private var list: [(Int, String)] = []
    
    private var wordInfo: [String: Int] = [:]
    
    private var wordAddress: Int = 0
    
    public func analyze() {
        let codeLineArray = code.split(separator: "\n")
        var index = 0
        for line in codeLineArray {
            lineAnalyze(String(line), index)
            index += 1
        }
        for t in list {
            print(t)
        }
    }
    
    private func lineAnalyze(_ line: String, _ index: Int) {
        var tempLine = line
        var columnIndex = 0
        while tempLine.count > 0 {
            if let tuple = isSymbol(&tempLine) {
                columnIndex += tuple.1.count
                list.append(tuple)
            } else if let tuple = isLetter(&tempLine) {
                columnIndex += tuple.1.count
                list.append(tuple)
            } else if let tuple = isNumber(&tempLine) {
                columnIndex += tuple.1.count
                list.append(tuple)
            } else {
                if tempLine.first != " " {
                    print("解析错误: 在第\(index + 1)行,第\(columnIndex + 1)列")
                }
                tempLine.remove(at: .init(encodedOffset: 0))
                columnIndex += 1
            }
        }
    }
    
    private func symbolCode(_ key: String) -> Int? {
        return symbols[key]
    }
    
    private func isSymbol(_ str: inout String) -> (Int, String)? {
        var key = ""
        var canReturn = false
        var useKey = ""
        for c in str {
            key.append(c)
            if symbolCode(key) != nil {
                canReturn = true
                useKey = key
            }
        }
        if canReturn {
            let range = useKey.endIndex..<str.endIndex
            str = String(str[range])
            return (symbols[useKey]!, useKey)
        }
        return nil
    }
    
    private func isLetter(_ str: inout String) -> (Int, String)? {
        var key = ""
        var canReturn = false
        for c in str {
            if (c >= "a" && c <= "z") || (c >= "A" && c <= "Z") {
                canReturn = true
                key.append(c)
            } else {
                if canReturn {
                    if c >= "0" && c <= "9" {
                        key.append(c)
                    }
                }
                break
            }
        }
        if key.count > 0 {
//            1. 从str中去除已经别解析为单词的字符串
            let range = key.endIndex..<str.endIndex
            str = String(str[range])
//            2. 尝试从Info中去除已经被解析的letter
            let address = wordInfo[key]
            if address != nil {
//                3. 取到已经解析过得字符直接返回地址
                return (1, String(address!))
            } else {
//                4. 未取到则生成新的地址
                let tuple = (1, String(wordAddress))
                wordInfo[key] = wordAddress
                wordAddress += 1
                return tuple
            }
        }
        return nil
    }
    
    private func isNumber(_ str: inout String) -> (Int, String)? {
        var key = ""
        for c in str {
            if c >= "0" && c <= "9" {
                key.append(c)
            } else {
                break
            }
        }
        if key.count > 0 {
            let range = key.endIndex..<str.endIndex
            str = String(str[range])
            return (2, key)
        }
        return nil
    }
    
    init(with code: String) {
        self.code = code
    }
    
}
