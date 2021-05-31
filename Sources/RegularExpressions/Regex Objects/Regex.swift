import Foundation

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
    /// Exists to satisfy a requirement
    /// of `RegexProtocol`.
    public var regexOptions: Options { return self.options }
    
    /// Exists only to satisfy the requirements of
    /// `RegexProtocol`. It will **ALWAYS** return `[]`.
    /// Use the `Regex` struct or another struct that conforms to this
    /// protocol to customize these options.
    public var matchingOptions: MatchingOptions { return [] }
    
    /// Exists only to satisfy the requirements of
    /// `RegexProtocol`. It will **ALWAYS** return `nil`.
    /// Use the `Regex` struct or another struct that conforms to this
    /// protocol to customize the group names.
    public var groupNames: [String]? { return nil }
    
}

