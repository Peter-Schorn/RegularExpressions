import Foundation


public extension String {
    
    /**
    Finds the first match for a regular expression pattern in a string.
    
    - Parameters:
       - nsRegularExpression: An NSRegularExpression.
             **Note:** This library defines a
             `typealias Regex = NSRegularExpression`.
       - range: The range of self in which to search for the pattern.
             If nil (default), then the entire string is searched.
    
    - Throws: If the regular expression pattern is invalid
              (e.g., unbalanced paraentheses). **Never** throws an error
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
    // Remember, there is a
    // `public typealias Regex = NSRegularExpression`.
    var inputText = "name: Chris Lattner"
    let regex = try! Regex(
        "name: ([a-z]+) ([a-z]+)", [.caseInsensitive]
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
    func regexMatch(
        _ nsRegularExpression: NSRegularExpression,
        range: Range<String.Index>? = nil,
        groupNames: [String]? = nil
    ) throws -> RegexMatch? {
        
        guard let result = nsRegularExpression.firstMatch(
            in: self,
            range: NSRange(
                range ?? self.startIndex..<self.endIndex, in: self
            )
        )
        else {
            return nil
        }
        
        let nsString = self as NSString
        
        // MARK: Begin dupication
        let regexFullMatch = nsString.substring(
            with: result.range(at: 0)
        )
        let regexRange = Range(result.range, in: self)!
        var regexGroups: [RegexGroup?] = []
        
        if let groupNames = groupNames {
            // throw an error if the number of group names
            // does not match the number of capture groups.
            if groupNames.count != result.numberOfRanges - 1 {
                throw RegexError.groupNamesCountDoesntMatch(
                    captureGroups: regexGroups.count,
                    groupNames: groupNames.count
                )
            }
        }
        
        // for each of the capture groups.
        for match in 1..<result.numberOfRanges {
            
            let groupName = groupNames?[match - 1]
            
            let nsRange = result.range(at: match)
            
            // if the capture group is nil because it was not matched.
            // this can occur if the capture group is declared as optional.
            if nsRange.location == NSNotFound {
                regexGroups.append(nil)
            }
            else {
                // append the capture group text and the range thereof
                let range = Range(nsRange, in: self)!
                let capturedText = nsString.substring(with: nsRange)
                regexGroups.append(
                    RegexGroup(
                        match: capturedText,
                        range: range,
                        name: groupName
                    )
                )
            }
            
        }
        // MARK: End duplication
        
        return RegexMatch(
            fullMatch: regexFullMatch,
            range: regexRange,
            groups: regexGroups
        )
        
    }

    /**
    Finds the first match for a regular expression pattern in a string.
    
    - Parameters:
       - pattern: The regular expression pattern.
       - options: The regular expression options, such as .caseInsensitive
       - range: The range of self in which to search for the pattern.
             If nil (default), then the entire string is searched.
    
    - Throws: If the regular expression pattern is invalid
              (e.g., unbalanced paraentheses). **Never** throws an error
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
    
    if let match = try! inputText.regexMatch(pattern, [.caseInsensitive]) {
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
        _ options: NSRegularExpression.Options = [],
        range: Range<String.Index>? = nil
    ) throws -> RegexMatch? {
    
        return try self.regexMatch(
            NSRegularExpression(
                pattern: pattern, options: options
            ),
            range: range
        )
    }


    
}
