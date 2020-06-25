import Foundation


public extension String {
    
    
    /**
     Splits the string by occurences of a pattern into an array.
     
     - Parameters:
       - regex: An object conforming to `RegexProtocol`.
             It encapsulates information about a regular expression.
       - ignoreIfEmpty: If true, all empty strings will be
             removed from the array. If false (default), they will be included.
       - maxLength: The maximum length of the returned array.
             If nil (default), then the string is split
             on every occurence of the pattern.
       - range: The range of self in which to search for the delimiters.
             If nil (default), then the entire string is searched.
     - Throws: If the regular expression is invalid.
           or the number of group names does not match the number
           of capture groups. **Never** throws if no matches are found.
     - Returns: An array of strings split on each occurence of the pattern.
           If no occurences of the pattern are found, then a single-element
           array containing the entire string will be returned.
     
     Example usage:
     ```
     let colors = "red and orange ANDyellow and    blue"
     let regex = try! Regex(#"\s*and\s*"#, regexOptions: [.caseInsensitive])
     let array = try! colors.regexSplit(regex)
     // array = ["red", "orange", "yellow", "blue"]
     ```
     */
    func regexSplit<RegularExpression: RegexProtocol>(
        _ regex: RegularExpression,
        ignoreIfEmpty: Bool = false,
        maxLength: Int? = nil,
        range: Range<String.Index>? = nil
    ) throws -> [String] {

        let nsRegex = try regex.asNSRegex()
    
        let matches = nsRegex.matches(
            in: self,
            options: regex.matchingOptions,
            range: NSRange(
                range ?? self.startIndex..<self.endIndex, in: self
            )
        )
        
        let ranges =
                [startIndex..<startIndex] +
                matches.map{ Range($0.range, in: self)! } +
                [endIndex..<endIndex]
        
        let max: Int
        if let maxLength = maxLength {
            max = Swift.min(maxLength - 1, matches.count)
        }
        else {
            max = matches.count
        }
        
        return (0...max).compactMap {
            let item = String(
                self[ranges[$0].upperBound..<ranges[$0+1].lowerBound]
            )
            if item.isEmpty && ignoreIfEmpty { return nil }
            return item
        }
        
    }
    
    /**
     Splits the string by occurences of a pattern into an array.
     
     - Parameters:
       - pattern: A regular expression pattern.
       - regexOptions: The regular expression options, such as .caseInsensitive.
       - matchingOptions: See [NSRegularExpression.MatchingOptions](https://developer.apple.com/documentation/foundation/nsregularexpression/matchingoptions)
       - ignoreIfEmpty: If true, all empty strings will be
             removed from the array. If false (default), they will be included.
       - maxLength: The maximum length of the returned array.
             If nil (default), then the string is split
             on every occurence of the pattern.
       - range: The range of self in which to search for the delimiters.
             If nil (default), then the entire string is searched.
     - Throws: If the regular expression is invalid. **Never** throws
           if no matches are found.
     - Returns: An array of strings split on each occurence of the pattern.
           If no occurences of the pattern are found, then a single-element
           array containing the entire string will be returned.
     
     Example usage:
     ```
     let colors = "red,orange,yellow,blue"
     let array = try! colors.regexSplit(",")
     // array = ["red", "orange", "yellow", "blue"]
     ```
     */
    func regexSplit(
        _ pattern: String,
        regexOptions: NSRegularExpression.Options = [],
        matchingOptions: NSRegularExpression.MatchingOptions = [],
        ignoreIfEmpty: Bool = false,
        maxLength: Int? = nil,
        range: Range<String.Index>? = nil
    ) throws -> [String] {
        
        return try self.regexSplit(
            Regex(
                pattern: pattern,
                regexOptions: regexOptions,
                matchingOptions: matchingOptions
            ),
            ignoreIfEmpty: ignoreIfEmpty,
            maxLength: maxLength,
            range: range
        )

    }
    
    
    
}
