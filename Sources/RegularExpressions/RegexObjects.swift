import Foundation


public typealias Regex = NSRegularExpression


/**
 Represents a regular expression capture group.
 ```
 public let match: String
 public let range: Range<String.Index>
 ```
 */
public struct RegexGroup: Equatable {
    
    public init(match: String, range: Range<String.Index>) {
        self.match = match
        self.range = range
    }
    
    public let match: String
    public let range: Range<String.Index>
}


/**
 Represents a regular expression match
 ```
 let fullMatch: String
 let range: Range<String.Index>
 let groups: [RegexGroup?]
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
    
    public let fullMatch: String
    public let range: Range<String.Index>
    public let groups: [RegexGroup?]
    
    
}


public extension NSRegularExpression {

    
    /// Alias for `self.init(pattern:options:)`.
    /// This convienence initializer removes the parameter labels.
    ///
    /// - Parameters:
    ///   - pattern: The regular expression pattern.
    ///   - options: Regular expression options, such as .caseInsensitive.
    /// - Throws: If the regular expression pattern is invalid.
    convenience init(
        _ pattern: String,
        _ options: NSRegularExpression.Options = []
    ) throws {
        try self.init(pattern: pattern, options: options)
    }
    
}



/// This overload of the pattern matching operator allows for
/// using a switch statement on an input string and testing
/// for matches to different regular expressions in each case.
///
/// For example:
/// ```
/// let inputString = "age: 21"
///
/// switch  inputString {
///     case try! Regex(#"\d+"#):
///         print("found numbers in input string")
///
///     case try? Regex("^[a-z]+$"):
///         print("the input string consists entirely of letters")
///
///     case try Regex("height: 21", [.caseInsensitive]):
///         print("found match for 'height: 21' in input string")
///
///     default:
///         print("no matched found")
/// }
/// ```
///
/// Initializing the regular expression only throws an error
/// if the pattern in invalid (e.g., mismatched parentheses),
/// **NOT** if no match was found.
///
///
///
/// - Parameters:
///   - regex: An optional NSRegularExpression.
///   - value: The input string that is being switched on.
/// - Returns: true if the regex matched the input string.
public func ~=(regex: NSRegularExpression?, value: String) -> Bool {
    
    return regex?.firstMatch(
        in: value, range: NSRange(location: 0, length: value.count)
    ) != nil

}

