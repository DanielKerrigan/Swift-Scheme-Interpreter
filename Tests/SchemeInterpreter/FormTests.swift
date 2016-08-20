@testable import SchemeInterpreter
import XCTest

class FormTests: XCTestCase {
   
    let interpreter = Interpreter()
    
    func performTest(interpret: String, expected: [String], info: String) {
        XCTAssertEqual(interpreter.interpret(schemeString: interpret), expected, info)
    }

    func testDefine() {
        let _ = interpreter.interpret(schemeString: "(define x 5)")
        performTest(interpret: "(+ x 1)", expected: ["6.0"], info: "Use defined value.")
    }

    func testDefineWrongCount() {
        let error = "Evaluator Error: define usage is (define var exp)"
        performTest(interpret: "(define y 1 2)", expected: [error], info: "Incorrect define.")
    }
    
    func testDefineNonSymbol() {
        let error = "Evaluator Error: only symbols can be defined."
        performTest(interpret: "(define 3 4)", expected: [error], info: "Defining number.")
    }
    
    func testSet() {
        let _ = interpreter.interpret(schemeString: "(define x 5)")
        let _ = interpreter.interpret(schemeString: "(set! x 7)")
        performTest(interpret: "x", expected: ["7.0"], info: "Set variable new value.")
    }
    
    func testSetWrongCount() {
        let error = "Evaluator Error: set! usage is (set! var exp)"
        performTest(interpret: "(set! x 1 2)", expected: [error], info: "Incorrect set.")
    }
    
    func testSetNonSymbol() {
        let error = "Evaluator Error: only symbols can be set."
        performTest(interpret: "(set! 3 4)", expected: [error], info: "Setting  number.")
    }
    
    
    func testIf() {            
        let _ = interpreter.interpret(schemeString: "(define y 3)")
        performTest(interpret: "(if (= y 3) 1 2)", expected: ["1.0"], info: "if true.")
        performTest(interpret: "(if (= y 3) 1)", expected: ["1.0"], info: "if true, no alt.")
        performTest(interpret: "(if (= y 4) 1 2)", expected: ["2.0"], info: "if false.")
        performTest(interpret: "(if 7 1 2)", expected: ["1.0"], info: "if default to true.")
    }

    func testWrongIf() {
        let error = "Evaluator Error: if usage is (if test conseq alt)"
        performTest(interpret: "(if (= y 3))", expected: [error], info: "invalid if")
    }

    func testLambdaDirect() {
        let schemeString = "((lambda (a b) (+ a b)) 2 3)"
        performTest(interpret: schemeString, expected: ["5.0"], info: "Use lambda directly.")
    }

    func testLambdaDefine() {
        let exp = "(define fact (lambda (n) (if (<= n 1) 1 (* n (fact (- n 1))))))"
        let _ = interpreter.interpret(schemeString: exp)
        performTest(interpret: "(fact 10)", expected: ["3628800.0"], info: "Define lambda.")
    }

    func testLambdaNonSymbol() {
        let schemeString = "(define w (lambda (a 1) (+ a 1)))"
        let error = "Evaluator Error: lambda parameters should be symbols."
        performTest(interpret: schemeString, expected: [error], info: "Invalid lambda paramters.")
    }
    
    func testLambdaMultiBody() {
        let exp = "((lambda (a) (define b 1) (+ a b)) 6)"
        performTest(interpret: exp, expected: ["7.0"], info: "Two body expressions.")
    }

    func testLambdaListParameter() {
        let exp = "((lambda list (car list)) (1 2 3 4))"
        performTest(interpret: exp, expected: ["1.0"], info: "List parameter with lambda.")
    } 

    static var allTests = [
        ("testDefine", testDefine),
        ("testDefineWrongCount", testDefineWrongCount),
        ("testDefineNonSymbol", testDefineNonSymbol),
        ("testSet", testSet),
        ("testSetWrongCount", testSetWrongCount),
        ("testSetNonSymbol", testSetNonSymbol),
        ("testIf", testIf),
        ("testLambdaDirect", testLambdaDirect),
        ("testLambdaDefine", testLambdaDefine),
        ("testLambdaNonSymbol", testLambdaNonSymbol)
    ]
}
