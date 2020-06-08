import Foundation


public extension String {
    
    /**
     Finds the first match for a regular expression pattern in a string.
     
     Same as String.regexFindAll but only returns the first match.
     See String.regexFindAll for example usage and full discussion.
     
     - Parameters:
        - pattern: Regular expression pattern.
        - options: Regular expression options, such as .caseInsensitive
     
     - Throws: If the regular expression pattern is invalid
               (e.g., unbalanced paraentheses). **Never** throws an error
               if no matches were found.
     
     - Returns: The regular expression match or nil if no match was found.
     */
    func regexMatch(
        _ pattern: String,
        _ options: NSRegularExpression.Options = []
    ) throws -> RegexMatch? {
        
        let regex = try NSRegularExpression(pattern: pattern, options: options)
        
        let nsString = self as NSString

        if let result = regex.firstMatch(
            in: self, range: NSRange(location: 0, length: self.count)
        ) {
        
            let regexFullMatch = nsString.substring(
                with: result.range(at: 0)
            )
            let regexRange = Range(result.range, in: self)!
            var regexGroups: [RegexGroup?] = []
            
            // for each of the capture groups.
            for match in 1..<result.numberOfRanges {
                let nsRange = result.range(at: match)
                
                // if the capture group is nil because it was not matched.
                // this can occur if the capture group is marked as optional.
                if nsRange.location == NSNotFound {
                    regexGroups.append(nil)
                }
                else {
                    // append the capture group text and the range thereof
                    let range = Range(nsRange, in: self)!
                    let capturedText = nsString.substring(with: nsRange)
                    regexGroups.append(
                        RegexGroup(match: capturedText, range: range)
                    )
                }
                
            }
            
            return RegexMatch(
                fullMatch: regexFullMatch,
                range: regexRange,
                groups: regexGroups
            )
            
        }
        
        return nil
    }

    /// See `String.regexMatch(_:_)`
    func regexMatch(
        _ nsRegularExpression: NSRegularExpression
    ) throws -> RegexMatch? {
        
        return try self.regexMatch(
            nsRegularExpression.pattern,
            nsRegularExpression.options
        )
    }


    
}
