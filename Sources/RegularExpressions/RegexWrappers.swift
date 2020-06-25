import Foundation



extension String {
    
    /// Converts a `NSTextCheckingResult` into a `RegexMatch`
    internal func regexGetMatchWrapper<RegularExpression: RegexProtocol>(
        nsString: NSString,
        regexResult: NSTextCheckingResult,
        regex: RegularExpression
    ) throws -> RegexMatch {
        
        let regexFullMatch = nsString.substring(
            with: regexResult.range(at: 0)
        )
        let regexRange = Range(regexResult.range, in: self)!
        var regexGroups: [RegexGroup?] = []
        
        if let groupNames = regex.groupNames {
            // throw an error if the number of group names
            // does not match the number of capture groups.
            if groupNames.count != regexResult.numberOfRanges - 1 {
                throw RegexError.groupNamesCountDoesntMatch(
                    captureGroups: regexResult.numberOfRanges - 1,
                    groupNames: groupNames.count
                )
            }
        }
        
        // for each capture group
        for match in 1..<regexResult.numberOfRanges {
            
            let nsRange = regexResult.range(at: match)
            
            guard nsRange.location != NSNotFound else {
                regexGroups.append(nil)
                continue
            }
            
            let groupName = regex.groupNames?[match - 1]
            
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
        
        return RegexMatch(
            sourceString: self,
            fullMatch: regexFullMatch,
            range: regexRange,
            groups: regexGroups
        )
        
    }
    
    
}
