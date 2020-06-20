import Foundation
import RegularExpressions
import XCTest

class RegexMatchTests: XCTestCase {
    
    static var allTests = [
        ("testRegexMatch", testRegexMatch),
        ("testRegexMatchWithRange", testRegexMatchWithRange)
    ]
    
    func testRegexMatch() {
        
        let url = "https://www.sitepoint.com/demystifying-regex-with-practical-examples/"
        let pattern =
        #"^(http|https|ftp):[\/]{2}([a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,4})(:[0-9]+)?\/?([a-zA-Z0-9\-\._\?\,\'\/\\\+&amp;%\$#\=~]*)"#
        
        assertNoThrow {
            let regexObject = try NSRegularExpression(pattern: pattern)
            
            let noObject = try url.regexFindAll(pattern)
            let withObject = try url.regexFindAll(regexObject)
            XCTAssertEqual(noObject, withObject)
            
        }
        
        assertNoThrow {
            if let match = try url.regexMatch(pattern) {
                
                assertRegexRangesMatch([match], inputText: url)
                
                XCTAssertEqual(
                    match.fullMatch,
                    "https://www.sitepoint.com/demystifying-regex-with-practical-examples/"
                )
                
                XCTAssertEqual(
                    match.groups.map { $0?.match },
                    [
                        Opt("https"),
                        Opt("www.sitepoint.com"),
                        Opt(nil),
                        Opt("demystifying-regex-with-practical-examples/")
                    ]
                )
                
            }
            else {
                XCTFail("should've found regex match")
            }
            
        }
        
        
        let inputText = "Details {name: Peter, AGE: 21, seX: Male}"
        let pattern_2 = #"NAME: (\w+), age: (\d{2}), sex: (male|female)"#
        
        do {
            if let match = try inputText.regexMatch(pattern_2, [.caseInsensitive]) {
                
                assertRegexRangesMatch([match], inputText: inputText)
                
                XCTAssertEqual(match.fullMatch, "name: Peter, AGE: 21, seX: Male")
                
                XCTAssertEqual(
                    match.groups.map { $0?.match },
                    [Opt("Peter"), Opt("21"), Opt("Male")]
                )
                
                let replaced = inputText.replacingCharacters(in: match.range, with: "null")
                XCTAssertEqual(replaced, "Details {null}")
                
            }
            else {
                XCTFail("should've found match")
            }
            
        } catch {
            XCTFail("\(error)")
        }
        
    }
 
    func testRegexMatchWithRange() {
        assertNoThrow {
            
            let inputText = "Peter Schorn"
            let stringRange = inputText.range(of: "Peter")!
            let match = try inputText.regexMatch("Schorn", range: stringRange)
            XCTAssert(match == nil)
            
            if let match2 = try inputText.regexMatch("Peter", range: stringRange) {
                XCTAssert(match2.fullMatch == "Peter")
                assertRegexRangesMatch([match2], inputText: inputText)
            }
            else {
                XCTFail("Should've found match")
            }
        }
    }
    
}
