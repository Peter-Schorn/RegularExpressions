#if canImport(XCTest)

import Foundation
import RegularExpressions
import XCTest

final class RegexFindAllTests: XCTestCase {
    
    static var allTests = [
        ("testRegexFindAll1", testRegexFindAll1),
        ("testRegexFindAll2", testRegexFindAll2),
        ("testRegexFindAll3", testRegexFindAll3),
        ("testRegexFindAllDocs1", testRegexFindAllDocs1)
    ]
    
    func testRegexFindAll1() throws {
        
        let inputText = "season 8, EPISODE 5; season 5, episode 20"
        let pattern = #"season (\d+), Episode (\d+)"#
        let groupNames = ["SEASON", "EPISODE"]
        
        let results = try inputText.regexFindAll(
            pattern,
            regexOptions: [.caseInsensitive],
            groupNames: groupNames
        )
        XCTAssertEqual(results.count, 2)
        assertRegexRangesMatch(results, inputText: inputText)
        for result in results {
            XCTAssertEqual(result.groupNames, ["SEASON", "EPISODE"])
        }
        
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

    }
    
        
    func testRegexFindAll2() throws {
     
        let inputText = "season 8, EPISODE 5; season 5, episode 20"
        let pattern = #"season (\d+), Episode (\d+)"#
        let groupNames = ["SEASON", "EPISODE"]
        
        var calledFuzzHanlder = false
        
        try regexFindAllFuzz(
            inputText: inputText,
            pattern: pattern,
            regexOptions: [.caseInsensitive],
            matchingOptions: [],
            groupNames: groupNames,
            range: nil
        ) { results in
            
            XCTAssertEqual(results.count, 2)
            assertRegexRangesMatch(results, inputText: inputText)
            calledFuzzHanlder = true
           
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
        
        XCTAssert(calledFuzzHanlder)
        
    }
    
    func testRegexFindAll3() {
    
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
    
    func testRegexFindAllDocs1() throws {
        
        var inputText = "season 8, EPISODE 5; season 5, episode 20"

        let regex = try Regex(
            pattern: #"season (\d+), Episode (\d+)"#,
            regexOptions: [.caseInsensitive],
            groupNames: ["season number", "episode number"]
            // the names of the capture groups
        )
        
        let expectedFullMatches = ["season 8, EPISODE 5", "season 5, episode 20"]
        let expectedCaptureGroups = [["8", "5"], ["5", "20"]]
            
        let results = try inputText.regexFindAll(regex)
        XCTAssert(results.count == 2)
        assertRegexRangesMatch(results, inputText: inputText)
        for (i, result) in results.enumerated() {
            XCTAssertEqual(result.fullMatch, expectedFullMatches[i])
            XCTAssertEqual(result.groupNames, ["season number", "episode number"])
            XCTAssertEqual(result.stringMatches, expectedCaptureGroups[i])
            
            print("fullMatch: '\(result.fullMatch)'")
            print("capture groups:")
            for captureGroup in result.groups {
                print("    '\(captureGroup!.name!)': '\(captureGroup!.match)'")
            }
            print()
        }

        let firstResult = results[0]
        // perform a replacement on the first full match
        inputText.replaceSubrange(
            firstResult.range, with: "new value"
        )

        print("after replacing text: '\(inputText)'")
        XCTAssertEqual(inputText, "new value; season 5, episode 20")

        // fullMatch: 'season 8, EPISODE 5'
        // capture groups:
        //     'season number': '8'
        //     'episode number': '5'
        //
        // fullMatch: 'season 5, episode 20'
        // capture groups:
        //     'season number': '5'
        //     'episode number': '20'
        //
        // after replacing text: 'new value; season 5, episode 20'
        
    }
    
    func testRegexFindAllDocs2() throws {
        
        var inputText = "season 8, EPISODE 5; season 5, episode 20"

        let expectedFullMatches = ["season 8, EPISODE 5", "season 5, episode 20"]
        let expectedCaptureGroups = [["8", "5"], ["5", "20"]]
                
        let results = try inputText.regexFindAll(
            #"season (\d+), Episode (\d+)"#,
            regexOptions: [.caseInsensitive],
            groupNames: ["season number", "episode number"]
            // the names of the capture groups
        )
        XCTAssert(results.count == 2)
        assertRegexRangesMatch(results, inputText: inputText)
        for (i, result) in results.enumerated() {
            XCTAssertEqual(result.fullMatch, expectedFullMatches[i])
            XCTAssertEqual(result.groupNames, ["season number", "episode number"])
            XCTAssertEqual(result.stringMatches, expectedCaptureGroups[i])
            // print("fullMatch: '\(result.fullMatch)'")
            // print("capture groups:")
            // for captureGroup in result.groups {
            //     print("    '\(captureGroup!.name!)': '\(captureGroup!.match)'")
            // }
            // print()
        }

        let firstResult = results[0]
        // perform a replacement on the first full match
        inputText.replaceSubrange(
            firstResult.range, with: "new value"
        )

        // print("after replacing text: '\(inputText)'")
        XCTAssertEqual(inputText, "new value; season 5, episode 20")

        // fullMatch: 'season 8, EPISODE 5'
        // capture groups:
        //     'season number': '8'
        //     'episode number': '5'
        //
        // fullMatch: 'season 5, episode 20'
        // capture groups:
        //     'season number': '5'
        //     'episode number': '20'
        //
        // after replacing text: 'new value; season 5, episode 20'
        
    }

    
}


#endif
