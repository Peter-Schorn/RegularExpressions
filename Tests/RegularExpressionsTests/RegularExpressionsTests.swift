import XCTest
@testable import RegularExpressions

final class RegularExpressionsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(RegularExpressions().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
