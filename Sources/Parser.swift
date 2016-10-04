//
//  Parser.swift
//  Scheme-Interpreter
//
//  Created by Dan Kerrigan on 7/5/16.
//  Copyright © 2016 Dan Kerrigan. All rights reserved.
//

import Foundation

class Parser{
    func parse(expression: String) throws -> [Node] {
        let ast = try read(tokens: tokenize(string: expression))
        return ast
    }

    func tokenize(string: String) -> [String] {
        var padded = string.replacingOccurrences(of: "(", with: " ( ")
        padded = padded.replacingOccurrences(of: ")", with: " ) ")
        return padded.characters.split(separator: " ").map(String.init)
    }

    func read(tokens:[String]) throws -> [Node] {
        var stack = [[Node]]()
        var current = [Node]()

        for token in tokens {
            if token == "(" {
                stack.append(current)
                current = [Node]()
            } else if token == ")" {
                guard !stack.isEmpty else { throw SchemeError.syntax("Unexpected ')'.") }
                let list = Node.list(current)
                current = stack.removeLast()
                current.append(list)
            } else if let number = Double(token) {
                current.append(Node.number(number))
            } else {
                current.append(Node.symbol(token))
            }
        }

        guard stack.isEmpty else { throw SchemeError.syntax("Unexpected EOF.") }

        return current
    }
}
