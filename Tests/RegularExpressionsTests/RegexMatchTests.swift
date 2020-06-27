import Foundation
import RegularExpressions
import XCTest

class RegexMatchTests: XCTestCase {
    
    static var allTests = [
        ("testRegexMatchWithFuzzing", testRegexMatchWithFuzzing),
        ("testRegexMatchURL", testRegexMatchURL),
        ("testRegexMatchDetails", testRegexMatchDetails),
        ("testRegexMatchWithRange", testRegexMatchWithRange),
        ("testRegexMatchAllParameters", testRegexMatchAllParameters),
        ("testRegexMatchDocs1", testRegexMatchDocs1),
        ("testRegexMatchDocs2", testRegexMatchDocs2)
    ]
    
    func testRegexMatchWithFuzzing() throws {
        let url = "https://www.sitepoint.com/demystifying-regex-with-practical-examples/"
        let pattern =
        #"^(http|https|ftp):[\/]{2}([a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,4})"# +
        #"(:[0-9]+)?\/?([a-zA-Z0-9\-\._\?\,\'\/\\\+&amp;%\$#\=~]*)"#
        
        
        try regexMatchFuzz(
            inputText: url,
            pattern: pattern,
            regexOptions: [.caseInsensitive],
            matchingOptions: [],
            groupNames: ["protocol", "host", "number", "path"]
            
        ) { match in
            
            assertRegexRangesMatch([match], inputText: url)
            
            XCTAssertEqual(
                match.fullMatch,
                "https://www.sitepoint.com/demystifying-regex-with-practical-examples/"
            )
            
            XCTAssertEqual(
                match.stringMatches,
                [
                    Opt("https"),
                    Opt("www.sitepoint.com"),
                    Opt(nil),
                    Opt("demystifying-regex-with-practical-examples/")
                ]
            )
            XCTAssertEqual(match.groups.count, 4)
            XCTAssertEqual(
                match.groupNames,
                [Opt("protocol"), Opt("host"), nil, Opt("path")]
            )

        }
    
    
    }
    
    func testRegexMatchURL() {
        
        let url = "https://www.sitepoint.com/demystifying-regex-with-practical-examples/"
        let pattern =
        #"^(http|https|ftp):[\/]{2}([a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,4})(:[0-9]+)?\/?([a-zA-Z0-9\-\._\?\,\'\/\\\+&amp;%\$#\=~]*)"#
        
        assertNoThrow {
            let nsRegexObject = try NSRegularExpression(pattern: pattern)
            XCTAssertEqual(nsRegexObject.numberOfCaptureGroups, 4)
            let regex = try Regex(pattern)
            XCTAssertEqual(try regex.numberOfCaptureGroups(), 4)
            
            let noObject = try url.regexFindAll(pattern)
            let withNSObject = try url.regexFindAll(nsRegexObject)
            let withRegex = try url.regexFindAll(regex)
            XCTAssertEqual(noObject, withNSObject)
            XCTAssertEqual(noObject, withRegex)
            XCTAssertEqual(withNSObject, withRegex)
            
        }
        
        assertNoThrow {
            
            let match1 = try url.regexMatch(pattern)
            
            var regexObject = try Regex(pattern: pattern)
            let groupNames = ["protocol", "host", "number", "path"]
            regexObject.groupNames = groupNames
            let match2 = try url.regexMatch(regexObject)
            
            let nsRegex = try NSRegularExpression(pattern: pattern)
            let match3 = try url.regexMatch(nsRegex)
            
            for match in [match1, match2, match3] {
                guard let match = match else {
                    XCTFail("should've found regex match")
                    continue
                }
                
                assertRegexRangesMatch([match], inputText: url)
                
                XCTAssertEqual(
                    match.fullMatch,
                    "https://www.sitepoint.com/demystifying-regex-with-practical-examples/"
                )
                
                XCTAssertEqual(
                    match.stringMatches,
                    [
                        Opt("https"),
                        Opt("www.sitepoint.com"),
                        Opt(nil),
                        Opt("demystifying-regex-with-practical-examples/")
                    ]
                )
                
            }
            
            if let match = try url.regexMatch(regexObject) {
                XCTAssertEqual(match.groups.count, 4)
                for i in [0, 1, 3] {
                    XCTAssertEqual(match.groups[i]?.name, groupNames[i])
                }
                XCTAssertEqual(match.groups[2]?.name, nil)
            }
            else {
                XCTFail("should've found match")
            }
            
            
        }
        
    }
        
