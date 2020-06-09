#if canImport(SwiftUI)

import SwiftUI


@available(macOS 10.15, iOS 13, *)
public struct StyledText {
    // This is a value type. Don't be tempted to use NSMutableAttributedString here unless
    // you also implement copy-on-write.
    private var attributedString: NSAttributedString

    private init(attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }

    public init(_ content: String, styles: [TextStyle] = []) {
        let attributes = styles.reduce(into: [:]) { result, style in
            result[style.key] = style
        }
        attributedString = NSMutableAttributedString(string: content, attributes: attributes)
    }

    public func style<S>(
        _ style: TextStyle, ranges: (String) -> S
    ) -> StyledText where S: Sequence, S.Element == Range<String.Index>? {

        // Remember this is a value type. If you want to avoid this copy,
        // then you need to implement copy-on-write.
        let newAttributedString = NSMutableAttributedString(
            attributedString: attributedString
        )

        for range in ranges(attributedString.string) {
            guard let range = range else { continue }
            
            let nsRange = NSRange(range, in: attributedString.string)
            newAttributedString.addAttribute(style.key, value: style, range: nsRange)
        }

        return StyledText(attributedString: newAttributedString)
    }
    

    // A convenience extension to apply to a single range.
    public func style(
        _ style: TextStyle,
        range: (String) -> Range<String.Index>? = { $0.startIndex..<$0.endIndex }
    ) -> StyledText {
        
        self.style(style, ranges: { [range($0)] })
    }


}


@available(macOS 10.15, iOS 13, *)
public struct TextStyle {
    
    // This type is opaque because it exposes NSAttributedString details and
    // requires unique keys. It can be extended by public static methods.

    // Properties are internal to be accessed by StyledText
    internal let key: NSAttributedString.Key
    internal let apply: (Text) -> Text

    public init(key: NSAttributedString.Key, apply: @escaping (Text) -> Text) {
        self.key = key
        self.apply = apply
    }

    
    public static func foregroundColor(_ color: Color) -> Self {
        return TextStyle(
            key: .init("TextStyleForegroundColor"),
            apply: { $0.foregroundColor(color) }
        )
    }

    public static func bold() -> Self {
        return TextStyle(
            key: .init("TextStyleBold"), apply: { $0.bold() }
        )
    }
    
}

@available(macOS 10.15, iOS 13, *)
extension StyledText: View {
    
    public var body: some View { text() }

    public func text() -> Text {
        
        var text: Text = Text(verbatim: "")
        attributedString.enumerateAttributes(
            in: NSRange(location: 0, length: attributedString.length),
            options: []
        ) { attributes, range, _ in
                
            let string = attributedString.attributedSubstring(from: range).string
            let modifiers = attributes.values.map { $0 as! TextStyle }
            text = text + modifiers.reduce(Text(verbatim: string)) { segment, style in
                style.apply(segment)
            }
        }
        
        return text
    }
}


#endif
