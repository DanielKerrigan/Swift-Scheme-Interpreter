@testable import SchemeInterpreter
import XCTest

class ParserTests: XCTestCase {
    let parser = Parser()

    func performErrorTest(expression: String, error: String) {
        do {
            let _ = try parser.parse(expression: expression)
            XCTFail("\(error) not thrown.")
        } catch Error.syntax(let msg) {
            XCTAssertEqual(msg, error, "\(error) should be thrown.")
        } catch {
            XCTFail("Wrong error thrown.")
        }
    }

    func performTest(expression: String, expected: [Node], info: String) {
        do {
            let result = try parser.parse(expression: expression)
            let stringResult = result.map({$0.toString()})
            let stringExpected = expected.map({$0.toString()})
            XCTAssertEqual(stringResult, stringExpected, info)
        } catch {
            XCTFail("Error thrown.")
        }
    }

    func testUnexpectedEOF() {
        performErrorTest(expression: "(+ (- 5 1 1)", error: "Unexpected EOF.")
        performErrorTest(expression: "(+ 1 2) (+ 1 2", error: "Unexpected EOF.")
    }

    func testEarlyClosedParen() {
        performErrorTest(expression: "(+ 5 1))", error: "Unexpected ')'.")
        performErrorTest(expression: "(+ 5 1) (+ 5 1))", error: "Unexpected ')'.")
    }

    func testParseNestedExpressions() {
        let innerList = Node.list([Node.symbol("+"), Node.number(1), Node.number(2)])
        let outerList = Node.list([Node.symbol("-"), innerList])
        let result = [outerList]
        let info = "Nested expressions."
        performTest(expression: "(- (+ 1 2))", expected: result, info: info)
    }

    func testParseMultipleExpressions() {
        let list = Node.list([Node.symbol("+"), Node.number(1), Node.number(2)])
        let result = [list, list]
        let info = "Multiple separate expressions."
        performTest(expression: "(+ 1 2) (+ 1 2)", expected: result, info: info)
    }
    
    static var allTests = [
        ("testUnexpectedEOF", testUnexpectedEOF),
        ("testEarlyClosedParen", testEarlyClosedParen),
        ("testParseNestedExpressions", testParseNestedExpressions),
        ("testParseMultipleExpressions", testParseMultipleExpressions)
    ]
} 
