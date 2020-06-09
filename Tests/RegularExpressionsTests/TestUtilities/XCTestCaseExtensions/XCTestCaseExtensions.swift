#if canImport(XCTest)

import Foundation
import XCTest


public extension XCTestCase {

    typealias Opt = Optional

    /**
     Assert that `body` does not throw.
     If it does, call XCTFail with the `message`,
     (unless it is empty), the error thrown from body,
     and the file and line passed in.

     - Parameters:
       - message: The message to display if `body` throws.
       - file: The file the error should be displayed for.
       - line: The line number the error should be displayed for.
       - body: The block of code that might throw an error.
     */
    func assertNoThrow(
        _ message: String = "",
        file: StaticString = #file,
        line: UInt = #line,
        _ body: () throws -> Void
    ) {

        do {
            try body()

        } catch {
            let errorMsg = message.isEmpty ? "\(error)" : "\(message)\n\(error)"
            XCTFail(errorMsg, file: file, line: line)
        }
    }

}


#endif
