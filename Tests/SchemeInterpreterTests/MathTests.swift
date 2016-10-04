@testable import SchemeInterpreter
import XCTest

class MathTests: XCTestCase {
   
    let interpreter = Interpreter()
    
    func performTest(interpret: String, expected: [String], info: String) {
        XCTAssertEqual(interpreter.interpret(schemeString: interpret), expected, info)
    }

    func testBasicMath() {
        let schemeString = "(- (/ (-(+ (* 2 5) 13) 1 2) 4 2) (- 5 1.5))" 
        performTest(interpret: schemeString, expected: ["-1.0"], info: "4 basic math ops.")
    }

    func testBasicMathWithNonNumbers() {
        let error = ["Evaluator Error: Math operators can only be used on numbers."]
        let info = "Math operators require numbers."
        performTest(interpret: ("(+ 1 (< 1 2))"), expected: error, info: info)
    }

    func testDivideByZero() {
        let error = ["Evaluator Error: Cannot divide by 0."]
        performTest(interpret: "(/ 5 0)", expected: error, info: "Divide by 0.")
    }
    
    func testNegation() {
        performTest(interpret: "(- 4)", expected: ["-4.0"], info: "Unary - flips sign.")
        performTest(interpret: "(- -4)", expected: ["4.0"], info: "Unary - flips sign.")
    }

    func testComparisonWithTooFewOperators() {
        let error = ["Evaluator Error: Too few arguments for comparison."]
        let info = "Comparisons require 2+ arguments."
        performTest(interpret: ("(< 1)"), expected: error, info: info)
    }

    func testComparisonOperators() {
        performTest(interpret: "(< 4 5 6)", expected: ["#t"], info: "<: true.")
        performTest(interpret: "(< 4 5 5)", expected: ["#f"], info: "<: false.")
        
        performTest(interpret: "(> 5 4 3)", expected: ["#t"], info: ">: true.")
        performTest(interpret: "(> 5 4 4)", expected: ["#f"], info: ">: false.")
       
        performTest(interpret: "(<= 5 5 6)", expected: ["#t"], info: "<=: true.")
        performTest(interpret: "(<= 5 5 4)", expected: ["#f"], info: "<=: false.")
        
        performTest(interpret: "(>= 5 5 4)", expected: ["#t"], info: ">=: true.")
        performTest(interpret: "(>= 5 5 6)", expected: ["#f"], info: ">=: false.")

        performTest(interpret: "(= 5 5 5)", expected: ["#t"], info: "=: true.")
        performTest(interpret: "(= 5 5 4)", expected: ["#f"], info: "=: false.")
    }

    static var allTests = [
        ("testBasicMath", testBasicMath),
        ("testBasicMathWithNonNumbers", testBasicMathWithNonNumbers),
        ("testNegation", testNegation),
        ("testDivideByZero", testDivideByZero),
        ("testComparisonOperators", testComparisonOperators),
        ("testComparisonWithTooFewOperators", testComparisonWithTooFewOperators),
    ]
}
