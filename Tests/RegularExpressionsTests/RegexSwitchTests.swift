

import Foundation
import RegularExpressions
import XCTest

class RegexSwitchTests: XCTestCase {

    static var allTests = [
        ("testRegexSwitch1", testRegexSwitch1),
        ("testRegexSwitch2", testRegexSwitch2)
    ]
    
    
    func testRegexSwitch1() throws {
    
            let inputString = "age: 21"
            var foundMatch = false
            
            switch inputString {
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
    
    func testRegexSwitch2() throws {
        
        let inputStrig = #"user_id: "asjhjcb""#
        
        var foundMatch = false
        
        switch inputStrig {
            case try Regex(#"USER_ID: "[a-z]+""#, [.caseInsensitive]):
                // print("valid user id")
                foundMatch = true
            case try? Regex(#"[!@#$%^&]+"#):
                XCTFail("should've matched first case statement")
                // print("invalid character in user id")
            case try! Regex(#"^\d+$"#):
                XCTFail("should've matched first case statement")
                // print("user id cannot contain numbers")
            default:
                XCTFail("should've matched first case statement")
                // print("no match")
        }
        
        XCTAssert(foundMatch)

    }
    
    

    
}




