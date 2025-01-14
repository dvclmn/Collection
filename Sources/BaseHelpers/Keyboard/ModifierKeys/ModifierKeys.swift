//
//  File.swift
//
//
//  Created by Dave Coleman on 23/7/2024.
//

import Foundation
import SwiftUI

/// Important: Don't forget to provide the entry point for the modifier:
///
/// ```
/// import SwiftUI
///
/// @main
/// struct ExampleApp: App {
///
///   var body: some Scene {
///     WindowGroup {
///       ContentView()
///         .readModifierKeys() // <- Here
///     }
///   }
/// }
/// ```

public typealias Modifiers = Set<ModifierKey>

public enum ModifierKey: String, CaseIterable, Identifiable, Hashable, Sendable {
  case command
  case shift
  case option
  case control
  
  public var id: String { self.rawValue }
  public var name: String { self.rawValue.capitalized }
  
  public var symbol: String {
    switch self {
      case .shift: "􀆝"
      case .control: "􀆍"
      case .option: "􀆕"
      case .command: "􀆔"
    }
  }
}

public extension Modifiers {
  var names: String? {
    if !self.isEmpty {
      return self.map(\.name).joined()
    } else {
      return nil
    }
  }
  
  var symbols: String? {
    if !self.isEmpty {
      return self.map(\.symbol).joined()
    } else {
      return nil
    }
  }
}

#if os(macOS)


public extension EnvironmentValues {
  @Entry var modifierKeys: Modifiers = .init()
}

public extension NSEvent.ModifierFlags {
  func toModifierKey() -> ModifierKey? {
    switch self {
      case .shift: return .shift
      case .control: return .control
      case .option: return .option
      case .command: return .command
      default: return nil
    }
  }
}


public struct ModifierKeysModifier: ViewModifier {
  
  @State private var modifierKeys = Modifiers()
  
  private let allModifiers: [NSEvent.ModifierFlags] = [.shift, .control, .option, .command]
  
  public func body(content: Content) -> some View {
    content
      .onAppear {
        NSEvent.addLocalMonitorForEvents(matching: [.flagsChanged]) { event in
          modifierKeys = Set(allModifiers.compactMap { flag in
            event.modifierFlags.contains(flag) ? flag.toModifierKey() : nil
          })
          return event
        }
      }
      .environment(\.modifierKeys, modifierKeys)
  }
}

#endif

public extension View {
#if canImport(AppKit)
  func readModifierKeys() -> some View {
    self.modifier(ModifierKeysModifier())
  }
#elseif canImport(UIKit)
  func readModifierKeys() -> some View {
    self
  }
  #endif
}

