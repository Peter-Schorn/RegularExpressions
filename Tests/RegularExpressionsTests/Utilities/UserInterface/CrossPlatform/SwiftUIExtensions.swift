import Foundation
import SwiftUI


@available(macOS 10.15, *)
public struct CenterInForm<V: View>: View {
    
    public var content: V
    
    public init(_ content: V) { self.content = content }
    
    public var body: some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}


@available(macOS 10.15, *)
extension View {

    /// Conditionally applies a modifier to a view
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            return AnyView(content(self))
        }
        else {
            return AnyView(self)
        }
    }
    
    
    /// Conditionally applies a modifier to a view
    func `if`<Content: View>(
        _ conditional: Bool,
        _ content1: (Self) -> Content,
        else content2: (Self) -> Content
    ) -> some View {
        
        if conditional {
            return AnyView(content1(self))
        }
        else {
            return AnyView(content2(self))
        }
       
    }

}

