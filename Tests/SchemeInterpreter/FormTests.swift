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

    func testLambda() {
        let _ = interpreter.interpret(schemeString: "(define plus (lambda (a b) (+ a b)))")
        performTest(interpret: "(plus 2 3)", expected: ["5.0"], info: "Use defined function.")
    }

    func testLambdaFactorial() {
        let exp = "(define fact (lambda n (if (<= n 1) 1 (* n (fact (- n 1))))))"
        let _ = interpreter.interpret(schemeString: exp)
        performTest(interpret: "(fact 10)", expected: ["3628800.0"], info: "Lambda factorial.")
    }

    static var allTests = [
        ("testDefine", testDefine),
        ("testDefineWrongCount", testDefineWrongCount),
        ("testIf", testIf),
        ("testLambda", testLambda),
        ("testLambdaFactorial", testLambdaFactorial)
    ]
}
