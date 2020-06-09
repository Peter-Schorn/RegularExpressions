import Foundation



public extension Collection {
    
    subscript(back i: Int) -> Element {
        let indx = self.index(self.endIndex, offsetBy: (-i))
        return self[indx]

        
    }
    
    subscript(safe i: Index?) -> Element? {
        get {
            guard let i = i else { return nil }
            return self.indices.contains(i) ? self[i] : nil
        }
    }
    
    subscript(backSafe i: Int?) -> Element? {
        
        guard let i = i else { return nil }
        
        let indx = self.index(self.endIndex, offsetBy: (-i))
        
        if self.indices.contains(indx) {
            return self[back: i]
        }
        
        return nil
    }
    
}




public extension Collection where Element: BinaryInteger {
    
    var average: Double {
        let total = self.reduce(Double(0), { $0 + Double($1) })
        return total / Double(self.count)
    }
    
}

public extension Collection where Element: BinaryFloatingPoint {
    
    
    var average: Element {
        let total = self.reduce(0, { $0 + $1 })
        return total / Element(self.count)
    }

}


public extension Collection where Index == Int {

    /// Splits Collection into an array of arrays,
    /// each of which will have the specified size.
    func chunked(size: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, self.count)])
        }
    }

}

