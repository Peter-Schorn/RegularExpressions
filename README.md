# RegularExpressions

**A regular expressions library for Swift**

## Features

- `func String.regexFindall` - Finds all matches for a regular expression.
- `func String.regexMatch` - Finds the first match for a regular expression.
- `func String.regexSplit`- Splits a string by occurences of a pattern into an array.
- `func String.regexSub` - Performs a regular expression replacement.
- `protocol RegexProtocol` - A type that encapsulates information about a regular expression.
- `struct Regex` - Encapsulates information about a regular expression. Conforms to `RegexProtocol`.

## Using a regular expression object

All of the above methods accept an object conforming to `RegexProtocol`. This object holds information about a regular expression, including:
- `var pattern: String { get }` - The regular expression pattern.
- `var regexOptions: NSRegularExpression.Options { get }` - The regular expression options (see [NSRegularExpression.Options](https://developer.apple.com/documentation/foundation/nsregularexpression/options)).
- `var matchingOptions: NSRegularExpression.MatchingOptions { get }` - See [NSRegularExpression.MatchingOptions](https://developer.apple.com/documentation/foundation/nsregularexpression/matchingoptions).
- `var groupNames: [String]? { get }` - The names of the capture groups.

`RegexProtocol` also defines a number of convienence methods:

`func asNSRegex() throws -> NSRegularExpression`  
Converts self to an NSRegularExpression.

`func numberOfCaptureGroups() throws -> Int`  
Returns the number of capture groups in the regular expression.

`func patternIsValid() -> Bool`  
Returns true if the regular expression pattern is valid. Else false.

`NSRegularExpression` has been extended to conform to `RegexProtocol`, but it **ALWAYS** returns `[]` and `nil` for the `matchingOptions` and `groupNames` properties, respectively. Use `Regex` or another type that conforms to `RegexProtocol` to customize these options.

### Initializing a `Regex` struct
```
public init(
    pattern: String,
    regexOptions: NSRegularExpression.Options = [],
    matchingOptions: NSRegularExpression.MatchingOptions = [],
    groupNames: [String]? = nil
) throws {
```
Throws if the pattern is invalid.
```
public init(
    _ pattern: String,
    _ regexOptions: NSRegularExpression.Options = []
) throws {
```
Throws is the pattern is invalid.
```
public init(
    nsRegularExpression: NSRegularExpression,
    matchingOptions: NSRegularExpression.MatchingOptions = [],
    groupNames: [String]? = nil
) {
```
Creates a `Regex` object from an `NSRegularExpression`.
