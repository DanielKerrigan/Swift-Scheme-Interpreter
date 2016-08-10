import XCTest

import InterpreterTestSuite

var tests = [XCTestCaseEntry]()
tests += InterpreterTestSuite.allTests()
XCTMain(tests)
