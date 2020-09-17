import Foundation


public extension String {
    
    /**
     Finds all matches for a regular expression in a string.
     
     - Parameters:
       - regex: An object conforming to `RegexProtocol`.
             It encapsulates information about a regular expression.
       - range: The range of self in which to search for the pattern.
             If nil (default), then the entire string is searched.
     - Throws: If the regular expression pattern is invalid
           or the number of group names does not match the number
           of capture groups. **Never** throws an error
           if no matches are found.
     - Returns: An array of matches, each of which contains the full match,
           the range of the full match in the source string,
           and an array of the capture groups. Returns an empty
           array if no matches were found.
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
     var inputText = "season 8, EPISODE 5; season 5, episode 20"

     // create the regular expression object
     let regex = try Regex(
         pattern: #"season (\d+), Episode (\d+)"#,
         regexOptions: [.caseInsensitive],
         groupNames: ["season number", "episode number"]
         // the names of the capture groups
     )
             
     let results = try inputText.regexFindAll(regex)
     for result in results {
         print("fullMatch: '\(result.fullMatch)'")
         print("capture groups:")
         for captureGroup in result.groups {
             print("    \(captureGroup!.name!): '\(captureGroup!.match)'")
         }
         print()
     }

     let firstResult = results[0]
     // perform a replacement on the first full match
     inputText.replaceSubrange(
         firstResult.range, with: "new value"
     )

     print("after replacing text: '\(inputText)'")
     ```
     Output:
     ```
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
     ```
     */
    func regexFindAll<RegularExpression: RegexProtocol>(
        _ regex: RegularExpression,
        range: Range<String.Index>? = nil
    ) throws -> [RegexMatch] {
        
        let nsString = self as NSString
        let nsRegex = try regex.asNSRegex()
        
        let regexResults = nsRegex.matches(
            in: self,
            options: regex.matchingOptions,
            range: NSRange(
                range ?? self.startIndex..<self.endIndex, in: self
            )
        )
        
        var allMatches: [RegexMatch] = []
        
        // for each full match
        for result in regexResults {
            allMatches.append(
                try regexGetMatchWrapper(
                    nsString: nsString,
                    regexResult: result,
                    regex: regex
                )
            )
        }
        
        return allMatches
    }
    
    /**
     Finds all matches for a regular expression in a string.
     
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
     - Returns: An array of matches, each of which contains the full match,
           the range of the full match in the source string,
           and an array of the capture groups. Returns an empty
           array if no matches were found.
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
     var inputText = "season 8, EPISODE 5; season 5, episode 20"

     let results = try inputText.regexFindAll(
         #"season (\d+), Episode (\d+)"#,
         regexOptions: [.caseInsensitive],
         groupNames: ["season number", "episode number"]
         // the names of the capture groups
     )
     for result in results {
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
     ```
     Output:
     ```
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
     */
    func regexFindAll(
        _ pattern: String,
        regexOptions: NSRegularExpression.Options = [],
        matchingOptions: NSRegularExpression.MatchingOptions = [],
        groupNames: [String]? = nil,
        range: Range<String.Index>? = nil
    ) throws -> [RegexMatch] {
        
        return try self.regexFindAll(
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
