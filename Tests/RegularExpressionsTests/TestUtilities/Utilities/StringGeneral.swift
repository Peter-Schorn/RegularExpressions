import Foundation
import RegularExpressions


public extension String {
    
    enum StripOptions {
        case fileExt
    }
    
    func strip(_ stripOptions: StripOptions) -> String {
        switch stripOptions {
            case .fileExt:
                return try! self.regexSub(#"\.([^\.]*)$"#)
        }
    }
    
    /**
     Alias for self.trimmingCharacters(in: characterSet)
     ```
     func strip(_ characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
         return self.trimmingCharacters(in: characterSet)
     }
     ```
     */
    func strip(
        _ characterSet: CharacterSet = .whitespacesAndNewlines
    ) -> String {
        
        return self.trimmingCharacters(in: characterSet)
    }

    /// See String.strip.
    mutating func stripInPlace(
        _ characterSet: CharacterSet = .whitespacesAndNewlines
    ) {
    
        self = self.strip(characterSet)
    }

    /// See String.strip.
    mutating func stripInPlace(_ stripOptions: StripOptions) {
        self = self.strip(stripOptions)
    }
    
    /// Returns an array of each line in the string.
    ///
    /// This function simply calls
    /// ```
    /// self.components(separatedBy: .newlines)
    /// ```
    func lines() -> [String] {
        return self.components(separatedBy: .newlines)
    }
    
    /// Returns an array of each word in the string.
    ///
    /// A word is defined in terms of this regular expression pattern:
    /// ```
    /// \w+
    /// ```
    /// Returns an empty array if no words are found.
    func words() -> [String] {
        
        return try! self.regexFindAll(#"\w+"#).map { $0.fullMatch }

    }
    
    /// Returns a new string with self repeated the specified number of times.
    /// ```
    /// "a".multiplied(by: 4) == "aaaa"
    /// ```
    /// - Parameter amount: The number of time to repeat self.
    func multiplied(by amount: Int) -> String {
        
        return (1...amount).map { _ in return self }.joined()
    }
    
    /// Same as self.multiplied(by:), except the operation is performed in-place.
    mutating func multiply(by amount: Int) {
        self = self.multiplied(by: amount)
    }
    
    
    /// The full range of the string.
    /// Equivalent to `self.startIndex..<self.endIndex`.
    var fullRange: Range<String.Index> {
        return self.startIndex..<self.endIndex
    }
    
}
