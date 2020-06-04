
import Foundation
import SwiftUI


public func UtilitiesTest() {
    print("hello from the Utilities package!")
}


/// Does nothing
public func pass() { }


/// Accepts an array as input and forwards it to the print function
/// as a variadic parameter. Also accepts a separator and terminator,
/// with the same behavior as the print function.
public func unpackPrint(
    _ items: [Any], separator: String = " ", terminator: String = "\n"
) {
    unsafeBitCast(
        print, to: (([Any], String, String) -> Void).self
    )(items, separator, terminator)
}

/// Prints items with the specififed padding before and after
public func paddedPrint(
    _ items: Any...,
    separator: String = " ",
    terminator: String = "\n",
    padding: String = "\n\n"
) {

    print(padding, terminator: "")
    unpackPrint(items, separator: separator, terminator: terminator)
    print(padding, terminator: "")

}


/**
 See Hasher
 
 Body of function:
 ```
 var hasher = Hasher()
 for i in object {
     hasher.combine(i)
 }
 return hasher.finalize()
 ```
 */
func makeHash<H: Hashable>(_ object: H...) -> Int {
    
    var hasher = Hasher()
    for i in object {
        hasher.combine(i)
    }
    return hasher.finalize()
    
}




/// Returns true if any of the arguments are true.
public func any(_ expressions: [Bool]) -> Bool {
    for i in expressions {
        if i { return true }
    }
    return false
}

/// Returns true if any of the arguments are true.
public func any(_ expressions: Bool...) -> Bool {
    return any(expressions)
}


/// Returns true if all of the arguments are true.
public func all(_ expressions: [Bool]) -> Bool {
    for i in expressions {
        if !i { return false }
    }
    return true
}

/// Returns true if all of the arguments are true
public func all(_ expressions: Bool...) -> Bool {
    return all(expressions)
}
