import Foundation

public extension String {
    
    /**
    Finds the first match for a regular expression in a string.
    
    - Parameters:
       - regex: An object conforming to `RegexProtocol`.
             It encapsulates information about a regular expression.
       - range: The range of self in which to search for the pattern.
             If nil (default), then the entire string is searched.
    - Throws: If the regular expression pattern is invalid
           or the number of group names does not match the number
           of capture groups. **Never** throws an error
           if no matches were found.
    - Returns: The regular expression match or nil if no match was found.
          The match contains the matched text and the range of the matched text,
          and an array of capture groups.
          Each capture group is an optional RegexGroup containing
          the matched text and the range of the matched text,
          or nil if the group was not matched.
    
    The ranges returned by this function can be used in the subscript
    for the original text, or for self.replacingCharacters(in:with:)
    to modify the text. Note that after the original text has been
    modified, the ranges may be invalid because characters may have
    shifted to difference indices.
    
    Example usage:
    ```
    var inputText = "name: Chris Lattner"
    let regex = try! Regex(
        "name: ([a-z]+) ([a-z]+)", regexOptions: [.caseInsensitive]
    )
     
    if let match = try! inputText.regexMatch(regex) {
        print("full match: '\(match.fullMatch)'")
        print("first capture group: '\(match.groups[0]!.match)'")
        print("second capture group: '\(match.groups[1]!.match)'")
        
        inputText.replaceSubrange(
            match.groups[0]!.range, with: "Steven"
        )
        
        print("after replacing text: '\(inputText)'")
    }
    ```
    Output:
    ```
    // full match: 'name: Chris Lattner'
    // first capture group: 'Chris'
    // second capture group: 'Lattner'
    // after replacing text: 'name: Steven Lattner'
    ```
    */
    func regexMatch<RegularExpression: RegexProtocol>(
        _ regex: RegularExpression,
        range: Range<String.Index>? = nil
    ) throws -> RegexMatch? {
        
        let nsRegex = try regex.asNSRegex()
        
        guard let result = nsRegex.firstMatch(
            in: self,
            options: regex.matchingOptions,
            range: NSRange(
                range ?? self.startIndex..<self.endIndex, in: self
            )
        )
        else {
            return nil
        }
        
        let nsString = self as NSString
        
        return try regexGetMatchWrapper(
            nsString: nsString,
            regexResult: result,
            regex: regex
        )
        
    }

    /**
    Finds the first match for a regular expression in a string.
    
    - Parameters:
       - pattern: A regular expression pattern.
       - regexOptions: The regular expression options, such as .caseInsensitive.
       - matchingOptions: See [NSRegularExpression.MatchingOptions](https://developer.apple.com/documentation/foundation/nsregularexpression/matchingoptions)
       - groupNames: The names of the capture groups.
       - range: The range of self in which to search for the pattern.
             If nil (default), then the entire string is searched.
    - Throws: If the regular expression pattern is invalid
           or the number of group names does not match the number
           of capture groups. **Never** throws an error
           if no matches were found.
    - Returns: The regular expression match or nil if no match was found.
          The match contains the matched text and the range of the matched text,
          and an array of capture groups.
          Each capture group is an optional RegexGroup containing
          the matched text and the range of the matched text,
          or nil if the group was not matched.
    
    The ranges returned by this function can be used in the subscript
    for the original text, or for self.replacingCharacters(in:with:)
    to modify the text. Note that after the original text has been
    modified, the ranges may be invalid because characters may have
    shifted to difference indices.
    
    Example usage:
    ```
    var inputText = "name: Chris Lattner"
    let pattern = "name: ([a-z]+) ([a-z]+)"
    
    if let match = try! inputText.regexMatch(
        pattern, regexOptions: [.caseInsensitive]
    ) {
        print("full match: '\(match.fullMatch)'")
        print("first capture group: '\(match.groups[0]!.match)'")
        print("second capture group: '\(match.groups[1]!.match)'")
        
        inputText.replaceSubrange(match.groups[0]!.range, with: "Steven")
        
        print("after replacing text: '\(inputText)'")
    }
    ```
    Output:
    ```
    // full match: 'name: Chris Lattner'
    // first capture group: 'Chris'
    // second capture group: 'Lattner'
    // after replacing text: 'name: Steven Lattner'
    ```
    */
    func regexMatch(
        _ pattern: String,
        regexOptions: NSRegularExpression.Options = [],
        matchingOptions: NSRegularExpression.MatchingOptions = [],
        groupNames: [String]? = nil,
        range: Range<String.Index>? = nil
    ) throws -> RegexMatch? {
    
        return try self.regexMatch(
            Regex(
                pattern: pattern,
                regexOptions: regexOptions,
                matchingOptions: matchingOptions,
                groupNames: groupNames
            ),
            range: range
        )
    }


    
}
