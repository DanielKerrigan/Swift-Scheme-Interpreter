import Foundation

class Procedures {

    private typealias this = Procedures

    static let initial: [String: Node] = [
            "+": .function(this.add),
            "*": .function(this.multiply),
            "-": .function(this.subtract),
            "/": .function(this.divide),
            ">": .function(this.comparison(op: >)),
            "<": .function(this.comparison(op: <)),
            ">=": .function(this.comparison(op: >=)),
            "<=": .function(this.comparison(op: <=)),
            "=": .function(this.comparison(op: ==)),
            "abs": .function(this.absolute),
            "car": .function(this.car),
            "cdr": .function(this.cdr),
            "not": .function(this.not)
        ]

    class func getNumbers(nodes: [Node]) throws -> [Double] {
        var numbers = [Double]()
        for node in nodes {
            switch node {
            case .number(let number):
                numbers.append(number)
            default:
                throw SchemeError.evaluator("Math operators can only be used on numbers.")
            }
        }
        return numbers
    }

    class func add(nodes: [Node]) throws -> Node {
        let numbers = try getNumbers(nodes: nodes)
        if numbers.count == 0 { return Node.number(0) }
        let answer = numbers.reduce(0, +)
        return Node.number(answer)
    }

    class func multiply(nodes: [Node]) throws -> Node {
        let numbers = try this.getNumbers(nodes: nodes)
        if numbers.count == 0 { return Node.number(0) }
        let answer = numbers.reduce(1, *)
        return Node.number(answer)
    }

    class func subtract(nodes: [Node]) throws -> Node {
        let numbers = try this.getNumbers(nodes: nodes)
        if numbers.count == 0 { return Node.number(0) }
        if numbers.count == 1 { return Node.number(-numbers[0]) }
        let answer = numbers[1..<numbers.endIndex].reduce(numbers[0], -)
        return Node.number(answer)
    }

    class func divide(nodes: [Node]) throws -> Node {
        let numbers = try this.getNumbers(nodes: nodes)
        if let zero_index = numbers.index(of: 0){
            if zero_index == 0 {
                return Node.number(0)
            } else {
                throw SchemeError.evaluator("Cannot divide by 0.")
            }
        }

        if numbers.count == 0 { return Node.number(0) }
        let answer = numbers[1..<numbers.endIndex].reduce(numbers[0], /)
        return Node.number(answer)
    }

    class func comparison(op: @escaping (Double, Double) -> Bool) -> ([Node]) throws -> Node {
        func compare(nodes: [Node]) throws -> Node {
            let numbers = try this.getNumbers(nodes: nodes)
            if numbers.count < 2 { throw SchemeError.evaluator("Too few arguments for comparison.") }
            for i in 1..<numbers.endIndex {
                if !op(numbers[i-1], numbers[i]) {
                    return Node.boolean(false)
                }
            }
            return Node.boolean(true)
        }
        return compare
    }

    class func absolute(nodes: [Node]) throws -> Node {
        guard nodes.count == 1 else { throw SchemeError.evaluator("abs takes one argument.") }
        if case .number(let num) = nodes[0] {
            return Node.number(abs(num))
        } else {
            throw SchemeError.evaluator("abs requires a number.")
        }
    }

    class func car(nodes: [Node]) throws -> Node {
        guard nodes.count == 1 else { throw SchemeError.evaluator("car takes one argument.") }
        if case .list(let list) = nodes[0] {
            guard list.count > 0 else { throw SchemeError.evaluator("cannot car empty list.") }
            return list[0]
        } else {
            throw SchemeError.evaluator("car expects a list.")
        }
    }

    class func cdr(nodes: [Node]) throws -> Node {
        guard nodes.count == 1 else { throw SchemeError.evaluator("cdr takes one argument.") }
        if case .list(var list) = nodes[0] {
            guard list.count > 0 else { throw SchemeError.evaluator("cannot cdr empty list.") }
            list.removeFirst()
            return Node.list(list)
        } else {
            throw SchemeError.evaluator("cdr expects a list.")
        }
    }

    class func not(nodes: [Node]) throws -> Node {
        guard nodes.count == 1 else { throw SchemeError.evaluator("not takes one argument.") }
        if case .boolean(let bool) = nodes[0] {
            return Node.boolean(!bool)
        } else {
            return Node.boolean(false)
        }

    }
}
