//
//  Evaluator.swift
//  Scheme-Interpreter
//
//  Created by Dan Kerrigan on 7/5/16.
//  Copyright © 2016 Dan Kerrigan. All rights reserved.
//

import Foundation

class Evaluator{

    func handleSymbol(symbol: String, env: Environment) throws -> Node {
        if let foundEnv = env.find(key: symbol) {
            return foundEnv[symbol]!
        } else {
            throw Error.evaluator("Cannot find \(symbol)")
        }
    }

    func handleIf(nodes: [Node], environment: inout Environment) throws -> Node? {
        if let test = try eval(node: nodes[0], env: &environment){
            switch test {
            case .boolean(let bool):
                let exp: Node
                if bool {
                    exp = nodes[1]
                } else {
                    if nodes.count >= 3 {
                        exp = nodes[2]
                    } else {
                        return nil
                    }
                }
                return try eval(node: exp, env: &environment)
            default:
                return try eval(node: nodes[1], env: &environment)
            }
        } else {
            return nil
        }
    }

    func handleDefine(nodes: [Node], environment: inout Environment) throws -> Node? {
        if case .symbol(let def) = nodes[0] {
            let result = try eval(node: nodes[1], env: &environment)
            environment[def] = result
            return nil
        } else {
            throw Error.evaluator("only symbols can be defined.")
        }
    }
    
    func handleSet(nodes: [Node], environment: inout Environment) throws -> Node? {
        if case .symbol(let def) = nodes[0] {
            if let env = environment.find(key: def) {
                let result = try eval(node: nodes[1], env: &environment)
                env[def] = result
                return nil
            } else {
                throw Error.evaluator("variable was not defined before using set!")
            }
        } else {
            throw Error.evaluator("only symbols can be set.")
        }
    }

    func handleLambda(nodes: [Node], environment: Environment) throws -> Node? {
        var params = [Node]()
        let parameters = nodes[0]
        if case .list(let ls) = parameters {
            params = ls
        } else {
            params = [parameters]
        }
        let stringParams: [String] = try params.map {
            if case let .symbol(sym) = $0 {
                return sym
            } else {
                throw Error.evaluator("lambda parameters should be symbols.")
            }
        }
        let body = Array(nodes.dropFirst())
        return Node.lambda(stringParams, body, environment)
    }

    func handleProc(procedure: Node, arguments: [Node], environment: inout Environment) throws -> Node? {
        if let proc = try eval(node: procedure, env: &environment){
            var args = [Node]()
            for element in arguments {
                if let arg = try eval(node: element, env: &environment) {
                    args.append(arg)
                }
            }
            if case .function(let fn) = proc {
                return try fn(args)
            } else if case .lambda = proc {
                return try callLambda(lambda: proc, arguments: args)
            } else {
                throw Error.evaluator("Problem handling procedure.")
            }
        } else {
            return nil
        }
    }

    func callLambda(lambda: Node, arguments: [Node]) throws -> Node? {
        if case .lambda(let params,  let body, let environ) = lambda {
            var inner = Environment(keys: params, values: arguments, parent: environ)
            var last: Node?
            for expression in body {
                last = try eval(node: expression, env: &inner)
            }
            return last 
        }
        throw Error.evaluator("not a lambda")
    }

    func handleList(nodes: [Node], env: inout Environment) throws -> Node? {
        var list = nodes
        let first = list.removeFirst()
        if case .symbol(let sym) = first {
            switch sym {
            case "quote":
                guard !list.isEmpty  else {
                    throw Error.evaluator("quote usage is (quote exp))")
                }
                return list[0]
            case "if":
                guard list.count >= 2 else {
                    throw Error.evaluator("if usage is (if test conseq alt)")
                }
                return try handleIf(nodes: list, environment: &env)
            case "define":
                guard list.count == 2 else {
                    throw Error.evaluator("define usage is (define var exp)")
                }
                return try handleDefine(nodes: list, environment: &env)
            case "set!":
                guard list.count == 2 else {
                    throw Error.evaluator("set! usage is (set! var exp)")
                }
                return try handleSet(nodes: list, environment: &env)
            case "lambda":
                guard !list.isEmpty else {
                    throw Error.evaluator("lambda usage is (lambda (params) body))")
                }
                return try handleLambda(nodes: list, environment: env)
            default:
                return try handleProc(procedure: first, arguments: list, environment: &env)
            } 
        }
        if case .list(let ls) = first {
            if let result = try handleList(nodes: ls, env: &env) {
                if case .lambda = result {
                    return try callLambda(lambda: result, arguments: list)
                }
            }
        }
        throw Error.evaluator("first atom in list is not a procedure.")
    }

    func eval(node: Node, env: inout Environment) throws -> Node? {
        switch node {
        case .symbol(let sym):
            return try handleSymbol(symbol: sym, env: env)
        case .number, .boolean:
            return node
        case .list(let list):
            if list.isEmpty { 
                return node
            }
            return try handleList(nodes: list, env: &env)
        default:
            print(node)
            throw Error.evaluator("Evaluation error.")
        }
    }
}
