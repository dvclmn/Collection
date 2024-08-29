// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI



/// Usage
/// From this:
/// ```swift
/// if textView.string != self.text {
///    textView.string = self.text
/// }
/// ```
/// To this: `textView.string ?= self.text`
///
infix operator ?=: AssignmentPrecedence

public func ?=<T: Equatable>(lhs: inout T, rhs: T) {
  if lhs != rhs {
    lhs = rhs
  }
}


// MARK: - Optional bindings
/// By SwiftfulThinking
public extension Optional where Wrapped == String {
  var _boundString: String? {
    get {
      return self
    }
    set {
      self = newValue
    }
  }
  var boundString: String {
    get {
      return _boundString ?? ""
    }
    set {
      _boundString = newValue.isEmpty ? nil : newValue
    }
  }
}

public extension Optional where Wrapped == Int {
  var _boundInt: Int? {
    get {
      return self
    }
    set {
      self = newValue
    }
  }
  
  var boundInt: Int {
    get {
      return _boundInt ?? 0
    }
    set {
      _boundInt = (newValue == 0) ? nil : newValue
    }
  }
}
public extension Optional where Wrapped == Bool {
  var _boundBool: Bool? {
    get {
      return self
    }
    set {
      self = newValue
    }
  }
  
  var boundBool: Bool {
    get {
      return _boundBool ?? false
    }
    set {
      _boundBool = (newValue == false) ? nil : newValue
    }
  }
}

//func ??<Bool>(lhs: Binding<Optional<Bool>>, rhs: Bool) -> Binding<Bool> {
//    Binding(
//        get: { lhs.wrappedValue ?? rhs },
//        set: { lhs.wrappedValue = $0 }
//    )
//}

// MARK: - Random colour
public extension ShapeStyle where Self == Color {
  static var random: Color {
    Color(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1)
    )
  }
}

// MARK: - Visual effect
#if os(macOS)
public struct VisualEffectView: NSViewRepresentable {
  public func makeNSView(context: Context) -> NSView {
    let view = NSVisualEffectView()
    view.blendingMode = .behindWindow
    view.state = .active
    view.material = .underWindowBackground
    return view
  }
  public func updateNSView(_ view: NSView, context: Context) { }
}
#endif


// MARK: - Check if is Preview
public var isPreview: Bool {
  return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}



public func downloadImage(from url: URL) async throws -> Data {
  let (data, response) = try await URLSession.shared.data(from: url)
  
  // Check for a valid HTTP response
  guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
    throw URLError(.badServerResponse)
  }
  return data
}



#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif


public extension Image {
  init?(data: Data) {
#if canImport(UIKit)
    guard let uiImage = UIImage(data: data) else { return nil }
    self.init(uiImage: uiImage)
#elseif canImport(AppKit)
    guard let nsImage = NSImage(data: data) else { return nil }
    self.init(nsImage: nsImage)
#endif
  }
}

//#if canImport(UIKit)
//extension UIImage {
//    var cgImage: CGImage? {
//        return self.cgImage
//    }
//}
//#endif

#if canImport(AppKit)
public extension NSImage {
  var cgImage: CGImage? {
    var rect = CGRect(origin: .zero, size: self.size)
    return self.cgImage(forProposedRect: &rect, context: nil, hints: nil)
  }
}
#endif



public func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
  Binding(
    get: { lhs.wrappedValue ?? rhs },
    set: { lhs.wrappedValue = $0 }
  )
}







public extension String {
  var wordCount: Int {
    let words = self.split { !$0.isLetter }
    return words.count
  }
}


public extension Array where Element: Equatable {
  func indexOf(_ item: Element?) -> Int? {
    
    if let item = item {
      return self.firstIndex(of: item)
    } else {
      return nil
    }
  }
  
  func nextIndex(after item: Element?) -> Int? {
    guard let currentIndex = self.indexOf(item) else { return nil }
    let nextIndex = currentIndex + 1
    return nextIndex < self.count ? nextIndex : nil
  }
  
  func previousIndex(before item: Element?) -> Int? {
    guard let currentIndex = self.indexOf(item) else { return nil }
    let previousIndex = currentIndex - 1
    return previousIndex >= 0 ? previousIndex : nil
  }
  
  func secondToLast() -> Element? {
    if self.count < 2 {
      return nil
    }
    let index = self.count - 2
    return self[index]
  }
}



public extension Int {
  func string() -> String {
    return String(self)
  }
}

public extension BinaryFloatingPoint {
  
  var wholeNumber: String {
    return toDecimalPlace(self, to: 0)
  }
  func toDecimal(_ place: Int) -> String {
    return toDecimalPlace(self, to: place)
  }
  private func toDecimalPlace<T: FloatingPoint>(_ value: T, to decimalPlace: Int) -> String {
    
    guard let value = value as? CVarArg else { return "" }
    let result = String(format: "%.\(decimalPlace)f", value)
    
    return result
  }
  
}


//public extension Double {
//  var wholeNumber: String {
//    return toDecimalPlace(self, to: 0)
//  }
//  func toDecimal(_ place: Int) -> String {
//    return toDecimalPlace(self, to: place)
//  }
//}

public extension Comparable {
  func constrained(_ atLeast: Self, _ atMost: Self) -> Self {
    return min(max(self, atLeast), atMost)
  }
}

public extension Comparable where Self: FloatingPoint {
  func normalised(from originalRange: (min: Self, max: Self)) -> Self {
    guard originalRange.min < originalRange.max else { return self }
    return (self - originalRange.min) / (originalRange.max - originalRange.min) * 100
  }
}

public extension Int64 {
  func getString() -> String {
    return String(self)
  }
}

extension UUID: @retroactive RawRepresentable {
  public var rawValue: String {
    self.uuidString
  }
  
  public typealias RawValue = String
  
  public init?(rawValue: RawValue) {
    self.init(uuidString: rawValue)
  }
}
