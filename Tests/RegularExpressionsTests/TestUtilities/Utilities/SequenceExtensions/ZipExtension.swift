import Foundation


/// An overload for the zip function
/// that supports three sequences.
/// See also `zip(_:_)`.
@inlinable
public func zip<S1: Sequence, S2: Sequence, S3: Sequence>(
  _ sequence1: S1, _ sequence2: S2, _ sequence3: S3
) -> Zip3Sequence<S1, S2, S3> {
  
    return Zip3Sequence(sequence1, sequence2, sequence3)
}

/// An overload for the zip function
/// that supports four sequences.
/// See also `zip(_:_)`.
@inlinable
public func zip<S1: Sequence, S2: Sequence, S3: Sequence, S4: Sequence>(
  _ sequence1: S1, _ sequence2: S2, _ sequence3: S3, _ sequence4: S4
) -> Zip4Sequence<S1, S2, S3, S4> {
  
    return Zip4Sequence(sequence1, sequence2, sequence3, sequence4)
}

/// An overload for the zip function
/// that supports five sequences.
/// See also `zip(_:_)`.
@inlinable
public func zip<S1: Sequence, S2: Sequence, S3: Sequence, S4: Sequence, S5: Sequence>(
  _ sequence1: S1, _ sequence2: S2, _ sequence3: S3, _ sequence4: S4, _ sequence5: S5
) -> Zip5Sequence<S1, S2, S3, S4, S5> {
  
    return Zip5Sequence(sequence1, sequence2, sequence3, sequence4, sequence5)
}



public struct Zip3Sequence<
    S1: Sequence, S2: Sequence, S3: Sequence
>:
    IteratorProtocol, Sequence
{
    
    public typealias Element = (S1.Element, S2.Element, S3.Element)
    
    @usableFromInline
    var s1: S1.Iterator
    @usableFromInline
    var s2: S2.Iterator
    @usableFromInline
    var s3: S3.Iterator
    @usableFromInline
    var reachedEnd = false
    
    @inlinable
    init(_ s1: S1, _ s2: S2, _ s3: S3) {
        self.s1 = s1.makeIterator()
        self.s2 = s2.makeIterator()
        self.s3 = s3.makeIterator()
    }
    
    @inlinable
    public mutating func next() -> Element? {
        
        if reachedEnd { return nil }
        
        guard let element1 = s1.next(),
              let element2 = s2.next(),
              let element3 = s3.next() else {
            
            reachedEnd = true
            return nil
        }
        
        return (element1, element2, element3)
        
        
    }
    
}

public struct Zip4Sequence<
    S1: Sequence, S2: Sequence, S3: Sequence, S4: Sequence
>:
    IteratorProtocol, Sequence
{
    
    public typealias Element = (S1.Element, S2.Element, S3.Element, S4.Element)

    @usableFromInline
    var s1: S1.Iterator
    @usableFromInline
    var s2: S2.Iterator
    @usableFromInline
    var s3: S3.Iterator
    @usableFromInline
    var s4: S4.Iterator
    @usableFromInline
    var reachedEnd = false
    
    @inlinable
    init(_ s1: S1, _ s2: S2, _ s3: S3, _ s4: S4) {
        self.s1 = s1.makeIterator()
        self.s2 = s2.makeIterator()
        self.s3 = s3.makeIterator()
        self.s4 = s4.makeIterator()
    }
    
    @inlinable
    public mutating func next() -> Element? {
        
        if reachedEnd { return nil }
        
        guard let element1 = s1.next(),
              let element2 = s2.next(),
              let element3 = s3.next(),
              let element4 = s4.next() else {
            
            reachedEnd = true
            return nil
        }
        
        return (element1, element2, element3, element4)
        
        
    }
    
}

public struct Zip5Sequence<
    S1: Sequence, S2: Sequence, S3: Sequence, S4: Sequence, S5: Sequence
>:
    IteratorProtocol, Sequence
{
    
    public typealias Element = (
        S1.Element, S2.Element, S3.Element, S4.Element, S5.Element
    )

    @usableFromInline
    var s1: S1.Iterator
    @usableFromInline
    var s2: S2.Iterator
    @usableFromInline
    var s3: S3.Iterator
    @usableFromInline
    var s4: S4.Iterator
    @usableFromInline
    var s5: S5.Iterator
    @usableFromInline
    var reachedEnd = false
    
    @inlinable
    init(_ s1: S1, _ s2: S2, _ s3: S3, _ s4: S4, _ s5: S5) {
        self.s1 = s1.makeIterator()
        self.s2 = s2.makeIterator()
        self.s3 = s3.makeIterator()
        self.s4 = s4.makeIterator()
        self.s5 = s5.makeIterator()
    }
    
    @inlinable
    public mutating func next() -> Element? {
        
        if reachedEnd { return nil }
        
        guard let element1 = s1.next(),
              let element2 = s2.next(),
              let element3 = s3.next(),
              let element4 = s4.next(),
              let element5 = s5.next() else {
            
            reachedEnd = true
            return nil
        }
        
        return (element1, element2, element3, element4, element5)
        
        
    }
    
}
