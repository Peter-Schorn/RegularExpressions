//
//  File.swift
//  
//
//  Created by Peter Schorn on 6/4/20.
//

import Foundation


public extension String {
    
    /**
     Performs a regular expression replacement.
     
     - Parameters:
       - regex: An object conforming to `RegexProtocol`.
             It encapsulates information about a regular expression.
       - with: The template string to replace matching patterns with.
             See [Template Matching Format](https://apple.co/3fWBknv)
             for how to format the template. Defaults to an empty string.
       - range: The range of self in which to search for the pattern
             and perform substitutions.
             If nil (default), then the entire string is searched.
     - Returns: The new string after the substitutions have been made.
           If no matches are found, the string is returned unchanged.
     - Throws: If the regular expression pattern is invalid
           or the number of group names does not match the number
           of capture groups.
     Example usage:
     ```
     let name = "Peter Schorn"
     
     // The .anchored matching option only looks for matches
     // at the beginning of the string.
     // Consequently, only the first word will be matched.
     let regexObject = try Regex(
         pattern: #"\w+"#,
         regexOptions: [.caseInsensitive],
         matchingOptions: [.anchored]
     )

     let replacedText = try name.regexSub(regexObject, with: "word")
     // replacedText = "word Schorn"
     ```
     */
    func regexSub<RegularExpression: RegexProtocol>(
        _ regex: RegularExpression,
        with template: String = "",
        range: Range<String.Index>? = nil
    ) throws -> String {
    
        let nsRange = NSRange(range ?? self.startIndex..<self.endIndex, in: self)
        let nsRegex = try regex.asNSRegex()
        
        return nsRegex.stringByReplacingMatches(
            in: self,
            options: regex.matchingOptions,
            range: nsRange,
            withTemplate: template
        )
        
    }
    
    /**
     Performs a regular expression replacement.
     
     - Parameters:
       - pattern: A regular expression pattern.
       - with: The template string to replace matching patterns with.
             See [Template Matching Format](https://apple.co/3fWBknv)
             for how to format the template. Defaults to an empty string.
       - regexOptions: The options for the regular expression.
       - matchingOptions: See [NSRegularExpression.MatchingOptions](https://developer.apple.com/documentation/foundation/nsregularexpression/matchingoptions)
       - range: The range of self in which to search for the pattern
             and perform substitutions.
             If nil (default), then the entire string is searched.
     - Throws: If the regular expression pattern is invalid
           or the number of group names does not match the number
           of capture groups.
     - Returns: The new string after the substitutions have been made.
           If no matches are found, the string is returned unchanged.
     
     Example usage:
     ```
     let text = "123 John Doe, age 21"
     let newText = try text.regexSub(#"\d+$"#, with: "unknown")
     // newText = "123 John Doe, age unknown"
     ```
     ```
     let name = "Charles Darwin"
     
     let reversedName = try name.regexSub(
         #"(\w+) (\w+)"#,
         with: "$2 $1"
         // $1 and $2 represent the
         // first and second capture group, respectively.
         // $0 represents the entire match.
     )
     
     // reversedName = "Darwin Charles"
     ```
     */
    func regexSub(
        _ pattern: String,
        with template: String = "",
        regexOptions: NSRegularExpression.Options = [],
        matchingOptions: NSRegularExpression.MatchingOptions = [],
        range: Range<String.Index>? = nil
    ) throws -> String {
        
        return try regexSub(
            Regex(
                pattern: pattern,
                regexOptions: regexOptions,
                matchingOptions: matchingOptions
            ),
            with: template,
            range: range
        
        )
        
    }
    
    // MARK: - Mutating overloads -
    
    /**
     Performs a regular expression replacement **in place**.
     
     - Parameters:
       - regex: An object conforming to `RegexProtocol`.
             It encapsulates information about a regular expression.
       - with: The template string to replace matching patterns with.
             See [Template Matching Format](https://apple.co/3fWBknv)
             for how to format the template. Defaults to an empty string.
       - range: The range of self in which to search for the pattern
             and perform substitutions.
             If nil (default), then the entire string is searched.
     - Throws: If the regular expression pattern is invalid
           or the number of group names does not match the number
           of capture groups.
     */
    mutating func regexSubInPlace<RegularExpression: RegexProtocol>(
        _ regex: RegularExpression,
        with template: String = "",
        range: Range<String.Index>? = nil
    ) throws {
    
        self = try regexSub(
            regex,
            with: template,
            range: range
        )
    }
    
    /**
     Performs a regular expression replacement **in place**.
    
     - Parameters:
       - pattern: A regular expression pattern.
       - with: The template string to replace matching patterns with.
             See [Template Matching Format](https://apple.co/3fWBknv)
             for how to format the template. Defaults to an empty string.
       - regexOptions: The options for the regular expression.
       - matchingOptions: See [NSRegularExpression.MatchingOptions](https://developer.apple.com/documentation/foundation/nsregularexpression/matchingoptions)
       - range: The range of self in which to search for the pattern
             and perform substitutions.
             If nil (default), then the entire string is searched.
     - Throws: If the regular expression pattern is invalid
           or the number of group names does not match the number
           of capture groups.
    
     Example usage:
     ```
     var text = "Have a terrible day"
     try text.regexSubInPlace("terrible", with: "nice")
     // text = "Have a nice day"
     ```
    */
    mutating func regexSubInPlace(
        _ pattern: String,
        with template: String = "",
        regexOptions: NSRegularExpression.Options = [],
        matchingOptions: NSRegularExpression.MatchingOptions = [],
        range: Range<String.Index>? = nil
    ) throws {
        
        try regexSubInPlace(
            Regex(
                pattern: pattern,
                regexOptions: regexOptions,
                matchingOptions: matchingOptions
            ),
            with: template,
            range: range
        )
    }
    

}
