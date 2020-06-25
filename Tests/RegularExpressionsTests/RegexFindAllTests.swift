import Foundation
import RegularExpressions
import XCTest

final class RegexFindAllTests: XCTestCase {
    
    static var allTests = [
        ("testRegexFindAll", testRegexFindAll),
        ("testRegexFindAll2", testRegexFindAll2),
        ("testRegexFindAllDocs", testRegexFindAllDocs)
    ]
        
    func testRegexFindAll() throws {
     
        let inputText = "season 8, EPISODE 5; season 5, episode 20"
        let pattern = #"season (\d+), Episode (\d+)"#
        let groupNames = ["SEASON", "EPISODE"]
        
        let results = try! inputText.regexFindAll(
            pattern, regexOptions: [.caseInsensitive]
        )
        
        let result = results[0]
        // print("fullMatch: '\(result.fullMatch)'")
        XCTAssertEqual(result.fullMatch, "season 8, EPISODE 5")
        
        let captureGroups = result.groups.map { captureGroup in
            captureGroup!.match
        }
        
        // print("Capture groups:", captureGroups)
        // print()
        XCTAssertEqual(captureGroups, ["8", "5"])
        
        let firstResult = results[0]
        
        var copy = inputText
        copy.replaceSubrange(firstResult.range, with: "new value")
        
        // print("after replacing text: '\(inputText)'")
        XCTAssertEqual(copy, "new value; season 5, episode 20")
        
        try regexFindAllFuzz(
            inputText: inputText,
            pattern: pattern,
            regexOptions: [.caseInsensitive],
            matchingOptions: [],
            groupNames: groupNames,
            range: nil
        ) { results in
            
           
            let result1 = results[0]
            // print("fullMatch: '\(result.fullMatch)'")
            XCTAssertEqual(result1.fullMatch, "season 8, EPISODE 5")
            
            let captureGroups1 = result1.groups.compactMap { captureGroup in
                captureGroup?.match
            }
            XCTAssertEqual(result1.groupNames, groupNames)
            
            // print("Capture groups:", captureGroups)
            // print()
            XCTAssertEqual(captureGroups1, ["8", "5"])
            
            var copy = inputText
            copy.replaceSubrange(result1.range, with: "new value")
            
            // print("after replacing text: '\(inputText)'")
            XCTAssertEqual(copy, "new value; season 5, episode 20")
            
            let result2 = results[1]
            XCTAssertEqual(result2.fullMatch, "season 5, episode 20")
            let captureGroups2 = result2.groups.compactMap { captureGroup in
                captureGroup?.match
            }
            XCTAssertEqual(result2.groupNames, groupNames)
            XCTAssertEqual(captureGroups2, ["5", "20"])
            
                
        }
        
        
    }
    
    func testRegexFindAll2() {
    
        let inputText = "season 8, episode 5; season 5, episode 20"
    
    
        func checkRegexMatches(_ results: [RegexMatch], input: String) {
    
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
            let noObject = try inputText.regexFindAll(pattern, regexOptions: [.caseInsensitive])
            let withObject = try inputText.regexFindAll(regexObject)
            XCTAssertEqual(noObject, withObject)
        }
    
        assertNoThrow {
            let results = try inputText.regexFindAll(pattern, regexOptions: [.caseInsensitive])
            checkRegexMatches(results, input: inputText)
        }
    
        assertNoThrow {
            let results = try inputText.regexFindAll(regexObject)
            checkRegexMatches(results, input: inputText)
        }
    }
    
    func testRegexFindAllDocs() throws {
        
        var inputText = "season 8, EPISODE 5; season 5, episode 20"
        let regex = try! Regex(
            pattern: #"season (\d+), Episode (\d+)"#, regexOptions: [.caseInsensitive]
        )
                
        let results = try! inputText.regexFindAll(regex)
        for result in results {
            print("fullMatch: '\(result.fullMatch)'")
            print("capture groups:", result.groups.map { $0!.match })
            print()
        }
        let firstResult = results[0]
        inputText.replaceSubrange(
            firstResult.range, with: "new value"
        )
        print("after replacing text: '\(inputText)'")

        

    }

    
}
