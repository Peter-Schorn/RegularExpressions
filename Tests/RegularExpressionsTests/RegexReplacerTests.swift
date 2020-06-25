import Foundation
import RegularExpressions
import XCTest

final class RegexReplacerTests: XCTestCase {
    
    static var allTests = [
        ("testReplacing", testReplacing),
        ("testCapturreGroupReplacing", testCapturreGroupReplacing),
        ("testReplacingShort", testReplacingShort)
    ]
    
    func testReplacing() throws {
        
        let longText = """
        NAME = "peter", age = "21" end 1
        name = "eric", age = "51" end 2
        name = "sally", age = "25" end 3
        name = "chris", age = "34" end 4
        name = "beyond", age = "500" end 5
        """
        
        let searchRange = longText.range(of: """
        NAME = "peter", age = "21" end 1
        name = "eric", age = "51" end 2
        name = "sally", age = "25" end 3
        name = "chris", age = "34" end 4
        """)!
        
        
        let expectedReplacement = """
        NAME = "'name peter'", age = "'age 21'" end 1
        name = "eric", age = "'age 51'" end 2
        redacted 3
        name = "chris", age = "34" end 4
        name = "beyond", age = "500" end 5
        """
        
        let expectedAnchoredReplacement = """
        ["peter", "21"] 1
        name = "eric", age = "51" end 2
        name = "sally", age = "25" end 3
        name = "chris", age = "34" end 4
        name = "beyond", age = "500" end 5
        """
        
        let expectedMatches = [
            #"NAME = "peter", age = "21" end"#,
            #"name = "eric", age = "51" end"#,
            #"name = "sally", age = "25" end"#,
            #"name = "chris", age = "34" end"#
        ]
        
        
        
        
        let pattern = #"namE = "(\w+)", age = "(\d+)" end"#
        let groupNames = ["name", "age"]
        
        func replacer(
            matchIndex: Int, match: RegexMatch
        ) -> String? {
            assertRegexRangesMatch([match], inputText: longText)
            XCTAssertEqual(longText, String(match.sourceString))
            XCTAssertEqual(match.groupNames, ["name", "age"])
            XCTAssertEqual(match.fullMatch, expectedMatches[matchIndex])
            if matchIndex == 2 { return "redacted" }
            if matchIndex == 3 { return nil }
        
            // print("fullMatch", match.fullMatch)
            let result = match.replaceGroups { indx, group in
                
                XCTAssertEqual(group.name, groupNames[indx])
                
                if matchIndex == 1 && indx == 0 {
                    XCTAssertEqual(match.fullMatch, #"name = "eric", age = "51" end"#)
                    return nil
                }
                return "'\(group.name!) \(group.match)'"
            }
            // print("replacer result:")
            // print(result)
            // print("---------------------------------\n")
            return result
        
            // return "replacement" + match.groups[0]!.match
            
        }
        
        func anchoredReplacer(
            matchIndex: Int, match: RegexMatch
        ) -> String? {
            assertRegexRangesMatch([match], inputText: longText)
            XCTAssertEqual(matchIndex, 0)
            XCTAssertEqual(match.fullMatch, #"NAME = "peter", age = "21" end"#)
            
            let groups = match.groups.compactMap { $0?.match }
            
            return "\(groups)"
            
        }
        
        try regexReplacerFuzz(
            inputText: longText,
            pattern: pattern,
            regexOptions: [.caseInsensitive],
            matchingOptions: [],
            groupNames: groupNames,
            range: searchRange,
            replacer: replacer(matchIndex:match:)
        ) { replacedString in
                    
            XCTAssertEqual(replacedString, expectedReplacement)
        }
        
        try regexReplacerFuzz(
            inputText: longText,
            pattern: pattern,
            regexOptions: [.caseInsensitive],
            matchingOptions: [.anchored],
            groupNames: groupNames,
            range: searchRange,
            replacer: anchoredReplacer(matchIndex:match:)
        ) { replacedString in
                    
            XCTAssertEqual(replacedString, expectedAnchoredReplacement)
        }
        
        
        
        
    }
    
    
    func testReplacingShort() throws {
        
        let inputText = """
        namE: sally, id: 1
        NAme: joHN, id: 2
        name: beyond, id: 3
        """
        
        let expectedReplacement = """
        0 { NAME: SALLY, ID: 1 }
        1 { NAME: JOHN, ID: 2 }
        name: beyond, id: 3
        """
        
        // expected when the matches are anchored to the beginning of the string
        let firstMatchExpectedReplacement = """
        0 { NAME: SALLY, ID: 1 }
        NAme: joHN, id: 2
        name: beyond, id: 3
        """
        
        let pattern = #"nAme: (\w+), id: (\d+)"#
        let groupNames = ["name", "id"]
        let searchRange = inputText.range(of: """
        namE: sally, id: 1
        NAme: joHN, id: 2
        """
        )!
        
        func replacer(indx: Int, match: RegexMatch) -> String? {
            assertRegexRangesMatch([match], inputText: inputText)
            XCTAssertEqual(match.groupNames, ["name", "id"])
            XCTAssertEqual(match.groups[0]?.name, "name")
            XCTAssertEqual(match.groups[1]?.name, "id")
            
            
            return "\(indx) { \(match.fullMatch.uppercased()) }"
        }
        
        try regexReplacerFuzz(
            inputText: inputText,
            pattern: pattern,
            regexOptions: [.caseInsensitive],
            matchingOptions: [],
            groupNames: groupNames,
            range: searchRange,
            replacer: replacer(indx:match:)
        ) { replacedString in
            
            XCTAssertEqual(replacedString, expectedReplacement)
                
        }
        
        // anchor matches to the beginning of the string
        try regexReplacerFuzz(
            inputText: inputText,
            pattern: pattern,
            regexOptions: [.caseInsensitive],
            matchingOptions: [.anchored],
            groupNames: groupNames,
            range: nil,
            replacer: { indx, match in
                "\(indx) { \(match.fullMatch.uppercased()) }"
            }
        ) { replacedString in
            
            XCTAssertEqual(replacedString, firstMatchExpectedReplacement)
                
        }
        
        

    }
    
    func testCapturreGroupReplacing() throws {
        
        let inputText = "name: peter, id: 35"
        let pattern = #"name: (\w+), id: (\d+)"#
        
        guard let match = try inputText.regexMatch(pattern) else {
            XCTFail("should've found match")
            return
        }
        
        let replacedMatch = match.replaceGroups { indx, group in
            if indx == 0 { return "captured name" }
            if indx == 1 { return "capured id" }
            return nil
        }
        
        XCTAssertEqual(replacedMatch, "name: captured name, id: capured id")
        

    }
    
    func testCaptureGroupReplacerDocs() throws {
        
        let inputText = "name: Peter, id: 35, job: programmer"
        let pattern = #"name: (\w+), id: (\d+)"#
        let groupNames = ["name", "id"]
        
        let match = try! inputText.regexMatch(
            pattern, groupNames: groupNames
        )!
        
        let replacedMatch = match.replaceGroups { indx, group in
            if group.name == "name" { return "Steven" }
            if group.name == "id" { return "55" }
            return nil
        }
        
        XCTAssertEqual(match.fullMatch, "name: Peter, id: 35")
        XCTAssertEqual(replacedMatch, "name: Steven, id: 55")
        
        // print(replacedMatch)
        // replacedMatch = name:

    }
    
}
