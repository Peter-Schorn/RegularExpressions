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
       - pattern: Regular expression pattern.
       - with: The string to replace matching patterns with.
         defaults to an empty string.
       - options: The options for the regular expression.
             .regularExpression will be added to these options
     - Returns: The new string. If no matches were found,
           the string is left unchanged.
     */
    func regexSub(
        _ pattern: String,
        with replacement: String = "",
        _ options: NSString.CompareOptions = []
    ) -> String {
    
        var fullOptions = options
        fullOptions.insert(.regularExpression)
        
        return self.replacingOccurrences(
            of: pattern, with: replacement, options: fullOptions
        )
    }
    
    /// See self.regexSub(`_:with:`_:)
    mutating func regexSubInPlace(
        _ pattern: String,
        with replacement: String = "",
        _ options: NSString.CompareOptions = []
    ) {
    
        self = self.regexSub(pattern, with: replacement, options)
    }

}
