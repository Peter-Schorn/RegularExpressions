# RegularExpressions

**A regular expressions library for Swift**

- #### [Introduction](https://github.com/Peter-Schorn/RegularExpressions/blob/master/README.md#introduction)
- #### [Installation](https://github.com/Peter-Schorn/RegularExpressions/blob/master/README.md#installation-1)
- #### [Using a regular expression object](https://github.com/Peter-Schorn/RegularExpressions/blob/master/README.md#using-a-regular-expression-object-1)
  - [Initializing a Regex struct](https://github.com/Peter-Schorn/RegularExpressions/blob/master/README.md#initializing-a-regex-struct)
- #### [Extracting the matches and capture groups](https://github.com/Peter-Schorn/RegularExpressions/blob/master/README.md#extracting-the-matches-and-capture-groups-1)
- #### [Finding the first match for a regular expression](https://github.com/Peter-Schorn/RegularExpressions/blob/master/README.md#finding-the-first-match-for-a-regular-expression-1)
- #### [Finding all matches for a regular expression](https://github.com/Peter-Schorn/RegularExpressions/blob/master/README.md#finding-all-matches-for-a-regular-expression-1)
- #### [Splitting a string by occurences of a pattern](https://github.com/Peter-Schorn/RegularExpressions/blob/master/README.md#splitting-a-string-by-occurences-of-a-pattern-1)
- #### [Performing regular expression replacements](https://github.com/Peter-Schorn/RegularExpressions/blob/master/README.md#performing-regular-expression-replacements-1)
  - [Performing regular expression replacements with a custom closure](https://github.com/Peter-Schorn/RegularExpressions/blob/master/README.md#performing-regular-expression-replacements-with-a-custom-closure)
- #### [Checking for regular expression matches in a switch statement](https://github.com/Peter-Schorn/RegularExpressions/blob/master/README.md#checking-for-regular-expression-matches-in-a-switch-statement-1)

## Introduction

This library uses [NSRegularExpression](https://developer.apple.com/documentation/foundation/nsregularexpression) to perform the actual logic of regular expression pattern matching.
However, it presents a much cleaner interface and was expliticty designed to take full advantage of swift. The supported syntax for the regular expressions can be found [here](http://userguide.icu-project.org/strings/regexp). You should also see [NSRegularExpression.Options](https://developer.apple.com/documentation/foundation/nsregularexpression/options) and [NSRegularExpression.MatchingOptions](https://developer.apple.com/documentation/foundation/nsregularexpression/matchingoptions). I reccomend using https://regex101.com/ for testing your regular expression patterns.

## Installation

#### Swift Package Manager (recommended)

1. In Xcode, open the project that you want to add this package to.
2. From the menu bar, select File > Swift Packages > Add Package Dependency...
3. Paste the [url](https://github.com/Peter-Schorn/RegularExpressions.git) for this repository into the search field.
4. Follow the prompts for adding the package.

#### Cocoa Pods

Add this to your `Podfile`:
```
pod 'RegularExpressions', :git => 'https://github.com/Peter-Schorn/RegularExpressions.git'
```

## Using a regular expression object

`Strin.regexMatch`, `String.regexFindAll`, `String.regexSub`, and `String.regexSplit` all accept an object that conforms to `RegexProtocol`. This object holds information about a regular expression, including:
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

**The `Regex` struct provided by this library conforms to `RegexProtocol` and is the simplest way to create a regular expression object.**

### Initializing a `Regex` struct
```swift
init(
    pattern: String,
    regexOptions: NSRegularExpression.Options = [],
    matchingOptions: NSRegularExpression.MatchingOptions = [],
    groupNames: [String]? = nil
) throws {
```
Throws if the pattern is invalid.
```swift
init(
    _ pattern: String,
    _ regexOptions: NSRegularExpression.Options = []
) throws {
```
Throws is the pattern is invalid.
```swift
init(
    nsRegularExpression: NSRegularExpression,
    matchingOptions: NSRegularExpression.MatchingOptions = [],
    groupNames: [String]? = nil
) {
```
Creates a `Regex` object from an `NSRegularExpression`.

## Extracting the matches and capture groups

`String.regexMatch` and `String.regexFindAll` both use the `RegexMatch` struct to hold the information about a regular expression match. It contains the following properties:
- `let sourceString: Substring` - The string that was matched against. A substring is used to reduce memory usage. Note that `SubString` presents the same interface as `String`.
- `let fullMatch: String` - The full match of the pattern in the source string.
- `let range: Range<String.Index>` - The range of the full match in the source string.
- `let groups: [RegexGroup?]` - The capture groups.

`RegexMatch` also has a method to retrieve a group by name:  
`func group(named name: String) -> RegexGroup?`  
This function will return nil if the name was not found, **OR** if the group was not matched becase it was specified as optional in the regular expression pattern.

The `RegexGroup` struct, which holds information about the capture groups, has the following properties:
- `let name: String?` - The name of the capture group.
- `let match: String` - The matched capture group.
- `let range: Range<String.Index>` - The range of the capture group in the source string.


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
The `pattern`, `regexOptions`, `matchingOptions`, and `groupNames` parameters correspond to the instance properties of [RegexProtocol](https://github.com/Peter-Schorn/RegularExpressions/blob/master/README.md#using-a-regular-expression-object-1).  
`range` represents the range of the string in which to search for the pattern.  
These methods with throw if the pattern is invalid, or if the number of group names does not match the number of capture groups (See [RegexError](https://github.com/Peter-Schorn/RegularExpressions/blob/d72d877857aba02c24865b7cf5f365c05265b686/Sources/RegularExpressions/RegexObjects.swift#L3)). They will **Never** throw an error if no matches are found.  
See [Extracting the match and capture groups](https://github.com/Peter-Schorn/RegularExpressions/blob/master/README.md#extracting-the-match-and-capture-groups) for information about the `RegexMatch` returned by these functions.  

**Warning**: The ranges of the matches and capture groups may be invalidated if you mutate the source string. Use [String.regexsub](https://github.com/Peter-Schorn/RegularExpressions/blob/master/README.md#performing-regular-expression-replacements-1) to perform multiple replacements.
           
Examples:
```swift
var inputText = "name: Chris Lattner"

// create the regular expression object
let regex = try Regex(
    pattern: "name: ([a-z]+) ([a-z]+)",
    regexOptions: [.caseInsensitive]
)
 
if let match = try inputText.regexMatch(regex) {
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
    matchingOptions: [.anchored],  // anchor matches to the beginning of the string
    groupNames: ["word"],  // the names of the capture groups
    range: searchRange  // the range of the string in which to search for the pattern
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
**Warning**: The ranges of the matches and capture groups may be invalidated if you mutate the source string. Use [String.regexsub](https://github.com/Peter-Schorn/RegularExpressions/blob/master/README.md#performing-regular-expression-replacements-1) to perform multiple replacements.  

The `pattern`, `regexOptions`, `matchingOptions`, and `groupNames` parameters correspond to the instance properties of [RegexProtocol](https://github.com/Peter-Schorn/RegularExpressions/blob/master/README.md#using-a-regular-expression-object-1).  
As with `String.regexMatch`, `range` represents the range of the string in which to search for the pattern.  
These methods with throw if the pattern is invalid, or if the number of group names does not match the number of capture groups (See [RegexError](https://github.com/Peter-Schorn/RegularExpressions/blob/d72d877857aba02c24865b7cf5f365c05265b686/Sources/RegularExpressions/RegexObjects.swift#L3)). They will **Never** throw an error if no matches are found.  
See [Extracting the match and capture groups](https://github.com/Peter-Schorn/RegularExpressions/blob/master/README.md#extracting-the-match-and-capture-groups) for information about the `RegexMatch` returned by these functions.  

Examples:
```swift
var inputText = "season 8, EPISODE 5; season 5, episode 20"

// create the regular expression object
let regex = try Regex(
    pattern: #"season (\d+), Episode (\d+)"#,
    regexOptions: [.caseInsensitive],
    groupNames: ["season number", "episode number"]
    // the names of the capture groups
)
        
let results = try inputText.regexFindAll(regex)
for result in results {
    print("fullMatch: '\(result.fullMatch)'")
    print("capture groups:")
    for captureGroup in result.groups {
        print("    \(captureGroup!.name!): '\(captureGroup!.match)'")
    }
    print()
}
let firstResult = results[0]
// perform a replacement on the first full match
inputText.replaceSubrange(
    firstResult.range, with: "new value"
)
print("after replacing text: '\(inputText)'")

// fullMatch: 'season 8, EPISODE 5'
// capture groups:
//     'season number': '8'
//     'episode number': '5'
//
// fullMatch: 'season 5, episode 20'
// capture groups:
//     'season number': '5'
//     'episode number': '20'
//
// after replacing text: 'new value; season 5, episode 20'
```

## Splitting a string by occurences of a pattern

`String.regexSplit` will split a string by occurences of a pattern.

```swift
func regexSplit(
    _ pattern: String,
    regexOptions: NSRegularExpression.Options = [],
    matchingOptions: NSRegularExpression.MatchingOptions = [],
    ignoreIfEmpty: Bool = false,
    maxLength: Int? = nil,
    range: Range<String.Index>? = nil
) throws -> [String] {
```
```swift
func regexSplit<RegularExpression: RegexProtocol>(
    _ regex: RegularExpression,
    ignoreIfEmpty: Bool = false,
    maxLength: Int? = nil,
    range: Range<String.Index>? = nil
) throws -> [String] {
```
The `pattern`, `regexOptions`, `matchingOptions`, and `groupNames` parameters correspond to the instance properties of [RegexProtocol](https://github.com/Peter-Schorn/RegularExpressions/blob/master/README.md#using-a-regular-expression-object-1).  
- `ignoreIfEmpty` - If true, all empty strings will be removed from the array. If false (default), they will be included.
- `maxLength` - The maximum length of the returned array. If nil (default), then the string is split on every occurence of the pattern.
- **Returns** An array of strings split on each occurence of the pattern. If no occurences of the pattern are found, then a single-element array containing the entire string will be returned.  

Examples:
```swift
let colors = "red,orange,yellow,blue"
let array = try colors.regexSplit(",")
print(array)

// array = ["red", "orange", "yellow", "blue"]
```
```swift
let colors = "red and orange ANDyellow and    blue"

// create the regular expression object
let regex = try Regex(#"\s*and\s*"#, [.caseInsensitive])

let array = try colors.regexSplit(regex, maxLength: 3)
print(array)

// array = ["red", "orange", "yellow"]
// note that "blue" is not returned because the length of the
// array was limited to 3 items.
```

## Performing regular expression replacements

`String.regexSub` and `String.regexSubInPlace` will perform regular expression replacements. They have the exact same arguments and overloads.

```swift
func regexSub(
    _ pattern: String,
    with template: String = "",
    regexOptions: NSRegularExpression.Options = [],
    matchingOptions: NSRegularExpression.MatchingOptions = [],
    range: Range<String.Index>? = nil
) throws -> String {
```
```swift
func regexSub<RegularExpression: RegexProtocol>(
    _ regex: RegularExpression,
    with template: String = "",
    range: Range<String.Index>? = nil
) throws -> String {
```
The `pattern`, `regexOptions`, `matchingOptions`, and `groupNames` parameters correspond to the instance properties of [RegexProtocol](https://github.com/Peter-Schorn/RegularExpressions/blob/master/README.md#using-a-regular-expression-object-1).  
- `with` - The template string to replace matching patterns with. See [Template Matching Format](https://apple.co/3fWBknv) for how to format the template. Defaults to an empty string.
- **Returns** The new string after the subsitutions have been made. If no matches are found, the string is returned unchanged.

Examples:
```swift
let name = "Peter Schorn"
// The .anchored matching option only looks for matches
// at the beginning of the string.
// Consequently, only the first word will be matched.
let regexObject = try Regex(
    pattern: #"\w+"#,
    regexOptions: [.caseInsensitive],
    matchingOptions: [.anchored]
)
let replacedText = try name.regexSub(regexObject, with: "word")
print(replacedText)

// replacedText = "word Schorn"
```
```swift
let name = "Charles Darwin"
let reversedName = try name.regexSub(
    #"(\w+) (\w+)"#,
    with: "$2 $1"
    // $1 and $2 represent the
    // first and second capture group, respectively.
    // $0 represents the entire match.
)
print(reversedName)

// reversedName = "Darwin Charles"
```

### Performing regular expression replacements with a custom closure

If you need to further customize regular expression replacements, you can use the following methods:

```swift
func regexSub<RegularExpression: RegexProtocol>(
    _ regex: RegularExpression,
    range: Range<String.Index>? = nil,
    replacer: (_ matchIndex: Int, _ match: RegexMatch) -> String?
) throws -> String {
```
```swift
func regexSub(
    _ pattern: String,
    regexOptions: NSRegularExpression.Options = [],
    matchingOptions: NSRegularExpression.MatchingOptions = [],
    groupNames: [String]? = nil,
    range: Range<String.Index>? = nil,
    replacer: (_ matchIndex: Int, _ match: RegexMatch) -> String?
) throws -> String {
```
The `pattern`, `regexOptions`, `matchingOptions`, and `groupNames` parameters correspond to the instance properties of [RegexProtocol](https://github.com/Peter-Schorn/RegularExpressions/blob/master/README.md#using-a-regular-expression-object-1).  
- `replacer` - A closure that accepts the index of a regular expression match and a regular expression match and returns a new string to replace it with. Return nil from within the closure to indicate that the match should not be changed.

Examples:
```swift
let inputString = """
Darwin's theory of evolution is the \
unifying theory of the life sciences.
"""

let pattern = #"\w+"#  // match each word in the input string
let replacedString = try inputString.regexSub(pattern) { indx, match in
    if indx > 5 { return nil }  // only replace the first 5 matches
    return match.fullMatch.uppercased() // uppercase the full match
}
print(replacedString)

// replacedString = """
// DARWIN'S THEORY OF EVOLUTION IS the \
// unifying theory of the life sciences.
// """
```

If you need to perform replacedments for each individual capture group, you can use the `replaceGroups` method of the `RegexMatch` struct:
```swift
func replaceGroups(
    _ replacer: (
        _ groupIndex: Int, _ group: RegexGroup
    ) -> String?
) -> String {
```
- `replacer` - A closure that accepts the index of a capture group and a capture group and returns a new string to replace it with. Return nil from within the closure to indicate that the capture group should not be changed.

Examples:
```swift
let inputText = "name: Peter, id: 35, job: programmer"
let pattern = #"name: (\w+), id: (\d+)"#
let groupNames = ["name", "id"]

let match = try inputText.regexMatch(
    pattern, groupNames: groupNames
)!
let replacedMatch = match.replaceGroups { indx, group in
    if group.name == "name" { return "Steven" }
    if group.name == "id" { return "55" }
    return nil
}
print(replacedMatch)

// match.fullMatch = "name: Peter, id: 35"
// replacedMatch = "name: Steven, id: 55"
```

You can compose together the above methods in the following manner:
```swift
let inputString = """
name: sally, id: 26
name: alexander, id: 54
"""
let regexObject = try Regex(
    pattern: #"name: (\w+), id: (\d+)"#,
    groupNames: ["name", "id"]
)
let replacedText = try inputString.regexSub(regexObject) { indx, match in
    
    if indx == 0 { return nil }
    
    return match.replaceGroups { indx, group in
        if group.name == "name" {
            return group.match.uppercased()
        }
        if group.name == "id" {
            return "redacted"
        }
        return nil
    }
}
print(replacedText)

// replacedText = """
// name: sally, id: 26
// name: ALEXANDER, id: redacted
// """
```

## Checking for regular expression matches in a switch statement

The pattern matching operator `~=` has been overloaded to support checking for matches to a regular expression in a switch statement. For example:

```swift
let inputStrig = #"user_id: "asjhjcb""#

switch inputStrig {
    case try Regex(#"USER_ID: "[a-z]+""#, [.caseInsensitive]):
        print("valid user id")
    case try? Regex(#"[!@#$%^&]+"#):
        print("invalid character in user id")
    case try! Regex(#"\d+"#):
        print("user id cannot contain numbers")
    default:
        print("no match")
}

// prints "valid user id"
 ```

`try`, `try?`, and `try!` can all be used to determined the best way to handle an error arising from an invalid regular expression pattern.
Unfortunately, there is no way to bind the match of the regular expression pattern to a variable.
