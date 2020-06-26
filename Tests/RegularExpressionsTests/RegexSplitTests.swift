import Foundation
import RegularExpressions
import XCTest

class RegexSplitTests: XCTestCase {
    
    static var allTests = [
        ("testRegexSplit", testRegexSplit),
        ("testRegexSplitsComma", testRegexSplitsComma),
        ("testRegexSplitWithOptions", testRegexSplitWithOptions)
    ]
    
    func testRegexSplit() {
        
        assertNoThrow {
            let fruits = "apples|oranges|bannanas"
            let array = try fruits.regexSplit(#"\|"#)
            XCTAssertEqual(array, ["apples", "oranges", "bannanas"])
            
        }
        assertNoThrow {
            let list = "1. milk 2. bread 30. eggs"
            let array = try list.regexSplit(#"\d+\.\s+"#)
            XCTAssertEqual(array, ["", "milk ", "bread ", "eggs"])
            
        }
        assertNoThrow {
            let url = "https://github.com/apple/swift-numerics/blob/master/Package.swift"
            let array = try url.regexSplit(#"(/|\.)"#, ignoreIfEmpty: true)
            XCTAssertEqual(
                array,
                [
                    "https:", "github", "com", "apple", "swift-numerics",
                    "blob", "master", "Package", "swift"
                ]
            )
        }
        
    }
    
    func testRegexSplitsComma() {
        
        assertNoThrow {
            let colors = "red,orange,yellow,blue"
            let array = try colors.regexSplit(",")
            XCTAssertEqual(array, ["red", "orange", "yellow", "blue"])
        }
        assertNoThrow {
            let colors = "red and orange ANDyellow and    blue"
            let regex = try Regex(#"\s*and\s*"#, [.caseInsensitive])
            let array = try colors.regexSplit(regex, maxLength: 3)
            // note that "blue" is not returned because the length of the
            // array was limited to 3 items
            XCTAssertEqual(array, ["red", "orange", "yellow"])
        }
        
        
    }
    
    func testRegexSplitWithOptions() throws {
        
        let numbersStr = "zero one two three four five six seven eight nine"
        let searchRange = numbersStr.range(of: "one two three four")!
        let numbers = try numbersStr.regexSplit(" ", maxLength: 3, range: searchRange)
        XCTAssertEqual(numbers, ["one", "two", "three"])
        
        let numbers2 = try numbersStr.regexSplit(" ", maxLength: 500, range: searchRange)
        XCTAssertEqual(numbers2, ["one", "two", "three", "four"])

    }
    
    
}
