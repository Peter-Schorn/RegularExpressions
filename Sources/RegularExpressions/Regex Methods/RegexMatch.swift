import Foundation

public extension String {
    
    /**
     Finds the first match for a regular expression in a string.
    
     - Parameters:
       - regex: An object conforming to `RegexProtocol`.
             It encapsulates information about a regular expression.
       - range: The range of self in which to search for the pattern.
             If nil (default), then the entire string is searched.
     - Returns: The regular expression match or nil if no match was found.
           The match contains the matched string and the range of the matched string,
           and an array of capture groups.
           Each capture group is an optional RegexGroup containing
           the matched string, the range of the matched string and the name of
           the capture group, or nil if it was not named.
     - Throws: If the regular expression pattern is invalid
           or the number of group names does not match the number
           of capture groups. **Never** throws an error
           if no matches were found.
     - Warning: The ranges of the matches and capture groups may be
           invalidated if you mutate the source string. Use [String.regexsub](https://github.com/Peter-Schorn/RegularExpressions/blob/master/README.md#performing-regular-expression-replacements-1)
           to perform multiple replacements.
    
     The ranges returned by this function can be used in the subscript
     for the original string, or for self.replacingCharacters(in:with:)
     to modify the string.
    
     Example usage:
     ```
     var inputText = "name: Chris Lattner"
     
     // If you use comments in the pattern,
     // you MUST use `.allowCommentsAndWhitespace`
     // for the `regexOptions`
     let pattern = #"""
     name:     # the literal string 'name'
     \s+       # one more more whitespace characters
     ([a-z]+)  # one or more lowercase letters
     \s+       # one more more whitespace characters
     ([a-z]+)  # one or more lowercase letters
     """#
     
     // create the regular expression object
     let regex = try! Regex(
         pattern: pattern,
         regexOptions: [.caseInsensitive, .allowCommentsAndWhitespace],
         groupNames: ["first name", "last name"]
         // the names of the capture groups
     )
     
     // check for a match
     if let match = try inputText.regexMatch(regex) {
         print("full match: '\(match.fullMatch)'")
         print("first capture group:",  match.group(named: "first name")!.match)
         print("second capture group:", match.group(named: "last name")!.match)
     
         // perform a replacement on the first capture group
         inputText.replaceSubrange(
             match.groups[0]!.range, with: "Steven"
         )
     
         print("after replacing text: '\(inputText)'")
     }
     ```
     Output:
     ```
     // full match: 'name: Chris Lattner'
     // first capture group: Chris
     // second capture group: Lattner
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
           The match contains the matched string and the range of the matched string,
           and an array of capture groups.
           Each capture group is an optional RegexGroup containing
           the matched string, the range of the matched string and the name of
           the capture group, or nil if it was not named.
     - Warning: The ranges of the matches and capture groups may be
           invalidated if you mutate the source string. Use [String.regexsub](https://github.com/Peter-Schorn/RegularExpressions/blob/master/README.md#performing-regular-expression-replacements-1)
           to perform multiple replacements.
    
     The ranges returned by this function can be used in the subscript
     for the original string, or for self.replacingCharacters(in:with:)
     to modify the string.
     
     Example usage:
     ```
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
         matchingOptions: [.anchored],  // anchor matches to the beginning of the string
         groupNames: ["word"],  // the names of the capture groups
         range: searchRange  // the range of the string in which to search for the pattern
     )
     if let match = match {
         print("full match:", match.fullMatch)
         print("capture group:", match.group(named: "word")!.match)
     }
     ```
     Output:
     ```
     // full match: Man selects only for his own good
     // capture group: good
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
