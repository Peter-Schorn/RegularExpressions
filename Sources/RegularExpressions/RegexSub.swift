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
       - nsRegularExpression: An NSRegularExpression.
             **Note:** This library defines a
             `typealias Regex = NSRegularExpression`.
       - with: The template string to replace matching patterns with.
             See [Template Matching Format](https://developer.apple.com/documentation/foundation/nsregularexpression#1661112:~:text=Template%20Matching%20Format,matching.%20Table%203%20describes%20the%20syntax.) for how to format the template.
             Defaults to an empty string.
       - range: The range of self in which to search for the pattern
             and perform substitutions.
             If nil (default), then the entire string is searched.
     - Returns: The new string after the substitutions are made.
           If no matches are found, the string is returned unchanged.
     
     Example usage:
     ```
     let name = "Peter Schorn"
     
     // The .anchored matching option only looks for matches
     // at the beginning of the string.
     // Consequently, only the first word will be matched.
     let regexObject = try! Regex(
         pattern: #"\w+"#,
         regexOptions: [.caseInsensitive],
         matchingOptions: [.anchored]
     )

     let replacedText = name.regexSub(regexObject, with: "word")
     // replacedText = "word Schorn"
     ```
     */
    func regexSub(
        _ nsRegularExpression: NSRegularExpression,
        with template: String = "",
        range: Range<String.Index>? = nil
    ) -> String {
    
        let nsRange = NSRange(range ?? self.startIndex..<self.endIndex, in: self)
        
        return nsRegularExpression.stringByReplacingMatches(
            in: self,
            options: nsRegularExpression.matchingOptions,
            range: nsRange,
            withTemplate: template
        )
        
    }
    
    /**
     Performs a regular expression replacement.
     
     - Parameters:
       - pattern: A regular expression pattern.
       - with: The template string to replace matching patterns with.
             See [Template Matching Format](https://developer.apple.com/documentation/foundation/nsregularexpression#1661112:~:text=Template%20Matching%20Format,matching.%20Table%203%20describes%20the%20syntax.) for how to format the template.
             Defaults to an empty string.
             
       - regexOptions: The options for the regular expression.
       - matchingOptions: See [NSRegularExpression.MatchingOptions](https://developer.apple.com/documentation/foundation/nsregularexpression/matchingoptions)
       - range: The range of self in which to search for the pattern
             and perform substitutions.
             If nil (default), then the entire string is searched.
     - Returns: The new string after the substitutions are made.
           If no matches are found, the string is returned unchanged.
     
     Example usage:
     ```
     let text = "123 John Doe, age 21"
     let newText = text.regexSub(#"\d+$"#, with: "unknown")
     // newText = "123 John Doe, age unknown"
     ```
     ```
     let name = "Charles Darwin"
     
     let reversedName = try! name.regexSub(
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
            NSRegularExpression(
                pattern: pattern,
                regexOptions: regexOptions,
                matchingOptions: matchingOptions
            ),
            with: template,
            range: range
        
        )
        
    }
    
    
    /**
     Performs a regular expression replacement **in place**.
     
     - Parameters:
       - nsRegularExpression: An NSRegularExpression.
             **Note:** This library defines a
             `typealias Regex = NSRegularExpression`.
       - with: The template string to replace matching patterns with.
             See [Template Matching Format](https://developer.apple.com/documentation/foundation/nsregularexpression#1661112:~:text=Template%20Matching%20Format,matching.%20Table%203%20describes%20the%20syntax.) for how to format the template.
       Defaults to an empty string.
       - range: The range of self in which to search for the pattern
             and perform substitutions.
             If nil (default), then the entire string is searched.
     */
    mutating func regexSubInPlace(
        _ nsRegularExpression: NSRegularExpression,
        with template: String = "",
        range: Range<String.Index>? = nil
    ) {
    
        self = regexSub(
            nsRegularExpression,
            with: template,
            range: range
        )
    }
    
    
    /**
     Performs a regular expression replacement **in place**.
    
     - Parameters:
       - pattern: A regular expression pattern.
       - with: The template string to replace matching patterns with.
             See [Template Matching Format](https://developer.apple.com/documentation/foundation/nsregularexpression#1661112:~:text=Template%20Matching%20Format,matching.%20Table%203%20describes%20the%20syntax.) for how to format the template.
             Defaults to an empty string.
       - regexOptions: The options for the regular expression.
       - matchingOptions: See [NSRegularExpression.MatchingOptions](https://developer.apple.com/documentation/foundation/nsregularexpression/matchingoptions)
       - range: The range of self in which to search for the pattern
             and perform substitutions.
             If nil (default), then the entire string is searched.

     - Warning: If the regular expression pattern is invalid, then the
          string will not be changed.
    
     Example usage:
     ```
     var text = "Have a terrible day"
     text.regexSubInPlace("terrible", with: "nice")
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
            NSRegularExpression(
                pattern: pattern,
                regexOptions: regexOptions,
                matchingOptions: matchingOptions
            ),
            with: template,
            range: range
        )
    }

}
