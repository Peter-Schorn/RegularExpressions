import Foundation
import RegularExpressions
import XCTest

final class RegexObjectsTests: XCTestCase {
    
    static var allTests = [
        (
            "testPatternIsValidAndNumberOfCaptureGroups",
            testPatternIsValidAndNumberOfCaptureGroups
        ),
        ("testReplaceCaptureGroups", testReplaceCaptureGroups)
    ]
    
    func testPatternIsValidAndNumberOfCaptureGroups() throws {
        
        let invalidPattern = #"(\w+"#
        XCTAssertFalse(Regex.patternIsValid(pattern: invalidPattern))
        XCTAssert(
            Regex.patternIsValid(
                pattern: invalidPattern, options: [.ignoreMetacharacters]
            )
        )
        
        XCTAssertThrowsError(try Regex(pattern: invalidPattern))
        var regexObject = try Regex(
            pattern: invalidPattern, regexOptions: [.ignoreMetacharacters]
        )
        XCTAssertEqual(try regexObject.numberOfCaptureGroups(), 0)
        
        
        regexObject.regexOptions = []
        XCTAssertFalse(regexObject.patternIsValid())
        regexObject.pattern = #"(\w+)"#
        XCTAssertEqual(try regexObject.numberOfCaptureGroups(), 1)
        XCTAssert(regexObject.patternIsValid())
        
    }
    
    func testReplaceCaptureGroups() throws {
        
        let inputText = "name: Peter, id: 35, job: programmer"
        let pattern = #"name: (\w+), id: (\d+)"#
        let groupNames = ["name", "id"]
        
        guard let match = try inputText.regexMatch(
            pattern, groupNames: groupNames
        ) else {
            XCTFail("should've found match")
            return
        }
        
        let replacedMatch = match.replaceGroups { indx, group in
            if group.name == "name" { return "Steven" }
            if group.name == "id" { return "55" }
            return nil
        }
        XCTAssertEqual(match.fullMatch, "name: Peter, id: 35")
        XCTAssertEqual(replacedMatch, "name: Steven, id: 55")
        // match.fullMatch = "name: Peter, id: 35"
        // replacedMatch = "name: Steven, id: 55"

    }
    
    
}
