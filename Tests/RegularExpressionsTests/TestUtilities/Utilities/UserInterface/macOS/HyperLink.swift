#if os(macOS) && canImport(SwiftUI)

import SwiftUI
import AppKit


/**
 Displays text as a hyperlink.
 When the user hovers over the text,
 it becomes underlined and the cursor changes
 to a pointer. You can customize what happens
 when the user clicks on the link. By default,
 it is opened in the browser.
 By default, the foregorund color is the current user's accent color.
 */
@available(macOS 10.15, *)
public struct HyperLink: View {

    /// When link is nil, this method attempts to use the display text
    /// as the link.
    
    public init(
        link: URL? = nil,
        displayText: String,
        foregroundColor: Color = .accentColor,
        openLinkHandler: @escaping (URL) -> Void = { NSWorkspace.shared.open($0) }
    ) {
        self.init(
            link: link ?? URL(string: displayText),
            displayText: Text(displayText),
            foregroundColor: foregroundColor,
            openLinkHandler: openLinkHandler
        )
    }
    
    
    public init(
        link: URL?,
        displayText: Text,
        foregroundColor: Color = .accentColor,
        openLinkHandler: @escaping (URL) -> Void = { NSWorkspace.shared.open($0) }
    ) {
    
        self.displayText = displayText
        self.foregroundColor = foregroundColor
        self.url = link
        self.openLinkHandler = openLinkHandler
    }
    
    @State private var isHoveringOverURL = false
    
    let displayText: Text
    let foregroundColor: Color
    let url: URL?
    let openLinkHandler: (URL) -> Void
    
    public var body: some View {
        
        Button(action: {
            if let url = self.url {
                self.openLinkHandler(url)
            }
        }) {
            displayText
                .foregroundColor(foregroundColor)
                .if(isHoveringOverURL) {
                    $0.underline()
                }
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { inside in
            if inside {
                self.isHoveringOverURL = true
                NSCursor.pointingHand.push()
            } else {
                self.isHoveringOverURL = false
                NSCursor.pop()
            }
        }
        
        
    }
    
    
}


#endif
