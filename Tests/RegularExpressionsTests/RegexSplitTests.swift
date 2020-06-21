import Foundation
import RegularExpressions
import XCTest

class RegexSplitTests: XCTestCase {
    
    static var allTests = [
        ("testRegexSplit", testRegexSplit),
        ("testRegexSplitsComma", testRegexSplitsComma)
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
            let array = try colors.regexSplit(regex)
            XCTAssertEqual(array, ["red", "orange", "yellow", "blue"])
        }
        
        
    }
    
    
}
