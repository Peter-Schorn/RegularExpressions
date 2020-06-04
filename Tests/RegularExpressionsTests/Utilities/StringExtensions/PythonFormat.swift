import Foundation
import RegularExpressions

/// replaces double brackets with single brackets
func removeDoubleBrackets(_ string: inout String) {
    string.regexSubInPlace(#"\{\{"#, with: "{")
    string.regexSubInPlace(#"\}\}"#, with: "}")
}

// matches text in between curly brackets, unless the brackets
// are escaped with another set of curly brakets.
// This is similar to how python parses f-strings,
// except only one level of escaping is supported.
private let regexCurlyBrackets =
        #"(?<!\{)\{(?!\{)(.*?)(?<!\})\}(?!\})"#

public extension String {



    func format(dict: [String: Any]) -> String {

        let interpolatedValues = dict.mapValues { "\($0)" }
        
        guard let keys = try? self.regexFindAll(regexCurlyBrackets) else {
            fatalError("couldn't find dictionary keys in string")
        }

        var formattedStr = self
        var offset = 0

        for key in keys {

            // the keyword inside the curly bracket
            let kwarg = key.groups[0]!.match

            guard let item = interpolatedValues[kwarg] else {
                fatalError("couldn't find key in dictionary")
            }

            let range = offsetStrRange(formattedStr, range: key.range, by: offset)
            formattedStr.replaceSubrange(range, with: item)

            offset += (item.count - key.fullMatch.count)
        }

        removeDoubleBrackets(&formattedStr)
        return formattedStr

    }


    func format(_ interpolations: Any...) -> String {

        let items = interpolations.map { "\($0)" }

        guard let matches = try? self.regexFindAll(regexCurlyBrackets) else {
            fatalError("couldn't find curly brackets")
        }

        // if all the curly brackets have numbers in them
        if matches.allSatisfy({ try! $0.groups[0]!.match.regexMatch(#"\d+"#) != nil }) {
            // then interpolate the values based on the numbers
            return formatNum(items, matches)
        }

        // if all the curly brackets are empty
        if matches.allSatisfy({ $0.fullMatch == "{}" }) {
            // then interpolate the values based on the order they were passed in
            return formatPos(items, matches)
        }

        fatalError("all brackets should be empty, or they should all contain numbers.")

    }


    /// formats based on empty curly brackets
    private func formatPos(
        _ items: [String],
        _ matches: [RegexMatch]
    ) -> String {

        var formattedStr = self
        var offset = 0

        for (item, match) in zip(items, matches) {

            let range = offsetStrRange(formattedStr, range: match.range, by: offset)

            formattedStr.replaceSubrange(range, with: item)

            offset += (item.count - match.fullMatch.count)
        }

        removeDoubleBrackets(&formattedStr)
        return formattedStr

    }


    /// formats based on curly brackets with numbers inside them
    private func formatNum(
        _ items: [String],
        _ matches: [RegexMatch]
    ) -> String {

        var formattedStr = self
        var offset = 0

        for match in matches {

            // the number inside the brackets
            let num = Int(match.groups[0]!.match)!

            guard let item = items[safe: num] else {
                fatalError("item \(num) specified in curly brackets not found")
            }

            let range = offsetStrRange(formattedStr, range: match.range, by: offset)

            // print(formattedStr[match.range])
            formattedStr.replaceSubrange(range, with: item)


            offset += (item.count - match.fullMatch.count)

        }

        removeDoubleBrackets(&formattedStr)
        return formattedStr
    }


}
