//
//  Interpreter.swift
//  Swift-Scheme
//
//  Created by Dan Kerrigan on 7/5/16.
//  Copyright © 2016 Dan Kerrigan. All rights reserved.

import Foundation

public class Interpreter {
    let parser: Parser
    let evaluator: Evaluator
    var globalEnv: Environment
    
    public init() {
        self.parser = Parser()
        self.evaluator = Evaluator()
        self.globalEnv = Environment(current: Procedures.initial, parent: nil)
    }

    public func interpret(schemeString: String) -> [String] {
        var results = [String]()
        do {
            let parsed = try parser.parse(expression: schemeString)
            for statement in parsed {
                if let result = try evaluator.eval(node: statement, env: &globalEnv) {
                    results.append(result.toString())
                }
            }
        } catch SchemeError.syntax(let message) {
            results.append("Syntax Error: \(message)")
        } catch SchemeError.evaluator(let message) {
            results.append("Evaluator Error: \(message)")
        } catch {
            results.append("Error.")
        }
        return results
    }
}
