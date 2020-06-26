import Foundation


public extension String {
    
    /**
     Performs a regular expression replacement using the provided closure.
     
     - Parameters:
       - regex: An object conforming to `RegexProtocol`.
             It encapsulates information about a regular expression.
       - range: The range of self in which to search for the pattern.
             If nil (default), then the entire string is searched.
       - replacer: A closure that accepts the index of a regular expression
             match and a regular expression match and returns a new string to
             replace it with. Return nil from within the closure to indicate
             that the match should not be changed.
       - matchIndex: The index of the regular expression match.
       - match: A regular expression match.
     - Throws: If the regular expression pattern is invalid
           or the number of group names does not match the number
           of capture groups.
     - Returns: The new string after the regular subsitutions have been made.
     
     Example usage:
     ```
     let inputString = """
     Darwin's theory of evolution is the \
     unifying theory of the life sciences.
     """
     
     let regex = try Regex(
         pattern: #"\w+"#, regexOptions: [.caseInsensitive]
     )
     
     let replacedString = try inputString.regexSub(regex) { indx, match in
         if indx > 5 { return nil }
         return match.fullMatch.uppercased()
     }
     
     // replacedString = """
     // DARWIN'S THEORY OF EVOLUTION IS the \
     // unifying theory of the life sciences.
     // """
     ```
     */
    func regexSub<RegularExpression: RegexProtocol>(
        _ regex: RegularExpression,
        range: Range<String.Index>? = nil,
        replacer: (_ matchIndex: Int, _ match: RegexMatch) -> String?
    ) throws -> String {
        
        var replacedString = ""
        var currentRange = self.startIndex..<self.startIndex
        
        let matches = try regexFindAll(regex, range: range)
        for (indx, match) in matches.enumerated() {
            
            replacedString += self[currentRange.upperBound..<match.range.lowerBound]
            if let replacement = replacer(indx, match) {
                replacedString += replacement
            }
            else {
                replacedString += self[match.range]
            }
            currentRange = match.range
        }
        
        replacedString += self[currentRange.upperBound...]
        return replacedString
    }
    
    /**
     Performs a regular expression replacement using the provided closure.
     
     - Parameters:
       - pattern: A regular expression pattern.
       - regexOptions: The regular expression options, such as .caseInsensitive.
       - matchingOptions: See [NSRegularExpression.MatchingOptions](https://developer.apple.com/documentation/foundation/nsregularexpression/matchingoptions)
       - groupNames: The names of the capture groups.
       - range: The range of self in which to search for the pattern.
             If nil (default), then the entire string is searched.
       - matchIndex: The index of the regular expression match.
       - match: A regular expression match.
       - replacer: A closure that accepts the index of a regular expression
             match and a regular expression match and returns a new string to
             replace it with. Return nil from within the closure to indicate
             that the match should not be changed.
     - Throws: If the regular expression pattern is invalid
           or the number of group names does not match the number
           of capture groups.
     - Returns: The new string after the regular subsitutions have been made.
     
     Example usage:
     ```
     let inputString = """
     Darwin's theory of evolution is the \
     unifying theory of the life sciences.
     """
     
     let replacedString = try inputString.regexSub(inputString) { indx, match in
         if indx > 5 { return nil }
         return match.fullMatch.uppercased()
     }
     
     // replacedString = """
     // DARWIN'S THEORY OF EVOLUTION IS the \
     // unifying theory of the life sciences.
     // """
     ```
     */
    func regexSub(
        _ pattern: String,
        regexOptions: NSRegularExpression.Options = [],
        matchingOptions: NSRegularExpression.MatchingOptions = [],
        groupNames: [String]? = nil,
        range: Range<String.Index>? = nil,
        replacer: (_ matchIndex: Int, _ match: RegexMatch) -> String?
    ) throws -> String {
        
        return try regexSub(
            Regex(
                pattern: pattern,
                regexOptions: regexOptions,
                matchingOptions: matchingOptions,
                groupNames: groupNames
            ),
            range: range,
            replacer: replacer
        )
    
    }

    // MARK: - Mutating overloads -
    
    /**
     Performs a regular expression replacement using
     the provided closure **In place**.
     
     - Parameters:
       - pattern: A regular expression pattern.
       - regexOptions: The regular expression options, such as .caseInsensitive.
       - matchingOptions: See [NSRegularExpression.MatchingOptions](https://developer.apple.com/documentation/foundation/nsregularexpression/matchingoptions)
       - groupNames: The names of the capture groups.
       - range: The range of self in which to search for the pattern.
             If nil (default), then the entire string is searched.
       - matchIndex: The index of the regular expression match.
       - match: A regular expression match.
       - replacer: A closure that accepts the index of a regular expression
             match and a regular expression match and returns a new string to
             replace it with. Return nil from within the closure to indicate
             that the match should not be changed.
     - Throws: If the regular expression pattern is invalid
           or the number of group names does not match the number
           of capture groups.
     */
    mutating func regexSubInPlace(
        _ pattern: String,
        regexOptions: NSRegularExpression.Options = [],
        matchingOptions: NSRegularExpression.MatchingOptions = [],
        groupNames: [String]? = nil,
        range: Range<String.Index>? = nil,
        replacer: (_ matchIndex: Int, _ match: RegexMatch) -> String?
    ) throws {
        
        try regexSubInPlace(
            Regex(
                pattern: pattern,
                regexOptions: regexOptions,
                matchingOptions: matchingOptions,
                groupNames: groupNames
            ),
            range: range,
            replacer: replacer
        )
        
    }
    
    /**
     Performs a regular expression replacement using the provided closure.
    
     - Parameters:
       - regex: An object conforming to `RegexProtocol`.
             It encapsulates information about a regular expression.
       - range: The range of self in which to search for the pattern.
             If nil (default), then the entire string is searched.
       - replacer: A closure that accepts the index of a regular expression
             match and a regular expression match and returns a new string to
             replace it with. Return nil from within the closure to indicate
             that the match should not be changed.
       - matchIndex: The index of the regular expression match.
       - match: A regular expression match.
     - Throws: If the regular expression pattern is invalid
           or the number of group names does not match the number
           of capture groups.
     */
    mutating func regexSubInPlace<RegularExpression: RegexProtocol>(
        _ regex: RegularExpression,
        range: Range<String.Index>? = nil,
        replacer: (_ matchIndex: Int, _ match: RegexMatch) -> String?
    ) throws {
        
        self = try regexSub(
            regex,
            range: range,
            replacer: replacer
        )
        
    }

}
