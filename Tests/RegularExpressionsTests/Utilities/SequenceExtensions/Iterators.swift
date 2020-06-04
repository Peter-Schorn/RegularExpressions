import Foundation


/// Incrementally raises a number to a power.
///
/// if range == .open (default) then the loop continues until n `<` max.
/// if range == .closed then the loop continues until n `<=` max
public struct exponetiate<N: BinaryFloatingPoint>:
    Sequence, IteratorProtocol
{

    public enum RangeType {
        case open, closed
    }
    
    var value: N
    let power: N
    let max: N
    let cond: (N, N) -> Bool
    
    public init(start: N, power: N, max: N, range: RangeType = .open) {

        self.value = start
        self.power = power
        self.max   = max
        self.cond  = range == .open ? { $0 < $1 } : { $0 ≤ $1 }
        
    }
    
    public mutating func next() -> N? {
        
        if cond(value, max) {
            defer { value **= power }
            return value
        }
        return nil
        
    }
}


/**
 A C-style iterator.
 In these closures, $0 is the current value of the iterator.

 - Parameters:
  - init: The initial value
  - while: Executes after each iteration of the loop.
        The loop continues if it returns true and ends if it returns false.
  - update: Used to update the value after each iteration.
 
 In this example, i begins as 2 and is multiplied by two after each iteration.
 The iterator stops when i > 100
 ```
 for i in iterator(init: 2, while: { $0 <= 100 }, update: { $0 * 2 }) {
     print(i)
 }
 ```
 */
public struct c_iterator<T>:
    Sequence, IteratorProtocol
{

    var value: T
    let cond: (T) -> Bool
    let update: (T) -> T
    
    public init(
        init value: T,
        while cond: @escaping (T) -> Bool,
        update: @escaping (T) -> T
    ) {
        self.value = value
        self.cond = cond
        self.update = update
    }
    
    public mutating func next() -> T? {
        
        if cond(value) {
            defer { value = update(value) }
            return value
        }
        return nil
    }
    
}
