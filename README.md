# RegularExpressions

**A regular expressions library for Swift**

## Features

- `func String.regexFindall` - Finds all matches for a regular expression in a string.
- `func String.regexMatch` - Find the first match for a regular expression
- `func String.regexSplit`- Splits a string by occurences of a pattern into an array.
- `func String.regexSub` - Performs a regular expression replacement
- `protocol RegexProtocol` - A type that encapsulates information about a regular expression.
- `struct Regex` - Encapsulates information about a regular expression. Conforms to `RegexProtocol`.

## Creating a regular expression object

All of the above methods accept an object conforming to `RegexProtocol`. This object holds information about a regular expression, including:
- `var pattern: String { get }` - The regular expression pattern.
- `var regexOptions: NSRegularExpression.Options { get }` - The regular expression options (see [NSRegularExpression.Options](https://developer.apple.com/documentation/foundation/nsregularexpression/options)).
- `var matchingOptions: NSRegularExpression.MatchingOptions { get }` - See [NSRegularExpression.MatchingOptions](https://developer.apple.com/documentation/foundation/nsregularexpression/matchingoptions).
- `var groupNames: [String]? { get }` - The names of the capture groups.
