import Foundation


public typealias Regex = NSRegularExpression


/**
 Represents a regular expression capture group.
 ```
 /// The text of the capture group.
 public let match: String
 /// The range of the capture group.
 public let range: Range<String.Index>
 ```
 */
public struct RegexGroup: Equatable {
    
    public init(match: String, range: Range<String.Index>) {
        self.match = match
        self.range = range
    }
    
    /// The text of the capture group.
    public let match: String
    /// The range of the capture group.
    public let range: Range<String.Index>
}


/**
 Represents a regular expression match.
 ```
 /// The full match of the pattern in the target string.
 public let fullMatch: String
 /// The range of the full match.
 public let range: Range<String.Index>
 /// The capture groups.
 public let groups: [RegexGroup?]
 ```
 */
public struct RegexMatch: Equatable {
    
    public init(
        fullMatch: String,
        range: Range<String.Index>,
        groups: [RegexGroup?]
    ) {
        self.fullMatch = fullMatch
        self.range = range
        self.groups = groups
    }
    
    /// The full match of the pattern in the target string.
    public let fullMatch: String
    /// The range of the full match.
    public let range: Range<String.Index>
    /// The capture groups.
    public let groups: [RegexGroup?]
    
    
}


/// Extensions cannot contain stored properties
private var regexMatchingOptionsReference = NSMapTable<
    NSRegularExpression, ClassWrapper<NSRegularExpression.MatchingOptions>
>(
    keyOptions: .weakMemory,
    valueOptions: .strongMemory
)

private class ClassWrapper<T> {
    var object: T
    init(_ object: T) {
        self.object = object
    }
}


public extension NSRegularExpression {

    
    /**
     Alias for `self.init(pattern:options:)`.
     This convienence initializer removes the parameter labels.
    
     - Parameters:
       - pattern: The regular expression pattern.
       - options: Regular expression options, such as .caseInsensitive.
     - Throws: If the regular expression pattern is invalid.
     */
    convenience init(
        _ pattern: String,
        _ options: NSRegularExpression.Options = []
    ) throws {
        try self.init(pattern: pattern, options: options)
    }
    
    
    convenience init(
        pattern: String,
        regexOptions: NSRegularExpression.Options = [],
        matchingOptions: NSRegularExpression.MatchingOptions = []
    ) throws {
        
        try self.init(pattern: pattern, options: regexOptions)
        self.matchingOptions = matchingOptions
        
    }
    
    // extensions cannot contain stored properties
    /// See [NSRegularExpression.MatchingOptions](https://developer.apple.com/documentation/foundation/nsregularexpression/matchingoptions)
    var matchingOptions: NSRegularExpression.MatchingOptions {
        get {
            if let wrapper = regexMatchingOptionsReference.object(forKey: self) {
                return wrapper.object
            }
            return []
        }
        set {
            regexMatchingOptionsReference.setObject(
                ClassWrapper(newValue), forKey: self
            )
        }
    }
    
    
    
    
}



/**
 This overload of the pattern matching operator allows for
 using a switch statement on an input string and testing
 for matches to different regular expressions in each case.

 - Parameters:
   - regex: An optional NSRegularExpression.
   - value: The input string that is being switched on.
 - Returns: true if the regex matched the input string.
 
 `try`, `try?`, and `try!` can all be used to determined the best
 way to handle an error arising from an invalid regular expression pattern.

 Initializing the regular expression only throws an error
 if the pattern in invalid (e.g., mismatched parentheses),
 **NOT** if no match was found.
 
 For example:
 ```
 let inputString = "age: 21"

 switch  inputString {
     case try! Regex(#"\d+"#):
         print("found numbers in input string")

     case try? Regex("^[a-z]+$"):
         print("the input string consists entirely of letters")

     case try Regex("height: 21", [.caseInsensitive]):
         print("found match for 'height: 21' in input string")

     default:
         print("no matched found")
 }
 ```
 */
public func ~=(regex: NSRegularExpression?, value: String) -> Bool {
    
    if let regex = regex {
        return (try? value.regexMatch(regex)) != nil
    }
    return false

}

