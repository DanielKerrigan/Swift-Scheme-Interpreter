import XCTest

#if !os(OSX)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ParserTests.allTests),
        testCase(ProceduresTests.allTests),
        testCase(FormTests.allTests)
    ]
}
#endif
