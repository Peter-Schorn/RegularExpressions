import Foundation


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
