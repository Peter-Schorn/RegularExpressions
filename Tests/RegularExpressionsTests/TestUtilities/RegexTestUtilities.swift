import Foundation
import RegularExpressions
import XCTest


/// Assert that the reported ranges of the matches in the original text
/// are correct.
func assertRegexRangesMatch(
    _ regexMatches: [RegularExpressions.RegexMatch],
    inputText: String,
    file: StaticString = #file, line: UInt = #line
) {

    for match in regexMatches {
        XCTAssertEqual(
            match.fullMatch, String(inputText[match.range]),
            file: file, line: line
        )
        
        for group in match.groups.removeIfNil() {
            XCTAssertEqual(
                group.match, String(inputText[group.range]),
                file: file, line: line
            )
        }
    }

}

extension RegexMatch {
    
    /// Returns the names of all the capture groups.
    var groupNames: [String?] {
        return self.groups.map { $0?.name }
    }
    
    /// Returns all the capture group strings.
    var stringMatches: [String?] {
        return self.groups.map { $0?.match }
    }
    
}

/// (NSRegularExpression, Regex)
/// Make a NSRegularExpression and Regex
/// from the same pattern and options
func makeBothRegexObjects(
    _ pattern: String,
    _ regexOptions: NSRegularExpression.Options
) throws -> (NSRegularExpression, Regex) {
    
    let nsRegex = try NSRegularExpression(
        pattern: pattern, options: regexOptions
    )
    var regex: Regex
    if Bool.random() {
        regex = try Regex(pattern: pattern, regexOptions: regexOptions)
    }
    else {
        regex = try Regex(pattern, regexOptions)
    }
    
    fuzzRegexObject(&regex)
    
    return (nsRegex, regex)
    
}


/// Construct regex objects using various initializers and other techniques.
func makeAllRegexObjects(
    pattern: String,
    regexOptions: NSRegularExpression.Options = [],
    matchingOptions: NSRegularExpression.MatchingOptions = [],
    groupNames: [String]? = nil,
    file: StaticString = #file, line: UInt = #line
) throws -> [Regex] {
    
    var regex1 = try Regex(
        pattern: pattern,
        regexOptions: regexOptions,
        matchingOptions: matchingOptions,
        groupNames: groupNames
    )
    
    let nsRegexTemp = try NSRegularExpression(pattern: pattern, options: regexOptions)
    var regex2 = Regex(
        nsRegularExpression: nsRegexTemp,
        matchingOptions: matchingOptions,
        groupNames: groupNames
    )
    
    var regex3 = try Regex(pattern, regexOptions)
    regex3.matchingOptions = matchingOptions
    regex3.groupNames = groupNames

    fuzzRegexObject(&regex1)
    fuzzRegexObject(&regex2)
    fuzzRegexObject(&regex3)
    
    return [regex1, regex2, regex3]
    
}


/// Applies various transformations to the objects
/// and then reverses them so that the objects are the same.
func fuzzRegexObject(_ regex: inout Regex) {
    for _ in 0...5 {
        regex.groupNames?.append("asdfsadf")
        if regex.groupNames != nil {
            regex.groupNames!.remove(at: regex.groupNames!.count - 1)
        }
        let temp1 = regex.matchingOptions
        regex.matchingOptions = []
        regex.matchingOptions = temp1
        let temp2 = regex.pattern
        regex.pattern = "___"
        regex.pattern = temp2
    }
}


func regexFindAllFuzz(
    inputText: String,
    pattern: String,
    regexOptions: NSRegularExpression.Options,
    matchingOptions: NSRegularExpression.MatchingOptions,
    groupNames: [String]?,
    range: Range<String.Index>?,
    file: StaticString = #file, line: UInt = #line,
    matchHandler: ([RegexMatch]) -> Void
) throws {

    let regexObjects = try makeAllRegexObjects(
        pattern: pattern,
        regexOptions: regexOptions,
        matchingOptions: matchingOptions,
        groupNames: groupNames
    )
    
    var matchesArray: [[RegexMatch]] = []
    
    for object in regexObjects {
        let findAllObject = try inputText.regexFindAll(object, range: range)
        matchesArray.append(findAllObject)
    }
    
    let findAllNoObject = try inputText.regexFindAll(
        pattern,
        regexOptions: regexOptions,
        matchingOptions: matchingOptions,
        groupNames: groupNames,
        range: range
    )
    matchesArray.append(findAllNoObject)
    
    for matches in matchesArray {
        matchHandler(matches)
    }

}



