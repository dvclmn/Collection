//
//  Attributes.swift
//  TextCore
//
//  Created by Dave Coleman on 30/8/2024.
//


import AppKit

public typealias Attributes = [NSAttributedString.Key: Any]

public struct AttributeSet: ExpressibleByDictionaryLiteral {
  
  public var attributes: Attributes
  
  public init(dictionaryLiteral elements: (Attributes.Key, Attributes.Value)...) {
    self.attributes = Dictionary(uniqueKeysWithValues: elements)
  }
  
  public init(_ attributes: Attributes) {
    self.attributes = attributes
  }
  
  public init(
    font: NSFont,
    foreground: NSColor = .labelColor,
    background: NSColor = .clear,
    additionalAttributes: Attributes = [:]
  ) {
    let baseAttributes: Attributes = [
      .font: font,
      .foregroundColor: foreground,
      .backgroundColor: background
    ]
    self.attributes = baseAttributes.merging(additionalAttributes) { (_, new) in new }
  }
  
  public subscript(_ key: Attributes.Key) -> Any? {
    get { attributes[key] }
    set { attributes[key] = newValue }
  }
}

extension AttributeSet: Sequence {  
  public func makeIterator() -> Dictionary<NSAttributedString.Key, Any>.Iterator {
    return attributes.makeIterator()
  }
}
