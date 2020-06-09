import Foundation
import RegularExpressions
import XCTest

final class RegularExpressionsTests: XCTestCase {
    
    static var allTests = [
        ("testRegexFindAll", testRegexFindAll),
        ("testRegexMatch", testRegexMatch),
        ("testRegexSub", testRegexSub),
        ("testRegexSplit", testRegexSplit)
    ]
        
    /// Assert that the reported ranges of the matches in the original text
    /// are correct.
    func assertRegexRangesMatch(
        _ regexMatches: [RegularExpressions.RegexMatch],
        inputText: String
    ) {
    
        for match in regexMatches {
            XCTAssertEqual(match.fullMatch, String(inputText[match.range]))
            for group in match.groups.removeIfNil() {
                XCTAssertEqual(group.match, String(inputText[group.range]))
            }
        }
    }
    
    func testRegexFindAll() {
    
        let inputText = "season 8, episode 5; season 5, episode 20"
    
    
        func checkRegexMatches(_ results: [RegularExpressions.RegexMatch], input: String) {
    
            assertRegexRangesMatch(results, inputText: inputText)
    
            let firstResult = results[0]
            XCTAssertEqual(firstResult.fullMatch, "season 8, episode 5")
            do {
                let group0 = firstResult.groups[0]
                XCTAssertEqual(group0?.match, "8")
                let group1 = firstResult.groups[1]
                XCTAssertEqual(group1?.match, "5")
            }
    
            let secondResult = results[1]
            XCTAssertEqual(secondResult.fullMatch, "season 5, episode 20")
            do {
                let group0 = secondResult.groups[0]
                XCTAssertEqual(group0?.match, "5")
                let group1 = secondResult.groups[1]
                XCTAssertEqual(group1?.match, "20")
    
                // MARK: Substitutions
                var input = input
    
                if let group1 = group1 {
                    input.replaceSubrange(group1.range, with: "99")
                    XCTAssertEqual(input, "season 8, episode 5; season 5, episode 99")
                }
                else {
                    XCTFail("should've found group")
                }
    
                input.replaceSubrange(firstResult.range, with: "new value")
                XCTAssertEqual(input, "new value; season 5, episode 99")
    
            }
        }  // end checkRegexMatches
    
        let pattern = #"season (\d+), EPISODE (\d+)"#
        let regexObject = try! NSRegularExpression(
            pattern: pattern, options: [.caseInsensitive]
        )
    
        assertNoThrow {
            let noObject = try inputText.regexFindAll(pattern, [.caseInsensitive])
            let withObject = try inputText.regexFindAll(regexObject)
            XCTAssertEqual(noObject, withObject)
        }
    
        assertNoThrow {
            if let results = try inputText.regexFindAll(pattern, [.caseInsensitive]) {
                checkRegexMatches(results, input: inputText)
            }
            else {
                XCTFail("should've found match")
            }
        }
    
        assertNoThrow {
            if let results = try inputText.regexFindAll(regexObject) {
                checkRegexMatches(results, input: inputText)
            }
            else {
                XCTFail("should've found match")
            }
        }
    }
    
    
    func testRegexMatch() {
        // print("\n\n")
    
    
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
    
    
    func testRegexSub() {
    
    
        let text = "123 John Doe, age 21"
        let newText = text.regexSub(#"\d+$"#, with: "unknown")
        XCTAssertEqual(newText, "123 John Doe, age unknown")
    
        print("\n")
        let text2 = "/one two:,three. four;'%^&five six."
    
        var foundWords: [String] = []
        for word in text2.words() {
            foundWords.append(word)
        }
    
        XCTAssertEqual(foundWords, ["one", "two", "three", "four", "five", "six"])
    
    
    }
    
    
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
