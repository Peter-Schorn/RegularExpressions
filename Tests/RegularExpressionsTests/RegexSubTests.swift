import Foundation
import RegularExpressions
import XCTest

final class RegexSubTests: XCTestCase {

    static var allTests = [
        ("testRegexSub", testRegexSub)
    ]
    
    func testRegexSub() {
    
    
        let text = "123 John Doe, age 21"
        let newText = text.regexSub(#"\d+$"#, with: "unknown")
        XCTAssertEqual(newText, "123 John Doe, age unknown")
    
        print("\n")
        let text2 = "/one two:,three. four;'%^&five six."
    
        var foundWords: [String] = []
        for word in text2.words() {
            foundWords.append(word)
        }
    
        XCTAssertEqual(
            foundWords,
            ["one", "two", "three", "four", "five", "six"]
        )
    
    }


}
