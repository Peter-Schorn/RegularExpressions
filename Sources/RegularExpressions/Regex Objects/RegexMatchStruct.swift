import Foundation

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
            
            replacedString += sourceString[
                currentRange.upperBound..<group.range.lowerBound
            ]
            
            if let replacement = replacer(indx, group) {
                replacedString += replacement
            }
            else {
                replacedString += sourceString[group.range]
            }
            
            currentRange = group.range
        }

        replacedString += sourceString[
            currentRange.upperBound..<self.range.upperBound
        ]
        return replacedString
        
    }
    
    
}
