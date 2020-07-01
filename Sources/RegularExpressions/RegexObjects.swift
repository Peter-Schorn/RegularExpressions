import Foundation

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
 /// The range of the capture group in the source string.
 public let range: Range<String.Index>
 ```
 */
public struct RegexGroup: Equatable, Hashable {
    
    /**
     Creates a regular expression capture group.
     
     - Parameters:
       - name: The name of the capture group.
       - match: The matched capture group.
       - range: The range of the capture group in the source string.
     
     The source string will be converted into a substring to minimize memory usage.
     */
    public init(
        match: String,
        range: Range<String.Index>,
        name: String? = nil
    ) {
        self.name = name
        self.match = match
        self.range = range
    }
    
    /// The name of the capture group.
    public let name: String?
    /// The matched capture group.
    public let match: String
    /// The range of the capture group in the source string.
    public let range: Range<String.Index>
}


/**
 A regular expression match.
 
 ```
 /// The string that was matched against.
 public let sourceString: Substring
 /// The full match of the pattern in the source string.
 public let fullMatch: String
 /// The range of the full match in the source string.
 public let range: Range<String.Index>
 /// The capture groups.
 public let groups: [RegexGroup?]
 
 /// Returns a `RegexGroup` by name.
 public func group(named name: String) -> RegexGroup?
 
 /// Performs a subsitution for each capture group
 /// using the provided closure.
 public func replaceGroups(_:) -> String
 ```
 */
public struct RegexMatch: Equatable, Hashable {
    
    
    /**
     Creates a regular expression match.
     
     - Parameters:
       - sourceString: The string that was matched against.
       - fullMatch: The full match of the pattern in the source string.
       - range: The range of the full match in the source string.
       - groups: The capture groups.
     
     The source string will be converted into a substring to minimize memory usage.
     */
    public init(
        sourceString: String,
        fullMatch: String,
        range: Range<String.Index>,
        groups: [RegexGroup?]
    ) {
        self.sourceString = sourceString[...]
        self.fullMatch = fullMatch
        self.range = range
        self.groups = groups
    }
    
    
    /// The string that was matched against.
    public let sourceString: Substring
    /// The full match of the pattern in the source string.
    public let fullMatch: String
    /// The range of the full match in the source string.
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
    
    /**
     Performs a subsitution for each capture group
     using the provided closure.
     
     - Parameters:
       - replacer: A closure that accepts
           the index of a capture group and a capture group
           and returns a new string to replace it with.
           Return nil from within the closure to indicate
           that the capture group should not be changed.
       - groupIndex: The index of the capture group in the regular expression match.
       - group: The regular expression capture group.
     - Returns: The new match after performing the subsitutions for
           each capture group.
     
     Example usage:
     ```
     let inputText = "name: Peter, id: 35, job: programmer"
     let pattern = #"name: (\w+), id: (\d+)"#
     let groupNames = ["name", "id"]
     
     let match = try inputText.regexMatch(
         pattern, groupNames: groupNames
     )!
     
     let replacedMatch = match.replaceGroups { indx, group in
         if group.name == "name" { return "Steven" }
         if group.name == "id" { return "55" }
         return nil
     }
     // match.fullMatch = "name: Peter, id: 35"
     // replacedMatch = "name: Steven, id: 55"
     ```
     */
    public func replaceGroups(
        _ replacer: (
            _ groupIndex: Int, _ group: RegexGroup
        ) -> String?
    ) -> String {
        
        var replacedString = ""
        var currentRange = (self.range.lowerBound)..<(self.range.lowerBound)
        for (indx, group) in self.groups.enumerated() {
            guard let group = group else { continue }
            
            replacedString += sourceString[currentRange.upperBound..<group.range.lowerBound]
            
            if let replacement = replacer(indx, group) {
                replacedString += replacement
            }
            else {
                replacedString += sourceString[group.range]
            }
            
            currentRange = group.range
        }

        replacedString += sourceString[currentRange.upperBound..<self.range.upperBound]
        return replacedString
        
    }
    
    
}



/**
 A type that encapsulate information about a regular expression.
 
 An object conforming to this protocol can be passed into all of the
 regular expression methods in this library, including
 regexMatch, regexFindAll, regexSub, and regexSplit.
 
 ```
 /// The regular expression pattern.
 var pattern: String { get }
 /// The regular expression options.
 var regexOptions: NSRegularExpression.Options { get }
 /// See NSRegularExpression.MatchingOptions
 var matchingOptions: NSRegularExpression.MatchingOptions { get }
 /// The names of the capture groups.
 var groupNames: [String]? { get }
 ```
 */
public protocol RegexProtocol {
    
    /// The regular expression pattern.
    var pattern: String { get }
    
    /// The regular expression options.
    var regexOptions: NSRegularExpression.Options { get }
    
    /// See [NSRegularExpression.MatchingOptions](https://developer.apple.com/documentation/foundation/nsregularexpression/matchingoptions)
    var matchingOptions: NSRegularExpression.MatchingOptions { get }
    
    /// The names of the capture groups.
    var groupNames: [String]? { get }
    
}

public extension RegexProtocol {
    
    /// Converts self to an NSRegularExpression.
    ///
    /// - Warning: The returned object will **NOT** have
    ///       the `groupNames` or `matchingOptions`.
    ///
    /// - Throws: If the pattern is invalid.
    func asNSRegex() throws -> NSRegularExpression {
        
        if let nsRegex = self as? NSRegularExpression {
            return nsRegex
        }
        
        return try NSRegularExpression(
            pattern: pattern, options: regexOptions
        )
    }
    
    /// Returns the number of capture groups in the regular expression.
    ///
    /// Calls through to [NSRegularExpression.numberOfCaptureGroups](https://developer.apple.com/documentation/foundation/nsregularexpression/1415052-numberofcapturegroups)
    /// - Throws: If the pattern is invalid.
    func numberOfCaptureGroups() throws -> Int {
        if let nsRegex = self as? NSRegularExpression {
            return nsRegex.numberOfCaptureGroups
        }
        return try NSRegularExpression(
            pattern: pattern, options: regexOptions
        ).numberOfCaptureGroups
    }
    
    /// Returns true if the regular expression pattern is valid. Else false.
    ///
    /// Takes into consideration the regular expression options, such as
    /// `.ignoreMetacharacters`.
    func patternIsValid() -> Bool {
        return (try? self.asNSRegex()) != nil
    }
    
    /// Returns true if the regular expression pattern is valid. Else false.
    ///
    /// Takes into consideration the regular expression options, such as
    /// `.ignoreMetacharacters`.
    static func patternIsValid(
        pattern: String,
        options: NSRegularExpression.Options = []
    ) -> Bool {
        return (try? NSRegularExpression(pattern: pattern, options: options)) != nil
    }
    
}

/**
 Encapsulates information about a regular expression.
 
 An instance of this struct can be passed into all of the
 regular expression methods in this library, including
 regexMatch, regexFindAll, regexSub, and regexSplit.
 
 ```
 /// The regular expression pattern.
 var pattern: String { get }
 /// The regular expression options.
 var regexOptions: NSRegularExpression.Options { get }
 /// See NSRegularExpression.MatchingOptions
 var matchingOptions: NSRegularExpression.MatchingOptions { get }
 /// The names of the capture groups.
 var groupNames: [String]? { get }
 ```
 */
public struct Regex: RegexProtocol, Equatable {
    
    public var pattern: String
    public var regexOptions: NSRegularExpression.Options
    public var matchingOptions: NSRegularExpression.MatchingOptions
    public var groupNames: [String]?
    
    /**
     Creates a regular expression object.
    
     - Parameters:
       - pattern: A regular expression pattern.
       - regexOptions: The options for the regular expression,
             such as `.caseInsensitive`.
       - matchingOptions: See [NSRegularExpression.MatchingOptions](https://developer.apple.com/documentation/foundation/nsregularexpression/matchingoptions)
       - groupNames: The names of the capture groups.
     - Throws: If the regular expression pattern is invalid.
     */
    public init(
        pattern: String,
        regexOptions: NSRegularExpression.Options = [],
        matchingOptions: NSRegularExpression.MatchingOptions = [],
        groupNames: [String]? = nil
    ) throws {
        
        // validate the regular expression
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
       - pattern: A regular expression pattern.
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
      - matchingOptions: See [NSRegularExpression.MatchingOptions](https://developer.apple.com/documentation/foundation/nsregularexpression/matchingoptions)
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
    
    /// Alias for self.[options](https://developer.apple.com/documentation/foundation/nsregularexpression/options)
    /// Exists to satsify a requirement
    /// of `RegexProtocol`.
    public var regexOptions: Options { self.options }
    
    /// Exists only to satisfy the requirements of
    /// `RegexProtocol`. It will **ALWAYS** return `[]`.
    /// Use the `Regex` struct or another struct that conforms to this
    /// protocol to customize these options.
    public var matchingOptions: MatchingOptions { [] }
    
    /// Exists only to satisfy the requirements of
    /// `RegexProtocol`. It will **ALWAYS** return `nil`.
    /// Use the `Regex` struct or another struct that conforms to this
    /// protocol to customize the group names.
    public var groupNames: [String]? { nil }
    
}



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

