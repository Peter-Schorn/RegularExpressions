#if os(macOS) && canImport(SwiftUI)

import SwiftUI
import AppKit


private var controlActionClosureProtocolAssociatedObjectKey: UInt8 = 0

protocol ControlActionClosureProtocol: NSObjectProtocol {
    var target: AnyObject? { get set }
    var action: Selector? { get set }
}

private final class ActionTrampoline<T>: NSObject {
    let action: (T) -> Void

    init(action: @escaping (T) -> Void) {
        self.action = action
    }

    @objc func action(sender: AnyObject) {
        action(sender as! T)
    }
}

extension ControlActionClosureProtocol {
    func onAction(_ action: @escaping (Self) -> Void) {
        let trampoline = ActionTrampoline(action: action)
        self.target = trampoline
        self.action = #selector(ActionTrampoline<Self>.action(sender:))
        objc_setAssociatedObject(
            self,
            &controlActionClosureProtocolAssociatedObjectKey,
            trampoline,
            .OBJC_ASSOCIATION_RETAIN
        )
    }
}

extension NSControl: ControlActionClosureProtocol { }

/// Button that automatically becomes the first responder for keyboard events
@available(macOS 10.15, *)
public struct DefaultButton: NSViewRepresentable {
    
    public enum KeyEquivalent: String {
        case escape = "\u{1b}"
        case `return` = "\r"
    }

    public var title: String?
    public var attributedTitle: NSAttributedString?
    public var keyEquivalent: KeyEquivalent?
    public let action: () -> Void

    public init(
        _ title: String,
        keyEquivalent: KeyEquivalent? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.keyEquivalent = keyEquivalent
        self.action = action
    }

    public init(
        _ attributedTitle: NSAttributedString,
        keyEquivalent: KeyEquivalent? = nil,
        action: @escaping () -> Void
    ) {
        self.attributedTitle = attributedTitle
        self.keyEquivalent = keyEquivalent
        self.action = action
    }

    public func makeNSView(context: NSViewRepresentableContext<Self>) -> NSButton {
        let button = NSButton(title: "", target: nil, action: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }

    public func updateNSView(_ nsView: NSButton, context: NSViewRepresentableContext<Self>) {
        
        
        if attributedTitle == nil {
            nsView.title = title ?? ""
        }

        if title == nil {
            nsView.attributedTitle = attributedTitle ?? NSAttributedString(string: "")
        }

        nsView.keyEquivalent = keyEquivalent?.rawValue ?? ""

        nsView.onAction { _ in
            self.action()
        }
    }
}


#endif
