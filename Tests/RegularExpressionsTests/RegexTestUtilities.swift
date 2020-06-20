import Foundation
import RegularExpressions
import XCTest


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
