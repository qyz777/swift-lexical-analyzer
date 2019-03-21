//
//  main.swift
//  swift-lexical-analyzer
//
//  Created by 戚译中 on 2019/3/21.
//  Copyright © 2019 戚译中. All rights reserved.
//

import Foundation

func readFile(with name: String) -> String {
    let path = Bundle.main.path(forResource: name, ofType: "txt")
    let url = URL(fileURLWithPath: path ?? "")
    do {
        let data = try Data(contentsOf: url)
        return String.init(data: data, encoding: .utf8) ?? ""
        
    } catch {
        print(error)
        return ""
    }
}

let analyzer = Analyzer.init(with: readFile(with: "analysis"))
analyzer.analyze()
