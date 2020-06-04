import Foundation
import SwiftUI
import RegularExpressions


/// Adds the ability to throw an error with a custom message
/// Usage: `throw "There was an error"`
extension String: Error, LocalizedError {
    
    public var errorDescription: String? {
        return self
    }
    
}


public extension String {
    
    
    enum StripOptions {
        case fileExt
    }
    
    func strip(_ stripOptions: StripOptions) -> String {
        switch stripOptions {
            case .fileExt:
                return self.regexSub(#"\.([^\.]*)$"#)
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
    func strip(_ characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        return self.trimmingCharacters(in: characterSet)
    }

    /// See String.strip.
    mutating func stripInPlace(_ characterSet: CharacterSet = .whitespacesAndNewlines) {
        self = self.strip(characterSet)
    }

    /// See String.strip.
    mutating func stripInPlace(_ stripOptions: StripOptions) {
        self = self.strip(stripOptions)
    }
    
    
    /// Alias for .components(separatedBy: separator)
    func split(_ separator: String) -> [String] {
        return self.components(separatedBy: separator)
    }
    
    enum PercentEncodingOptions {
        case query
        case host
        case path
        case user
        case fragment
        case password
    }
       
   /// Thin wrapper for self.addingPercentEncoding(
   /// withAllowedCharacters: CharacterSet)
    func percentEncoded(for option: PercentEncodingOptions) -> String? {
       
        let encodingOption: CharacterSet
        switch option {
            case .query:
                encodingOption = .urlQueryAllowed
            case .host:
                encodingOption = .urlHostAllowed
            case .path:
                encodingOption = .urlPathAllowed
            case .user:
                encodingOption = .urlUserAllowed
            case .fragment:
                encodingOption = .urlFragmentAllowed
            case .password:
                encodingOption = .urlPasswordAllowed
        }
       
        return self.addingPercentEncoding(
            withAllowedCharacters: encodingOption
        )
       
    }
    
    
    /// Returns an array of each line in the string
    func lines() -> [String] {
        
        return self.split(separator: "\n").map { String($0) }
        
    }
    
    /// Returns an array of each word in the string
    func words() -> [String] {
        
        if let matches = try! self.regexFindAll(#"\w+"#) {
            return matches.map { $0.fullMatch }
        }
        return []

    }
    
    /// Returns a new string with self repeated the specified number of times.
    /// ```
    /// "a".multiplied(by: 4) == "aaaa"
    /// ```
    func multiplied(by amount: Int) -> String {
        
        return (1...amount).map { _ in self }.joined()
    }
    
    /// See self.multiplied(by:).
    mutating func multiply(by amount: Int) {
        self = self.multiplied(by: amount)
    }
        
    
}

// MARK: - String interpolations

public protocol CustomStringInterpolation {
    mutating func appendInterpolation(_: String)
}

public extension CustomStringInterpolation {
    mutating func appendInterpolation(_ value: Double, numFormat: String) {
        appendInterpolation(value.format(numFormat))
    }
    mutating func appendInterpolation(_ value: Double, numFormat: Double.FormatOption) {
        appendInterpolation(value.format(numFormat))
    }
}

@available(macOS 10.15, *)
extension LocalizedStringKey.StringInterpolation: CustomStringInterpolation { }
extension String.StringInterpolation: CustomStringInterpolation { }
