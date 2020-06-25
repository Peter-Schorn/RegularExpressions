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
```swift
public init(
    pattern: String,
    regexOptions: NSRegularExpression.Options = [],
    matchingOptions: NSRegularExpression.MatchingOptions = [],
    groupNames: [String]? = nil
) throws {
```
Throws if the pattern is invalid.
```swift
public init(
    _ pattern: String,
    _ regexOptions: NSRegularExpression.Options = []
) throws {
```
Throws is the pattern is invalid.
```swift
public init(
    nsRegularExpression: NSRegularExpression,
    matchingOptions: NSRegularExpression.MatchingOptions = [],
    groupNames: [String]? = nil
) {
```
Creates a `Regex` object from an `NSRegularExpression`.

## Extracting the match and capture groups

`String.regexMatch` and `String.regexFindAll` both use the `RegexMatch` struct to hold the information about a regular expression match. It contains the following properties:
- `let sourceString: Substring` - The string that was matched against. A substring is used to reduce memory usage. Note that `SubString` presents the same interface as `String`
- `let fullMatch: String` - The full match of the pattern in the source string.
- `let range: Range<String.Index>` - The range of the full match in the source string.
- `let groups: [RegexGroup?]` - The capture groups.

`RegexMatch` also has a method to retrieve a group by name:  
`func group(named name: String) -> RegexGroup?`  
This function will return nil if the name was not found, **OR** if the group was not matched becase it was specified as optional in the regular expression pattern.

The `RegexGroup` struct has the following properties:
- `name: String?` - The name of the capture group.
- `match: String` - The matched capture group.
- `range: Range<String.Index>` - The range of the capture group in the source string.


## Finding the first match for a regular expression

`String.regexMatch` will return the first match for a regular expression in a string, or nil if no match was found. It has two overloads:
```swift
func regexMatch<RegularExpression: RegexProtocol>(
    _ regex: RegularExpression,
    range: Range<String.Index>? = nil
) throws -> RegexMatch? {
```
```swift
func regexMatch(
    _ pattern: String,
    regexOptions: NSRegularExpression.Options = [],
    matchingOptions: NSRegularExpression.MatchingOptions = [],
    groupNames: [String]? = nil,
    range: Range<String.Index>? = nil
) throws -> RegexMatch? {
```

`range` represents the range of the string in which to search for the pattern.
These methods with throw if the pattern is invalid, or if the or the number of group names does not match the number of capture groups (See [RegexError](https://github.com/Peter-Schorn/RegularExpressions/blob/d72d877857aba02c24865b7cf5f365c05265b686/Sources/RegularExpressions/RegexObjects.swift#L3)). They will **Never** throw an error if no matches are found.

Examples:
```swift
var inputText = "name: Chris Lattner"
// create the regular expression object
let regex = try! Regex(
    "name: ([a-z]+) ([a-z]+)", regexOptions: [.caseInsensitive]
)
 
if let match = try! inputText.regexMatch(regex) {
    print("full match: '\(match.fullMatch)'")
    print("first capture group: '\(match.groups[0]!.match)'")
    print("second capture group: '\(match.groups[1]!.match)'")
    
    // perform a replacement on the first capture group
    inputText.replaceSubrange(
        match.groups[0]!.range, with: "Steven"
    )
    
    print("after replacing text: '\(inputText)'")
}

// full match: 'name: Chris Lattner'
// first capture group: 'Chris'
// second capture group: 'Lattner'
// after replacing text: 'name: Steven Lattner'
```
```swift
let inputText = """
Man selects only for his own good: \
Nature only for that of the being which she tends.
"""
let pattern = #"Man selects ONLY FOR HIS OWN (\w+)"#

let searchRange =
        (inputText.startIndex)
        ..<
        (inputText.index(inputText.startIndex, offsetBy: 40))
        
let match = try inputText.regexMatch(
    pattern,
    regexOptions: [.caseInsensitive],
    matchingOptions: [.anchored],
    groupNames: ["word"],
    range: searchRange
)
if let match = match {
    print("full match:", match.fullMatch)
    print("capture group:", match.group(named: "word")!.match)
}

// full match: Man selects only for his own good
// capture group: good
```

## Finding all matches for a regular expression

`String.regexFindAll` will return all matches for a regular expression in a string, or an empty array if no matches were found. It has the exact same overloads as `String.regexMatch`:

```swift
func regexFindAll<RegularExpression: RegexProtocol>(
    _ regex: RegularExpression,
    range: Range<String.Index>? = nil
) throws -> [RegexMatch] {
```
```swift
func regexFindAll(
    _ pattern: String,
    regexOptions: NSRegularExpression.Options = [],
    matchingOptions: NSRegularExpression.MatchingOptions = [],
    groupNames: [String]? = nil,
    range: Range<String.Index>? = nil
) throws -> [RegexMatch] {
```
