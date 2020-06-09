#if os(macOS) && canImport(SwiftUI)


import SwiftUI
import AppKit

/// Shows an activity indicator to indicate that
/// an action is in progress.
@available(macOS 10.15, *)
public struct ActivityIndicator: NSViewRepresentable {
    
    @Binding public var shouldAnimate: Bool
    public let style: NSProgressIndicator.Style
    public let controlSize: NSControl.ControlSize
    public let hideWhenNotAnimating: Bool
    
    
    public init(
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
    
    
    public func makeNSView(context: Context) -> NSProgressIndicator {
        let progressView = NSProgressIndicator()
        progressView.style = style
        progressView.controlSize = controlSize
        return progressView
    }

    public func updateNSView(
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

#endif
