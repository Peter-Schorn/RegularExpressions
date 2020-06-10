import Foundation
import RegularExpressions
import XCTest

class RegexSwitchTests: XCTestCase {

    static var allTests = [
        ("testRegexSwitch", testRegexSwitch)
    ]
    
    
    func testRegexSwitch() {
    
        assertNoThrow {
            
            let inputString = "age: 21"
            var foundMatch = false
            
            switch  inputString {
                case try Regex(#"\d+"#):
                    foundMatch = true
                case try Regex("^[a-z]+$"):
                    XCTFail("should've matched first case statement")
                case try Regex("height: 21", [.caseInsensitive]):
                    XCTFail("should've matched first case statement")
                default:
                    XCTFail("should've matched first case statement")
            }
            
            XCTAssert(foundMatch)
            
        }
        
    }

    
}
