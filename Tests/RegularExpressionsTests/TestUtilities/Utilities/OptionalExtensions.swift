import Foundation


/**
 Type-erases the wrapped value for Optional.
 This protocol allows for extending other protocols
 contingent on one or more of their associated types
 being any optional type.
 
 For example, this extension to Array adds an instance method
 that returns a new array in which each of the elements
 are either unwrapped or removed if nil. Use self.value
 to access the the conforming type as an optional
 ```
 extension Array where Element: AnyOptional {


     func removeIfNil() -> [Self.Element.Wrapped] {
         let result = self.compactMap { $0.value }

         return result
     }

 }
 ```
 */
public protocol AnyOptional {

    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: AnyOptional {

    /// Returns self. **Does not unwrap the value**
    @inlinable
    public var value: Wrapped? {
        return self
    }

}

public extension Sequence where Element: AnyOptional {

    /// Returns a new array in which each element in the collection
    /// is either unwrapped and added to the new array,
    /// or not added to the new array if nil.
    func removeIfNil() -> [Element.Wrapped] {
        let result = self.compactMap { $0.value }
        
        return result
    }
}
