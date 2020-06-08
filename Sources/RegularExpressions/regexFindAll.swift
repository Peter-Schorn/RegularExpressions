import Foundation


public extension String {
    
    /**
     Finds all matches for a regular expression pattern in a string.
     
     - Parameters:
       - pattern: Regular expression pattern.
       - options: Regular expression options, such as .caseInsensitive
     
     - Throws: If the regular expression pattern is invalid
               (e.g., unbalanced parentheses). **Never** throws an error
               if no matches are found.
     
     - Returns: An array of matches, each of which contains the full match,
                the range of the full match in the original text,
                and an array of the capture groups.
                
                Each capture group is an optional RegexGroup containing
                the matched text and the range of the matched text,
                or nil if the group was not matched.
                
                The ranges returned by this function can be used in the subscript
                for the original text, or for self.replacingCharacters(in:with:)
                to modify the text. Note that after the original text has been
                modified, the ranges may be invalid because characters may have
                shifted to difference indices.
                
                If no matches were found at all, returns nil, **not an empty array**.
     
     Example Usage:
     ```
     var inputText = "season 8, EPISODE 5; season 5, episode 20"
     let pattern = #"season (\d+), Episode (\d+)"#
     
     if let results = try! inputText.regexFindAll(
     pattern, [.caseInsensitive]
     ) {
     for result in results {
     print("fullMatch: '\(result.fullMatch)'")
     
     let capturedText = result.groups.map { captureGroup in
     captureGroup!.match
     }
     
     print("Capture groups:", capturedText)
     print()
     }
     
     let firstResult = results[0]
     
     inputText.self.replacingCharacters(in: firstResult.range, with: "new value")
     
     print("replaced text: '\(inputText)'")
     }
     ```
     Output:
     ```
     // fullMatch: 'season 8, EPISODE 5'
     // Capture groups: ["8", "5"]
     //
     // fullMatch: 'season 5, episode 20'
     // Capture groups: ["5", "20"]
     //
     // replaced text: 'new value; season 5, episode 20'
     ```
     */
    func regexFindAll(
        _ pattern: String,
        _ options: NSRegularExpression.Options = []
    ) throws -> [RegexMatch]? {
        
        let regex = try NSRegularExpression(pattern: pattern, options: options)
        
        let nsString = self as NSString
        
        let regexResults = regex.matches(
            in: self, range: NSRange(location: 0, length: self.count)
        )
        
        var allMatches: [RegexMatch] = []
        
        // for each full match
        for result in regexResults {
            
            let regexFullMatch = nsString.substring(
                with: result.range(at: 0)
            )
            let regexRange = Range(result.range, in: self)!
            var regexGroups: [RegexGroup?] = []
            
            
            // for each capture group
            for match in 1..<result.numberOfRanges {
                
                let nsRange = result.range(at: match)
                
                if nsRange.location == NSNotFound {
                    regexGroups.append(nil)
                }
                    
                else {
                    
                    let capturedTextRange = Range(nsRange, in: self)!
                    
                    let capturedText = nsString.substring(with: nsRange)
                    
                    regexGroups.append(
                        RegexGroup(match: capturedText, range: capturedTextRange)
                    )
                }
                
            }
            
            allMatches.append(
                RegexMatch(
                    fullMatch: regexFullMatch,
                    range: regexRange,
                    groups: regexGroups
                )
            )
            
        }
        
        if allMatches.isEmpty { return nil }
        return allMatches
    }
    
    /// Passes a regex object into `String.regexFindAll(_:_)`.
    /// See that function for more details.
    func regexFindAll(
        _ nsRegularExpression: NSRegularExpression
    ) throws -> [RegexMatch]? {
        
        return try self.regexFindAll(
            nsRegularExpression.pattern,
            nsRegularExpression.options
        )
    }
    
    
}