    func testRegexMatchDetails() throws {
        
        let inputText = "Details {name: Peter, AGE: 21, seX: Male}"
        let pattern = #"NAME: (\w+), age: (\d{2}), sex: (male|female)"#

        var regexObject = try Regex(
            pattern: pattern, regexOptions: [.caseInsensitive],
            groupNames: ["name", "age", "sex"]
        )
        XCTAssertEqual(regexObject.groupNames, ["name", "age", "sex"])
        XCTAssertEqual(regexObject.groupNames?.count, 3)
        regexObject.groupNames = nil
        XCTAssertEqual(regexObject.groupNames, nil)
        regexObject.groupNames = ["name", "age", "sex"]
        XCTAssertEqual(regexObject.groupNames, ["name", "age", "sex"])
        XCTAssertEqual(regexObject.groupNames?.count, 3)
        
        let match1 = try inputText.regexMatch(regexObject)
        
        
        let match2 = try inputText.regexMatch(
            pattern, regexOptions: [.caseInsensitive]
        )
        
        let nsRegex = try NSRegularExpression(
            pattern: pattern, options: [.caseInsensitive]
        )
        let match3 = try inputText.regexMatch(nsRegex)
        
        
        for (n, match) in [match1, match2, match3].enumerated() {
            guard let match = match else {
                XCTFail("should've found regex match")
                continue
            }
            
            assertRegexRangesMatch([match], inputText: inputText)
            
            XCTAssertEqual(match.fullMatch, "name: Peter, AGE: 21, seX: Male")
            
            XCTAssertEqual(
                match.stringMatches,
                [Opt("Peter"), Opt("21"), Opt("Male")]
            )
            
            let replaced = inputText.replacingCharacters(in: match.range, with: "null")
            XCTAssertEqual(replaced, "Details {null}")
            
            if n != 0 { continue }
            
            XCTAssertEqual(match.groups.count, 3)
            XCTAssertEqual(match.groupNames, ["name", "age", "sex"])
            
            
        }
        
    }
    
    func testRegexMatchName() {
        assertNoThrow {
            
            let inputText = "name: Chris Lattner"
            let pattern = "name: ([a-z]+) ([a-z]+)"
            
            let match1 = try inputText.regexMatch(
                pattern,
                regexOptions: [.caseInsensitive],
                groupNames: ["first name", "last name"]
            )
            
            let (nsRegex, regex) = try makeBothRegexObjects(pattern, [.caseInsensitive])
            let match2 = try inputText.regexMatch(regex)
            let match3 = try inputText.regexMatch(nsRegex)
            
            for (i, match) in [match1, match2, match3].enumerated() {
                
                guard let match = match else {
                    XCTFail("should've found match")
                    continue
                }
                
                if i == 0 {
                    XCTAssertEqual(match.groupNames, ["first name", "last name"])
                    XCTAssertEqual(match.group(named: "first name")?.match, "Chris")
                    XCTAssertEqual(match.group(named: "last name")?.match, "Lattner")
                }
                
                
                print("full match: '\(match.fullMatch)'")
                XCTAssertEqual(match.fullMatch, "name: Chris Lattner")
                
                XCTAssertEqual(match.groups[0]!.match, "Chris")
                XCTAssertEqual(match.groups[1]!.match, "Lattner")
                
                var copy = inputText
                copy.replaceSubrange(match.groups[0]!.range, with: "Steven")
                XCTAssertEqual(copy, "name: Steven Lattner")
                
                
            }
        }
    }
 
