//
//  File.swift
//  
//
//  Created by Peter Schorn on 7/25/20.
//

import Foundation

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
