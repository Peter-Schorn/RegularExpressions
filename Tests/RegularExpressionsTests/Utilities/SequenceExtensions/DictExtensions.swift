import Foundation


public extension Dictionary {
    
    func valuesArray() -> [Dictionary.Value] {
        return Array(self.values)
    }
    func keysArray() -> [Dictionary.Key] {
        return Array(self.keys)
    }
    
}