/// Performs practically equivalent tests on multiple methods/overloads.
/// Use for single regular expression matches.
func regexMatchFuzz(
    inputText: String,
    pattern: String,
    regexOptions: NSRegularExpression.Options,
    matchingOptions: NSRegularExpression.MatchingOptions,
    groupNames: [String]?,
    range: Range<String.Index>? = nil,
    file: StaticString = #file, line: UInt = #line,
    matchHandler: (RegexMatch) -> Void
) throws {
    
    let regexObjects = try makeAllRegexObjects(
        pattern: pattern,
        regexOptions: regexOptions,
        matchingOptions: matchingOptions,
        groupNames: groupNames
    )
    
    // use regexFindAll, but only return the first match.
    // should be equivalent to regexMatch.
    let findAllFirsts = try regexObjects.compactMap { object -> RegexMatch? in
        if let match = try inputText.regexFindAll(object, range: range)[safe: 0] {
            return match
        }
        XCTFail("failed to find match")
        return nil
        
    }
    
    let regexMatches = try regexObjects.compactMap { object -> RegexMatch? in
        if let match = try inputText.regexMatch(object, range: range) {
            return match
        }
        XCTFail("failed to find match")
        return nil
    }
    
    // don't use the objects. create them in the regexMatch initializer.
    let noObjectRegexMatches = try (0...1).compactMap { object -> RegexMatch? in
        if let match = try inputText.regexMatch(
            pattern,
            regexOptions: regexOptions,
            matchingOptions: matchingOptions,
            groupNames: groupNames,
            range: range
        ) {
            return match
        }
        XCTFail("failed to find match")
        return nil
    }
    
    let noObjectFindAllFirsts = try (0...1).compactMap { object -> RegexMatch? in
        if let match = try inputText.regexFindAll(
            pattern,
            regexOptions: regexOptions,
            matchingOptions: matchingOptions,
            groupNames: groupNames,
            range: range
        )[safe: 0] {
            return match
        }
        XCTFail("failed to find match")
        return nil
    }
    
    for match in [
        findAllFirsts, regexMatches, noObjectRegexMatches, noObjectFindAllFirsts
    ].flatMap({ $0 }) {
        matchHandler(match)
    }
    

}


/// Abstract over overloads.
func regexReplacerFuzz(
    inputText: String,
    pattern: String,
    regexOptions: NSRegularExpression.Options,
    matchingOptions: NSRegularExpression.MatchingOptions,
    groupNames: [String]?,
    range: Range<String.Index>?,
    file: StaticString = #file, line: UInt = #line,
    replacer: (_ matchIndex: Int, RegexMatch) -> String?,
    checkStringHandler: (String) -> Void
) throws {
    
    let replacedString = try inputText.regexSub(
        pattern,
        regexOptions: regexOptions,
        matchingOptions: matchingOptions,
        groupNames: groupNames,
        range: range,
        replacer: replacer
    )
    checkStringHandler(replacedString)

    var copy = inputText
    try copy.regexSubInPlace(
        pattern,
        regexOptions: regexOptions,
        matchingOptions: matchingOptions,
        groupNames: groupNames,
        range: range,
        replacer: replacer
    )
    checkStringHandler(copy)
    
    let regexObjects = try makeAllRegexObjects(
        pattern: pattern,
        regexOptions: regexOptions,
        matchingOptions: matchingOptions,
        groupNames: groupNames
    )
    
    for object in regexObjects {
        let replacedString = try inputText.regexSub(
            object, range: range, replacer: replacer
        )
        checkStringHandler(replacedString)
        
        var copy = inputText
        try copy.regexSubInPlace(
            object, range: range, replacer: replacer
        )
        checkStringHandler(copy)
        

    }
    
    
    
    
}
