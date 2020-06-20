import Foundation


public extension String {
    
    
    /**
     Splits the string by occurences of a pattern into an array.
     
     - Parameters:
       - pattern: A regular expression pattern.
       - options: Regular expression options.
       - ignoreIfEmpty: If true, all empty strings will be
             removed from the array. If false (default), they will be included.
       - maxLength: The maximum length of the returned array.
             If nil (default), then the string is split
             on every occurence of the pattern.
     - Throws: If the regular expression is invalid. **Never** throws
           if no matches are found.
     - Returns: An array of strings split on each occurence of the pattern.
           If no occurences of the pattern are found, then a single-element
           array containing the entire string will be returned.
     */
    func regexSplit(
        _ pattern: String,
        _ options: NSRegularExpression.Options = [],
        ignoreIfEmpty: Bool = false,
        maxLength: Int? = nil
    ) throws -> [String] {

        let regex = try NSRegularExpression(pattern: pattern, options: options)
    
        let matches = regex.matches(
            in: self, range: NSRange(0..<self.count)
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
    
    func regexSplit(
        _ nsRegularExpression: NSRegularExpression,
        ignoreIfEmpty: Bool = false,
        maxLength: Int? = nil
    ) throws -> [String] {
        
        return try self.regexSplit(
            nsRegularExpression.pattern,
            nsRegularExpression.options,
            ignoreIfEmpty: ignoreIfEmpty,
            maxLength: maxLength
        )

    }
    
    
    
}
