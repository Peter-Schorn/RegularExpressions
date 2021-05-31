

import Foundation
import RegularExpressions
import XCTest

extension XCTestCase {
    
}


final class RegexNamedGroupsTests: XCTestCase {
    
    static var allTests = [
        ("testNamedGroups", testNamedGroups),
        ("testNamedGroups_ShouldThrow", testNamedGroups_ShouldThrow)
    ]
    
    func testNamedGroups() throws {
        
        let inputText = "one two three"
        for match in try inputText.regexFindAll(
            #"(\w+) (\w+) (\w+)"#, groupNames: ["first", "second", "third"]
        ) {
            
            assertRegexRangesMatch([match], inputText: inputText)
            
            XCTAssertEqual(match.group(named: "first")?.match, Optional("one"))
            XCTAssertEqual(match.group(named: "second")?.match, Optional("two"))
            XCTAssertEqual(match.group(named: "third")?.match, Optional("three"))
        }
        
    }
    
    func testNamedGroups_ShouldThrow() throws {
        
        do {
            
            let inputText = "one two three"
            _ = try inputText.regexFindAll(
                #"\w+"#, groupNames: ["first", "second", "third"]
            )
            
            XCTFail("method call SHOULD'VE thrown groupNamesCountDoesntMatch")
            
        } catch let RegexError.groupNamesCountDoesntMatch(
            captureGroups, groupNames
        ) {
          XCTAssertEqual(captureGroups, 0)
          XCTAssertEqual(groupNames, 3)
        }
        
        
    }
    
    
}



