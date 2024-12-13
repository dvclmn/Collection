//
//  PanModifier.swift
//  LilyPad
//
//  Created by Dave Coleman on 6/12/2024.
//

import SwiftUI

public struct TwoFingerPanModifier: ViewModifier {
  
  @Binding var panAmount: CGPoint
  @State private var panDelta: CGPoint = .zero
  @State private var monitor: Any?
  
  let sensitivity: CGFloat
  let isPanning: (Bool) -> Void

  public init(
    panAmount: Binding<CGPoint>,
    sensitivity: CGFloat = 0.8,
  isPanning: @escaping (Bool) -> Void = { _ in }
  ) {
    self._panAmount = panAmount
    self.sensitivity = sensitivity
    self.isPanning = isPanning
  }
  
  public func body(content: Content) -> some View {
    content
      .onAppear {
        monitor = NSEvent.addLocalMonitorForEvents(matching: .scrollWheel) { event in
          guard !event.scrollingDeltaX.isNaN && !event.scrollingDeltaY.isNaN else {
            return event
          }
          
          /// Update delta
          panDelta = CGPoint(
            x: event.scrollingDeltaX * sensitivity,
            y: event.scrollingDeltaY * sensitivity
          )
          
          /// Update total
          panAmount = CGPoint(
            x: panAmount.x + panDelta.x,
            y: panAmount.y + panDelta.y
          )
          
          return event
        }
      }
      .onDisappear {
        if let monitor = monitor {
          NSEvent.removeMonitor(monitor)
        }
      }
  }
}


extension View {
  public func panTrackpadGesture(
    _ panAmount: Binding<CGPoint>,
    sensitivity: CGFloat = 0.8
  ) -> some View {
    self.modifier(
      TwoFingerPanModifier(
        panAmount: panAmount,
        sensitivity: sensitivity
      )
    )
  }
}
