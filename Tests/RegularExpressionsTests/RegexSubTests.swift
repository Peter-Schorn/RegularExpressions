import Foundation
import RegularExpressions
import XCTest

final class RegexSubTests: XCTestCase {

    static var allTests = [
        ("testRegexSub", testRegexSub),
        ("testRegexSubInPlace", testRegexSubInPlace),
        ("testRegexSubTemplates", testRegexSubTemplates),
        ("testRegexSubMatchOptions", testRegexSubMatchOptions)
    ]
    
    func testRegexSub() throws {
    
        let text = "123 John Doe, age 21"
        let newText = try text.regexSub(#"\d+$"#, with: "unknown")
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
    
    func testRegexSubInPlace() throws {
        
        var text = "Have a terrible day"
        try text.regexSubInPlace("terrible", with: "nice")
        XCTAssertEqual(text, "Have a nice day")

    }

    func testRegexSubTemplates() {
        
        assertNoThrow {
            let inputText = "(512) 721-8706"
            
            let newText = try inputText.regexSub(
                #"\((\d{3})\)\s*(\d{3})-(\d{4})"#,
                with: "$1$2$3"
            )
            
            XCTAssertEqual(newText, "5127218706")
        }
        assertNoThrow {
            let inputText = "Charles Darwin"
            
            let newText = try! inputText.regexSub(
                #"(\w+) (\w+)"#,
                with: "$2 $1"
            )
            
            XCTAssertEqual(newText, "Darwin Charles")
        }
    

    }
    
    func testRegexSubMatchOptions() throws {
        
        let name = "Peter Schorn"
        let regexObject = try Regex(
            pattern: #"\w+"#, regexOptions: [.caseInsensitive], matchingOptions: [.anchored]
        )
        let replacedText = name.regexSub(regexObject, with: "word")
        // print(replacedText)
        XCTAssertEqual(replacedText, "word Schorn")
        
    }
    
}
