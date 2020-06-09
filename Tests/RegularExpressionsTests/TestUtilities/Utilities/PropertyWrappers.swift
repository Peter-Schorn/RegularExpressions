import Foundation
import RegularExpressions

/**
 Property Wrapper that removes characters that match a regular expression pattern

 This example will remove all non-word characters from a string
 ```
 struct User {

     @InvalidChars(#"\W+"#) var username: String

     init(username: String) {
         self.username = username
     }

 }
 ```
 */
@propertyWrapper
public struct InvalidChars {
    
    private var value = ""
    public let regex: String
    
    public init(_ regex: String) {
        self.regex = regex
    }
    
    public init(wrappedValue: String, _ regex: String) {
        self.regex = regex
        // self.value = wrappedValue.regexSub(regex)
        self.value = wrappedValue
    }
    
    
    public var wrappedValue: String {
        get { return value }
        set { value = newValue.regexSub(regex) }
    }

}
