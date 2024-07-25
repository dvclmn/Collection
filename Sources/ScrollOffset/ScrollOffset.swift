//
//  File.swift
//
//
//  Created by Dave Coleman on 14/7/2024.
//

import Foundation
import SwiftUI
import ScrollKit
import ScrollMask

public struct ScrollOffsetModifier: ViewModifier {
    
    let maskEnabled: Bool
    let topPadding: Double
    let output: (_ offset: CGPoint) -> Void
    
    @State private var isMasked: Bool = false

    public func body(content: Content) -> some View {
        
        ScrollViewWithOffsetTracking(showsIndicators: true) { offset in
            if maskEnabled {
                withAnimation(.snappy(duration: 0.3)) {
                    isMasked = offset.y < -1
                }
            }
            output(offset)
        } content: {
            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scrollMask(isMasked)
        .padding(.top, 0.5)
    }
}

public extension View {
    
    func readScrollOffset(
        maskEnabled: Bool = true,
        topPadding: Double = .zero,
        _ output: @escaping (_ offset: CGPoint) -> Void = { _ in }
    ) -> some View {
        self.modifier(ScrollOffsetModifier(
            maskEnabled: maskEnabled,
            topPadding: topPadding,
            output: output
        ))
    }
    
}



//public extension View {
//    func readSize(
//        onChange: @escaping (CGSize) -> Void
//    ) -> some View {
//
//        background(
//            GeometryReader { geometryProxy in
//                Color.clear
//                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
//            }
//        )
//        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
//    }
//}
//
//private struct SizePreferenceKey: PreferenceKey {
//    static var defaultValue: CGSize = .zero
//    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
//}
//


//public struct ScrollOffset: Sendable {
//    public var offset: CGPoint
//
//    public init(offset: CGPoint) {
//        self.offset = offset
//    }
//}
//
//public struct ScrollOffsetKey: EnvironmentKey {
//    public static let defaultValue = ScrollOffset(offset: .zero)
//}
//
//public extension EnvironmentValues {
//    var scrollOffset: ScrollOffset {
//        get { self[ScrollOffsetKey.self] }
//        set { self[ScrollOffsetKey.self] = newValue }
//    }
//}
