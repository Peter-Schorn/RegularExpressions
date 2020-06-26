import Foundation
import RegularExpressions
import XCTest

final class RegexObjectsTests: XCTestCase {
    
    static var allTests = [
        ("testPatternIsValid", testPatternIsValid)
    ]
    
    func testPatternIsValid() throws {
        
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
    
    
}
