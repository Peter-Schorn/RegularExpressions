import Foundation
import RegularExpressions
import XCTest

class RegexSplitTests: XCTestCase {
    
    static var allTests = [
        ("testRegexSplit", testRegexSplit)
    ]
    
    func testRegexSplit() {
        
        do {
            let fruits = "apples|oranges|bannanas"
            let array = try fruits.regexSplit(#"\|"#)
            XCTAssertEqual(array, ["apples", "oranges", "bannanas"])
            
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            let list = "1. milk 2. bread 30. eggs"
            let array = try list.regexSplit(#"\d+\.\s+"#)
            XCTAssertEqual(array, ["", "milk ", "bread ", "eggs"])
            
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            let url = "https://github.com/apple/swift-numerics/blob/master/Package.swift"
            let array = try url.regexSplit(#"(/|\.)"#, ignoreIfEmpty: true)
            XCTAssertEqual(
                array,
                [
                    "https:", "github", "com", "apple", "swift-numerics",
                    "blob", "master", "Package", "swift"
                ]
            )
            
        } catch {
            XCTFail("\(error)")
        }
        
    }
    
}