    func testRegexMatchWithRange() {
        assertNoThrow {
            
            let inputText = "Peter Schorn"
            let stringRange = inputText.range(of: "Peter")!
            let match = try inputText.regexMatch("Schorn", range: stringRange)
            XCTAssert(match == nil)
            
            if let match2 = try inputText.regexMatch("Peter", range: stringRange) {
                XCTAssert(match2.fullMatch == "Peter")
                assertRegexRangesMatch([match2], inputText: inputText)
            }
            else {
                XCTFail("Should've found match")
            }
        }
    }
    
    func testRegexMatchAllParameters() throws {
        print()
        
        let inputText = """
        Man selects only for his own good: \
        Nature only for that of the being which she tends.
        """
        
        let pattern = #"Only for his OWN (\w+):"#
        let searchRange = inputText.range(
            of: "Man selects only for his own good: Nature"
        )!
        
        let regex = try! Regex(
            pattern: pattern,
            regexOptions: [.caseInsensitive],
            groupNames: ["word"]
        )
        
        if let match = try inputText.regexMatch(regex, range: searchRange) {
            assertRegexRangesMatch([match], inputText: inputText)
            XCTAssertEqual(match.fullMatch, "only for his own good:")
            XCTAssertEqual(match.group(named: "word")?.match, Opt("good"))
        }
        else {
            XCTFail("should've found match")
        }
        
        
    }
    
    func testRegexMatchDocs1() throws {
        
        let inputText = """
        Man selects only for his own good: \
        Nature only for that of the being which she tends.
        """
        
        let pattern = #"Man selects ONLY FOR HIS OWN (\w+)"#
        let searchRange =
                (inputText.startIndex)
                ..<
                (inputText.index(inputText.startIndex, offsetBy: 40))
        
        let match = try inputText.regexMatch(
            pattern,
            regexOptions: [.caseInsensitive],
            matchingOptions: [.anchored],
            groupNames: ["word"],
            range: searchRange
        )
        
        if let match = match {
            // print("full match:", match.fullMatch)
            // print("capture group:", match.group(named: "word")!.match)
            assertRegexRangesMatch([match], inputText: inputText)
            XCTAssertEqual(match.fullMatch, "Man selects only for his own good")
            XCTAssertEqual(match.group(named: "word")?.match, "good")
        }
        else {
            XCTFail("should've found match")
        }



    }
    
    func testRegexMatchDocs2() throws {
        
        var inputText = "name: Chris Lattner"
        let regex = try! Regex(
            pattern: "name: ([a-z]+) ([a-z]+)",
            regexOptions: [.caseInsensitive],
            groupNames: ["first name", "last name"]
        )
         
        if let match = try inputText.regexMatch(regex) {
            assertRegexRangesMatch([match], inputText: inputText)
            XCTAssertEqual(match.fullMatch, "name: Chris Lattner")
            XCTAssertEqual(
                match.group(named: "first name")!.match,
                "Chris"
            )
            XCTAssertEqual(
                match.group(named: "last name")!.match,
                "Lattner"
            )
            // print("full match: '\(match.fullMatch)'")
            // print("first capture group: '\(match.group(named: "first name")!.match)'")
            // print("second capture group: '\(match.group(named: "last name")!.match)'")
            
            inputText.replaceSubrange(
                match.groups[0]!.range, with: "Steven"
            )
            
            // print("after replacing text: '\(inputText)'")
            XCTAssertEqual(inputText, "name: Steven Lattner")
        }
        else {
            XCTFail("should've found matches")
        }
        
        // full match: 'name: Chris Lattner'
        // first capture group: 'Chris'
        // second capture group: 'Lattner'
        // after replacing text: 'name: Steven Lattner'

    }
    
    
}
