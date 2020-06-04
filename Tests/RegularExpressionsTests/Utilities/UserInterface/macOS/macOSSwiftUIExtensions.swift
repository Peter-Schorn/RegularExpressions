import Foundation
import SwiftUI
import AppKit

#if os(macOS)


/// Shows an activity indicator to indicate that
/// an action is in progress.
@available(macOS 10.15, *)
struct ActivityIndicator: NSViewRepresentable {
    
    @Binding var shouldAnimate: Bool
    let style: NSProgressIndicator.Style
    let controlSize: NSControl.ControlSize
    let hideWhenNotAnimating: Bool
    
    
    init(
        shouldAnimate: Binding<Bool>,
        style: NSProgressIndicator.Style,
        controlSize: NSControl.ControlSize = .small,
        hideWhenNotAnimating: Bool = true
    ) {
        self._shouldAnimate = shouldAnimate
        self.style = style
        self.controlSize = controlSize
        self.hideWhenNotAnimating = hideWhenNotAnimating
    }
    
    
    func makeNSView(context: Context) -> NSProgressIndicator {
        let progressView = NSProgressIndicator()
        progressView.style = style
        progressView.controlSize = controlSize
        return progressView
    }

    func updateNSView(
        _ progressView: NSProgressIndicator,
        context: Context
    ) {

        if self.shouldAnimate {
            if hideWhenNotAnimating {
                progressView.isHidden = false
            }
            progressView.startAnimation(nil)
        }
        else {
            progressView.stopAnimation(nil)
            if hideWhenNotAnimating {
                progressView.isHidden = true
            }
        }
    }
    
}



/**
 Displays text as a hyperlink.
 When the user hovers over the text,
 it becomes underlined and the cursor changes
 to a pointer. You can customize what happens
 when the user clicks on the link. By default,
 it is opened in the browser.
 */
@available(macOS 10.15, *)
struct HyperLink: View {

    init(
        link: URL? = nil,
        displayText: String,
        openLinkHandler: @escaping (URL) -> Void = { NSWorkspace.shared.open($0) }
    ) {
        self.init(
            link: link ?? URL(string: displayText),
            displayText: Text(displayText),
            openLinkHandler: openLinkHandler
        )
    }
    
    
    init(
        link: URL?,
        displayText: Text,
        openLinkHandler: @escaping (URL) -> Void = { NSWorkspace.shared.open($0) }
    ) {
    
        self.displayText = displayText
        self.url = link
        self.openLinkHandler = openLinkHandler
        
    }
    
    
    @State private var isHoveringOverURL = false
    
    let displayText: Text
    let url: URL?
    let openLinkHandler: (URL) -> Void
    
    var body: some View {
        
        Button(action: {
            if let url = self.url {
                self.openLinkHandler(url)
            }
        }) {
            displayText
                .foregroundColor(Color.blue)
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
