import Foundation


public func offsetStrRange(
    _ string: String, range: Range<String.Index>, by num: Int
) -> Range<String.Index> {
    
    return string.index(range.lowerBound, offsetBy: num)
           ..<
           string.index(range.upperBound, offsetBy: num)

}

public func offsetStrRange(
    _ string: String, range: ClosedRange<String.Index>, by num: Int
) -> ClosedRange<String.Index> {
    
    return string.index(range.lowerBound, offsetBy: num)
           ...
           string.index(range.upperBound, offsetBy: num)

}


public extension String {

    /**
     Enables passing in negative indices to access characters
     starting from the end and going backwards.
     if num is negative, then it is added to the
     length of the string to retrieve the true index.
     */
    func negativeIndex(_ num: Int) -> Int {
        return num < 0 ? num + self.count : num
    }

    func openRange(index i: Int) -> Range<String.Index> {
        let j = negativeIndex(i)
        return self.openRange(j..<(j + 1), checkNegative: false)
    }

    func openRange(
        _ range: Range<Int>, checkNegative: Bool = true
    ) -> Range<String.Index> {

        var lower = range.lowerBound
        var upper = range.upperBound

        if checkNegative {
            lower = negativeIndex(lower)
            upper = negativeIndex(upper)
        }
        
        let idx1 = self.index(self.startIndex, offsetBy: lower)
        let idx2 = self.index(self.startIndex, offsetBy: upper)
        
        return idx1..<idx2
    }
    

    func closedRange(
        _ range: CountableClosedRange<Int>, checkNegative: Bool = true
    ) -> ClosedRange<String.Index> {
        
        var lower = range.lowerBound
        var upper = range.upperBound

        if checkNegative {
            lower = negativeIndex(lower)
            upper = negativeIndex(upper)
        }
        
        let start = self.index(self.startIndex, offsetBy: lower)
        let end = self.index(start, offsetBy: upper - lower)
        
        return start...end
    }

    // MARK: - Subscripts

    /**
     Gets and sets a character at a given index.
     Negative indices are added to the length so that
     characters can be accessed from the end backwards.
     [-1] accesses the last character, [-2] the second last,
     and so on.
     
     - Attention: The time complexity of this and the below subscripts is O(n).
     
     Usage: `string[n]`
     */
    subscript(_ i: Int) -> String {
        get {
            return String(self[self.openRange(index: i)])
        }
        set {
            let range = self.openRange(index: i)
            self.replaceSubrange(range, with: newValue)
        }
    }


    /**
     Gets and sets characters in a half-open range.
     Supports negative indexing.
     
     Usage: `string[n..<n]`
     */
    subscript(_ r: Range<Int>) -> String {
        get {
            return String(self[self.openRange(r)])
        }
        set {
            self.replaceSubrange(self.openRange(r), with: newValue)
        }
    }

    /**
     Gets and sets characters in a closed range.
     Supports negative indexing
     
     Usage: `string[n...n]`
     */
    subscript(_ r: CountableClosedRange<Int>) -> String {
        get {
            return String(self[self.closedRange(r)])
        }
        set {
            self.replaceSubrange(self.closedRange(r), with: newValue)
        }
    }

    /// `string[n...]`. See PartialRangeFrom
    subscript(_ r: PartialRangeFrom<Int>) -> String {
        
        get {
            return String(self[self.openRange(r.lowerBound..<self.count)])
        }
        set {
            self.replaceSubrange(self.openRange(r.lowerBound..<self.count), with: newValue)
        }
    }

    /// `string[...n]`. See PartialRangeThrough
    subscript(_ r: PartialRangeThrough<Int>) -> String {
        
        get {
            let upper = negativeIndex(r.upperBound)
            return String(self[self.closedRange(0...upper, checkNegative: false)])
        }
        set {
            let upper = negativeIndex(r.upperBound)
            self.replaceSubrange(
                self.closedRange(0...upper, checkNegative: false), with: newValue
            )
        }
    }

    /// `string[...<n]`. See PartialRangeUpTo
    subscript(_ r: PartialRangeUpTo<Int>) -> String {
        
        get {
            let upper = negativeIndex(r.upperBound)
            return String(self[self.openRange(0..<upper, checkNegative: false)])
        }
        set {
            let upper = negativeIndex(r.upperBound)
            self.replaceSubrange(
                self.openRange(0..<upper, checkNegative: false), with: newValue
            )
        }
        
        
    }
    
}
