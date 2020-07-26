//
//  PatternMatchingOverload.swift
//  RegularExpressions
//
//  Created by Peter Schorn on 7/25/20.
//

import Foundation


/**
 This overload of the pattern matching operator allows for
 using a switch statement on an input string and testing
 for matches to different regular expressions in each case.

 - Parameters:
   - regex: An optional type conforming to `RegexProtocol`.
   - value: The input string that is being switched on.
 - Returns: true if the regex matched the input string.
 
 `try`, `try?`, and `try!` can all be used to determined the best
 way to handle an error arising from an invalid regular expression pattern.

 Initializing the regular expression only throws an error
 if the pattern in invalid (e.g., mismatched parentheses),
 **NOT** if no match was found.
 
 Unfortunately, there is no way to bind the match of the
 regular expression pattern to a variable.
 
 For example:
 ```
 let inputStrig = #"user_id: "asjhjcb""#

 switch inputStrig {
     case try Regex(#"USER_ID: "[a-z]+""#, [.caseInsensitive]):
         print("valid user id")
     case try? Regex(#"[!@#$%^&]+"#):
         print("invalid character in user id")
     case try! Regex(#"\d+"#):
         print("user id cannot contain numbers")
     default:
         print("no match")
 }

 // prints "valid user id"
 ```
 */
public func ~= <RegularExpression: RegexProtocol>(
    regex: RegularExpression?, value: String
) -> Bool {
    
    if let regex = regex {
        return (try? value.regexMatch(regex)) != nil
    }
    return false

}
