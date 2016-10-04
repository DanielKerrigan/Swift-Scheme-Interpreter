import XCTest

#if !os(OSX)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ParserTests.allTests),
        testCase(MathTests.allTests),
        testCase(FormTests.allTests)
    ]
}
#endif
