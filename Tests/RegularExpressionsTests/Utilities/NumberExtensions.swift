import Foundation


public let π = Double.pi


public extension Double {
    
   
    /**
     Alias for `String(format: specifier, self)`.
     see [String Format Specifiers](https://developer.a.com/library/archive/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html)
     - Parameter specifier: string format specifier.
     - Returns: formatted string
     */
    func format(_ specifier: String) -> String {
        return String(format: specifier, self)
    }

    enum FormatOption {
        case currency, stripTrailingZeros
    }
    
    /// Formats double according to specifier
    ///
    /// FormatOptions:
    /// - currency: prints dollar sign and two digits after decimal; e.g., $5.99
    /// - stripTrailingZeros: removes insignificant trailing zeros
    func format(_ specifier: FormatOption) -> String {
        
        switch specifier {
            case .currency:
                return self.format("$%.2f")
            case .stripTrailingZeros:
                return self.format("%g")
        }

    }

}

public func factorial<N: Numeric>(_ x: N) -> N {
    x == 0 ? 1 : x * factorial(x - 1)
}

/// performs modulo division on floating point numbers
public func % <N: BinaryFloatingPoint>(lhs: N, rhs: N) -> N {
    lhs.truncatingRemainder(dividingBy: rhs)
}


/**
 Tests whether two numbers are close to each other.
 - Parameters:
   - a: The first number.
   - b: The second numer.
   - rel_tol: The maximum allowed difference between a and b, expressed in
         terms of the percentage of the larger absolute value of a or b.
         Must be between 0 and 1, inclusive. 0.05 represents 5%.
   - abs_tol: The maximum allowed absolute difference between a and b.
         **Default: max(a, b).ulp**. Must be greater than or equal to 0.
 - Returns: true if the values a and b are close to each other and false otherwise.

 Uses the following boolean expression:
 ```
 abs(a - b) <= max(rel_tol * max(abs(a), abs(b)), abs_tol)
 ```
 If the difference bewteen a and b is within the relative tolerance,
 but not the absolute tolerance, or vice-versa, then this function returns true.
 This function is identical to Python's [math.isclose](https://docs.python.org/3/library/math.html?highlight=isclose#math.isclose)
 */
public func numsAreClose<N: FloatingPoint>(
    _ a: N, _ b: N, rel_tol: N = 0, abs_tol: N? = nil
) -> Bool {
    
    let absTol = abs_tol ?? max(a, b).ulp
    
    assert(
        (0...1).contains(rel_tol),
        "relative tolerance must be between zero and one (received \(rel_tol))"
    )
    assert(
        absTol ≥ 0,
        "absolute tolerance must be greater than zero (received \(absTol))"
    )
    
    return abs(a - b) ≤ max(rel_tol * max(abs(a), abs(b)), absTol)
    
}

/**
Tests whether two numbers are close to each other.
- Parameters:
  - a: the first number.
  - b: the second numer.
  - rel_tol: the maximum allowed difference between a and b, expressed in
        terms of the percentage of the larger absolute value of a or b.
        Must be between 0 and 1, inclusive. 0.05 represents 5%.
  - abs_tol: the maximum allowed absolute difference between a and b.
        Must be greater than or equal to 0.
- Returns: true if the values a and b are close to each other and false otherwise.

Uses the following boolean expression:
```
abs(a - b) <= max(rel_tol * max(abs(a), abs(b)), abs_tol)
```
If the difference bewteen a and b is within the relative tolerance,
but not the absolute tolerance, or vice-versa, then this function returns true.
This function is identical to Python's [math.isclose](https://docs.python.org/3/library/math.html?highlight=isclose#math.isclose)
*/
public func numsAreClose<N: BinaryInteger, F: BinaryFloatingPoint>(
    _ a: N, _ b: N, rel_tol: F = 0, abs_tol: F = 0
) -> Bool {
    return numsAreClose(F(a), F(b), rel_tol: rel_tol, abs_tol: abs_tol)
}
