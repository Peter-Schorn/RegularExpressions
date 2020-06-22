import Foundation


public extension String {
    
    
    private func regexGetMatch(
        nsString: NSString,
        regexResult: NSTextCheckingResult,
        groupNames: [String]? = nil
    ) throws -> RegexMatch {
        
        // MARK: Begin dupication
        let regexFullMatch = nsString.substring(
            with: regexResult.range(at: 0)
        )
        let regexRange = Range(regexResult.range, in: self)!
        var regexGroups: [RegexGroup?] = []
        
        if let groupNames = groupNames {
            // throw an error if the number of group names
            // does not match the number of capture groups.
            if groupNames.count != regexResult.numberOfRanges - 1 {
                throw RegexError.groupNamesCountDoesntMatch(
                    captureGroups: regexGroups.count,
                    groupNames: groupNames.count
                )
            }
        }
        
        // for each capture group
        for match in 1..<regexResult.numberOfRanges {
            
            let groupName = groupNames?[match - 1]
            
            let nsRange = regexResult.range(at: match)
            
            if nsRange.location == NSNotFound {
                regexGroups.append(nil)
            }
            else {
                let capturedTextRange = Range(nsRange, in: self)!
                let capturedText = nsString.substring(with: nsRange)
                
                regexGroups.append(
                    RegexGroup(
                        match: capturedText,
                        range: capturedTextRange,
                        name: groupName
                    )
                )
            }
            
        }
        
        return RegexMatch(
            fullMatch: regexFullMatch,
            range: regexRange,
            groups: regexGroups
        )
        
        // MARK: End duplication
        
    }
    
    
    /**
     Finds all matches for a regular expression pattern in a string.
     
     - Parameters:
       - nsRegularExpression: An NSRegularExpression.
             **Note:** This library defines a
             `typealias Regex = NSRegularExpression`.
       - range: The range of self in which to search for the pattern.
             If nil (default), then the entire string is searched.
     
     - Throws: If the regular expression pattern is invalid
           (e.g., unbalanced parentheses). **Never** throws an error
           if no matches are found.
     
     - Returns: An array of matches, each of which contains the full match,
           the range of the full match in the original text,
           and an array of the capture groups. Returns an empty
           array if no matches were found.
     
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
     var inputText = "season 8, EPISODE 5; season 5, episode 20"
     let regex = try! Regex(
         #"season (\d+), Episode (\d+)"#, [.caseInsensitive]
     )
             
     let results = try! inputText.regexFindAll(regex)

     for result in results {
         print("fullMatch: '\(result.fullMatch)'")
         
         // each capture group contains the match and the range.
         let captureGroups = result.groups.map { captureGroup in
             captureGroup!.match
         }
         
         print("Capture groups:", captureGroups)
         print()
     }

     let firstResult = results[0]

     inputText.replaceSubrange(
         firstResult.range, with: "new value"
     )

     print("after replacing text: '\(inputText)'")
     ```
     Output:
     ```
     // fullMatch: 'season 8, EPISODE 5'
     // Capture groups: ["8", "5"]
     
     // fullMatch: 'season 5, episode 20'
     // Capture groups: ["5", "20"]
     
     // after replacing text: 'new value; season 5, episode 20'
     ```
     */
    func regexFindAll(
        _ nsRegularExpression: NSRegularExpression,
        range: Range<String.Index>? = nil
    ) throws -> [RegexMatch] {
        
        let nsString = self as NSString
        
        let regexResults = nsRegularExpression.matches(
            in: self,
            range: NSRange(
                range ?? self.startIndex..<self.endIndex, in: self
            )
        )
        
        var allMatches: [RegexMatch] = []
        
        // for each full match
        for result in regexResults {
            
            // MARK: Begin dupication
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
            // MARK: End duplication
            
            allMatches.append(
                RegexMatch(
                    fullMatch: regexFullMatch,
                    range: regexRange,
                    groups: regexGroups
                )
            )
            
        }
        
        return allMatches
    }
    
    /**
     Finds all matches for a regular expression pattern in a string.
     
     - Parameters:
       - pattern: The regular expression pattern.
       - options: The regular expression options, such as .caseInsensitive
       - range: The range of self in which to search for the pattern.
             If nil (default), then the entire string is searched.
     
     - Throws: If the regular expression pattern is invalid
           (e.g., unbalanced parentheses). **Never** throws an error
           if no matches are found.
     
     - Returns: An array of matches, each of which contains the full match,
           the range of the full match in the original text,
           and an array of the capture groups. Returns an empty
           array if no matches were found.
     
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
     var inputText = "season 8, EPISODE 5; season 5, episode 20"
     let pattern = #"season (\d+), Episode (\d+)"#

     let results = try! inputText.regexFindAll(
         pattern, [.caseInsensitive]
     )

     for result in results {
         print("fullMatch: '\(result.fullMatch)'")
         
         // each capture group contains the match and the range.
         let captureGroups = result.groups.map { captureGroup in
             captureGroup!.match
         }
         
         print("Capture groups:", captureGroups)
         print()
     }

     let firstResult = results[0]

     inputText.replaceSubrange(
         firstResult.range, with: "new value"
     )
     
     print("after replacing text: '\(inputText)'")
     ```
     Output:
     ```
     // fullMatch: 'season 8, EPISODE 5'
     // Capture groups: ["8", "5"]
     
     // fullMatch: 'season 5, episode 20'
     // Capture groups: ["5", "20"]
     
     // after replacing text: 'new value; season 5, episode 20'
     ```
     */
    func regexFindAll(
        _ pattern: String,
        _ options: NSRegularExpression.Options = [],
        range: Range<String.Index>? = nil
    ) throws -> [RegexMatch] {
        
        return try self.regexFindAll(
            NSRegularExpression(
                pattern: pattern, options: options
            ),
            range: range
        )
    }
    
    
    
}
