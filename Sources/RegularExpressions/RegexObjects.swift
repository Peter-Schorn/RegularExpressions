import Foundation


// MARK: $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// MARK: $$$$$$$$$$$$$$$$$$$$$$$$$$$ - NOTES - $$$$$$$$$$$$$$$$$$$$$$$$$$$$
// MARK: $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// MARK: ------------------------------------------------------------------
// MARK: Add matching options to regexMatch, regexFindAll, and
// MARK: regexSplit.
// MARK:
// MARK: OR:
// MARK: The above functions can construct their own NSRegularExpression
// MARK: with try
// MARK:
// MARK: Note that the RegexProtocol does not enfore 
// MARK: that the pattern will remain valid.
// MARK:
// MARK:
// MARK: ------------------------------------------------------------------





// public typealias Regex = NSRegularExpression


public enum RegexError: Error, LocalizedError {
    case groupNamesCountDoesntMatch(
        captureGroups: Int, groupNames: Int
    )
    
    var localizedDescription: String {
        switch self {
            case let .groupNamesCountDoesntMatch(
                captureGroups, groupNames
            ):
                return """
                The number of capture groups (\(captureGroups)) \
                doesn't match the number of group names (\(groupNames))
                """
        }
    }
    
}


/**
 A regular expression capture group.
 ```
 /// The name of the capture group
 public let name: String?
 /// The text of the capture group.
 public let match: String
 /// The range of the capture group.
 public let range: Range<String.Index>
 ```
 */
public struct RegexGroup: Equatable, Hashable {
    
    public init(
        match: String,
        range: Range<String.Index>,
        name: String? = nil
    ) {
        self.name = name
        self.match = match
        self.range = range
    }
    
    /// The name of the capture group
    public let name: String?
    /// The text of the capture group.
    public let match: String
    /// The range of the capture group.
    public let range: Range<String.Index>
}


/**
 A regular expression match.
 ```
 /// The full match of the pattern in the target string.
 public let fullMatch: String
 /// The range of the full match.
 public let range: Range<String.Index>
 /// The capture groups.
 public let groups: [RegexGroup?]
 
 /// Returns a `RegexGroup` by name.
 public func group(named name: String) -> RegexGroup?
 ```
 */
public struct RegexMatch: Equatable, Hashable {
    
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
    
    
    /**
     Returns a `RegexGroup` by name.
     
     - Parameter name: The name of the group.
     
     - Warning: This function will return nil if the name was not found,
         **OR** if the group was not matched becase it was specified as
         optional in the regular expression pattern.
     */
    public func group(named name: String) -> RegexGroup? {
        return groups.first { group in
            group?.name == name
        } ?? nil
        // unwrap the double-wrapped optional
        // to a single-layer optional.
    }
    
    
}




public protocol RegexProtocol {
    
    var pattern: String { get }
    var regexOptions: NSRegularExpression.Options { get }
    var matchingOptions: NSRegularExpression.MatchingOptions { get }
    var groupNames: [String]? { get }

}

public extension RegexProtocol {
    
    /// Converts self to an NSRegularExpression.
    /// - Throws: If the pattern is invalid.
    func asNSRegex() throws -> NSRegularExpression {
        return try NSRegularExpression(
            pattern: pattern, options: regexOptions
        )
    }
    
}



public struct Regex: RegexProtocol {
    
    public var pattern: String
    public var regexOptions: NSRegularExpression.Options
    public var matchingOptions: NSRegularExpression.MatchingOptions
    public var groupNames: [String]?
    
    
    /**
     Creates a regular expression object.
    
     - Parameters:
       - pattern: The regular expression pattern.
       - regexOptions: The options for the regular expression,
             such as `.caseInsensitive`.
       - matchingOptions: See [NSRegularExpression.MatchingOptions](https://developer.apple.com/documentation/foundation/nsregularexpression/matchingoptions).
             These are used for String.regexSub.
       - groupNames: The names of the capture groups.
     - Throws: If the regular expression pattern is invalid.
     */
    public init(
        pattern: String,
        regexOptions: NSRegularExpression.Options = [],
        matchingOptions: NSRegularExpression.MatchingOptions = [],
        groupNames: [String]? = nil
    ) throws {
        
        // validate the regular expression pattern
        _ = try NSRegularExpression(
            pattern: pattern, options: regexOptions
        )
        
        self.pattern = pattern
        self.regexOptions = regexOptions
        self.matchingOptions = matchingOptions
        self.groupNames = groupNames
    }
    
    /**
     A convience initializer that only initializes
     the pattern and regular expression options.
     
     - Parameters:
       - pattern: The regular expression pattern.
       - regexOptions: The options for the regular expression,
             such as `.caseInsensitive`.
     - Throws: If the regular expression pattern is invalid.
     
     This struct also has `matchingOptions` and `groupNames` properties,
     but they are initialized to `[]` and `nil`, respectively.
     */
    public init(
        _ pattern: String,
        _ regexOptions: NSRegularExpression.Options = []
    ) throws {
        
        try self.init(pattern: pattern, regexOptions: regexOptions)
    }
    
    
    /**
     Creates a regular expression object from an `NSRegularExpression`
     
     - Parameters:
      - nsRegularExpression: An `NSRegularExpression`
      - matchingOptions: See [NSRegularExpression.MatchingOptions](https://developer.apple.com/documentation/foundation/nsregularexpression/matchingoptions).
            These are used for String.regexSub.
      - groupNames: The names of the capture groups.
     */
    public init(
        nsRegularExpression: NSRegularExpression,
        matchingOptions: NSRegularExpression.MatchingOptions = [],
        groupNames: [String]? = nil
    ) {
        
        try! self.init(
            pattern: nsRegularExpression.pattern,
            regexOptions: nsRegularExpression.options,
            matchingOptions: matchingOptions,
            groupNames: groupNames
        )
    }
    
    
}



extension NSRegularExpression: RegexProtocol {
    
    /// Exists only to satisfy the requirements of
    /// `RegularExpressionProtocol`. it will **ALWAYS** return `[]`
    /// Use the `Regex` struct,
    /// which also conforms to this protocol if you want to customize
    /// `regexOptions`.
    public var regexOptions: Options { return [] }
    
    /// Exists only to satisfy the requirements of
    /// `RegularExpressionProtocol`. it will **ALWAYS** return `[]`
    /// Use the `Regex` struct,
    /// which also conforms to this protocol if you want to customize
    /// `matchingOptions`.
    public var matchingOptions: MatchingOptions { return [] }
    
    /// Exists only to satisfy the requirements of
    /// `RegularExpressionProtocol`. it will **ALWAYS** return `nil`
    /// Use the `Regex` struct,
    /// which also conforms to this protocol if you want to customize
    /// `groupNames`.
    public var groupNames: [String]? { return nil }
    
    
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
public func ~= <RegularExpression: RegexProtocol>(
    regex: RegularExpression?, value: String
) -> Bool {
    
    if let regex = regex {
        return (try? value.regexMatch(regex)) != nil
    }
    return false

}

