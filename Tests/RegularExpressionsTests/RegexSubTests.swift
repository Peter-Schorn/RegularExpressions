

import Foundation
import RegularExpressions
import XCTest

final class RegexSubTests: XCTestCase {

    static var allTests = [
        ("testRegexSub", testRegexSub),
        ("testRegexSubInPlace", testRegexSubInPlace),
        ("testRegexSubTemplates", testRegexSubTemplates),
        ("testRegexSubMatchOptionsDocs", testRegexSubMatchOptionsDocs),
        ("testRegexSubSearchRange", testRegexSubSearchRange),
        ("testRegexSubDocs", testRegexSubDocs),
        ("testRegexSubDocs2", testRegexSubDocs2)
    ]

    
    func testRegexSubSearchRange() throws {
        
        let inputText = "David Buss evolutionary Psychology"
        let searchRange = inputText.range(of: "David Buss evolutionary")
        let pattern = #"([A-Z])(\w+)"#
        let groupNames = ["first letter", "rest"]
        
        let regexObjects = try makeAllRegexObjects(
            pattern: pattern,
            groupNames: groupNames
        )
        for object in regexObjects {
            let replacedText = try inputText.regexSub(object, with: "$2$1", range: searchRange)
            XCTAssertEqual(replacedText, "avidD ussB evolutionary Psychology")
        }
        
        let anchoredObjects = try makeAllRegexObjects(
            pattern: pattern,
            matchingOptions: [.anchored],
            groupNames: groupNames
        )
        
        for object in anchoredObjects {
            let replacedText = try inputText.regexSub(object, with: "$2$1", range: searchRange)
            XCTAssertEqual(replacedText, "avidD Buss evolutionary Psychology")
            
        }

    }
    
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

    func testRegexSubTemplates() throws {
        
        do {
            let inputText = "(512) 721-8706"
            
            let newText = try inputText.regexSub(
                #"\((\d{3})\)\s*(\d{3})-(\d{4})"#,
                with: "$1$2$3"
            )
            
            XCTAssertEqual(newText, "5127218706")
        }
        
        do {
            let inputText = "Charles Darwin"
            
            let newText = try! inputText.regexSub(
                #"(\w+) (\w+)"#,
                with: "$2 $1"
            )
            
            XCTAssertEqual(newText, "Darwin Charles")
        }
    

    }
    
    func testRegexSubMatchOptionsDocs() throws {
        
        let name = "Peter Schorn"
        let regexObject = try Regex(
            pattern: #"\w+"#,
            regexOptions: [.caseInsensitive],
            matchingOptions: [.anchored]
        )
        let replacedText = try name.regexSub(regexObject, with: "word")
        // print(replacedText)
        XCTAssertEqual(replacedText, "word Schorn")
        
    }
    
    func testRegexSubDocs() throws {
        
        let text = "123 John Doe, age 21"
        let newText = try text.regexSub(#"\d+$"#, with: "unknown")
        XCTAssertEqual(newText, "123 John Doe, age unknown")
        // newText = "123 John Doe, age unknown"

        let name = "Charles Darwin"
        let reversedName = try name.regexSub(
            #"(\w+) (\w+)"#,
            with: "$2 $1"
            // $1 and $2 represent the
            // first and second capture group, respectively.
            // $0 represents the entire match.
        )
        
        // reversedName = "Darwin Charles"
        XCTAssertEqual(reversedName, "Darwin Charles")
        

    }
    
    func testRegexSubDocs2() throws {
        
        var text = "Have a terrible day"
        let regexObject = try Regex(pattern: "terrible")
        try text.regexSubInPlace(regexObject, with: "nice")
        print(text)

    }
    
    
}


