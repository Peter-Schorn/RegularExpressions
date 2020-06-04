import Foundation


public extension Sequence where Element: Numeric {
    
    /// returns the sum of the elements in a sequence
    var sum: Element { self.reduce(0, +) }

}



public extension Sequence {
    
    /// Returns true if the closure returns true for any of the elements
    /// in the sequence. Else false.
    func any(_ predicate: (Element) throws -> Bool ) rethrows -> Bool {
        
        for element in self {
            if try predicate(element) { return true }
        }
        return false
    
    }

    
}


public extension Sequence where Element: Hashable  {
    
    var hasDuplicates: Bool {
        
        var seen: Set<Element> = []
        
        for item in self {
            if !seen.insert(item).inserted {
                return true
            }
        }
        
        return false
    }
    
}

public extension Sequence where Element: Equatable {
    
    var hasDuplicates: Bool {
        
        var seen: [Element] = []
        
        for item in self {
            if seen.contains(item) {
                return true
            }
            seen.append(item)
        }
        
        return false
    }
    
}


public extension Sequence where Element == Character {

    /// Join sequence of characters into String with separator
    func joined(separator: String = "") -> String {
        var string = ""
        for (indx, char) in self.enumerated() {
            if indx > 0 {
                string.append(separator)
            }
            string.append(char)
        }
        return string
    }

}
