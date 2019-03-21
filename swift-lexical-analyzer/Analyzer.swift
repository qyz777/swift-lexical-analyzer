//
//  Analyzer.swift
//  swift-lexical-analyzer
//
//  Created by 戚译中 on 2019/3/21.
//  Copyright © 2019 戚译中. All rights reserved.
//

import Foundation

class Analyzer {
    
    private let symbols: [String: Int] = ["main": 1, "int": 2, "if": 3, "else": 4, "while": 5, "do": 6, "<": 7, ">": 8, "!=": 9, ">=": 10, "<=": 11, "==": 12, ",": 13, ";": 14, "(": 15, ")": 16, "{": 17, "}": 18, "+": 19, "-": 20, "*": 21, "/": 22, "=": 23]
    
    private var code: String = ""
    
    private var list: [(String, Int)] = []
    
    public func analyze() {
        let codeLineArray = code.split(separator: "\n")
        for line in codeLineArray {
            lineAnalyze(String(line))
        }
        for t in list {
            print(t)
        }
    }
    
    private func lineAnalyze(_ line: String) {
        var tempLine = line
        while tempLine.count > 0 {
            if let tuple = isSymbol(&tempLine) {
                list.append(tuple)
            } else if let tuple = isLetter(&tempLine) {
                list.append(tuple)
            } else if let tuple = isNumber(&tempLine) {
                list.append(tuple)
            } else {
                tempLine.remove(at: .init(encodedOffset: 0))
            }
        }
    }
    
    private func symbolCode(_ key: String) -> Int? {
        return symbols[key]
    }
    
    private func isSymbol(_ str: inout String) -> (String, Int)? {
        let maxCount = 4
        var key = ""
        var index = 0
        for c in str {
            if index >= maxCount {
                break
            }
            key.append(c)
            if symbolCode(key) != nil {
                let range = key.endIndex..<str.endIndex
                str = String(str[range])
                return (key, symbols[key]!)
            }
            index += 1
        }
        return nil
    }
    
    private func isNumber(_ str: inout String) -> (String, Int)? {
        let key = str.first!
        if key >= "0" && key <= "9" {
            str.remove(at: .init(encodedOffset: 0))
            return (String(key), 24)
        }
        return nil
    }
    
    private func isLetter(_ str: inout String) -> (String, Int)? {
        let key = str.first!
        if (key >= "a" && key <= "z") || (key >= "A" && key <= "Z") {
            str.remove(at: .init(encodedOffset: 0))
            return (String(key), 0)
        }
        return nil
    }
    
    init(with code: String) {
        self.code = code
    }
    
}
