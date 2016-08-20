//  Node.swift
//  Scheme-Interpreter
//
//  Created by Dan Kerrigan on 7/5/16.
//  Copyright © 2016 Dan Kerrigan. All rights reserved.
//

import Foundation

enum Node {
    case number(Double)
    case symbol(String)
    case boolean(Bool)
    indirect case list([Node])
    indirect case function(([Node]) throws -> Node)
    indirect case lambda([String], [Node], Environment)
    
    func toString(node: Node? = nil) -> String {
        let nodeToPrint = node ?? self
        var output = ""
        switch nodeToPrint {
        case .number(let num):
            output += "\(num)"
        case .symbol(let sym):
            output += "\(sym)"
        case .boolean(let bool):
            output += bool ? "#t" : "#f"
        case .list(let ls):
            output += "("
            for n in ls {
                output += toString(node: n)
            }
            output += ")"
        default:
            output += ""
        }
        output = output.replacingOccurrences(of: " )", with: ")")
        output = output.replacingOccurrences(of: ")(", with: ") (")
        return output
    }
}
