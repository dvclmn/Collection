//
//  CodableIgnored.swift
//  Collection
//
//  Created by Dave Coleman on 16/12/2024.
//

import SwiftUI

//@propertyWrapper
//public struct Ignored<T> {
//  public var wrappedValue: T
//  
//  public init(wrappedValue: T) {
//    self.wrappedValue = wrappedValue
//  }
//}
//
//extension Ignored: Encodable where T: Encodable { }
//extension Ignored: Decodable where T: Decodable { }
//extension Ignored: Sendable where T: Sendable { }
//extension Ignored: Equatable where T: Equatable { }
//extension Ignored: Hashable where T: Hashable { }
//
//public extension KeyedEncodingContainer {
//  mutating func encode<T: Encodable>(_ value: Ignored<T>, forKey key: KeyedEncodingContainer<K>.Key) throws { }
//}
//
//public extension KeyedDecodingContainer {
//  func decode<T: Decodable>(_ type: Ignored<T?>.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Ignored<T?> {
//    return try .init(wrappedValue: decodeIfPresent(T.self, forKey: key))
//  }
//}

/// For types that should be excluded from persistence
/// `public protocol Ephemeral: DefaultInitializable {}`

/// For types that represent UI state
/// `public protocol UIStateRepresentable: Ephemeral {}`

/// For types that represent cache data
/// `public protocol CacheRepresentable: Ephemeral {}`

// Then conform your types
/// `extension TextRepresentationState: UIStateRepresentable {}`
/// `extension UIState: UIStateRepresentable {}`

// Could even create specialized wrappers
/// `typealias EphemeralState<T: Ephemeral> = CodableIgnored<T>`
/// `typealias UIStateProperty<T: UIStateRepresentable> = CodableIgnored<T>`
/// `typealias CacheProperty<T: CacheRepresentable> = CodableIgnored<T>`

/// Usage becomes even more semantic:
///
/// ```
/// struct MyModel: Codable {
///   @UIStateProperty private var textState: TextRepresentationState = /// .default
///   @UIStateProperty private var uiState: UIState = .default
///   @CacheProperty private var temporaryCache: [String: Int] = .default
/// }
/// ```
//
///// Protocol for types that can provide a default value
//public protocol DefaultInitializable {
//  static var `default`: Self { get }
//}
//
///// Property wrapper that ignores a property during coding
//@propertyWrapper
//public struct CodableIgnored<T: DefaultInitializable> {
//  public var wrappedValue: T
//  
//  public init(wrappedValue: T) {
//    self.wrappedValue = wrappedValue
//  }
//}
//
///// Coding support
//extension CodableIgnored: Codable {
//  public init(from decoder: Decoder) throws {
//    self.wrappedValue = T.default
//  }
//  
//  public func encode(to encoder: Encoder) throws {
//    // Do nothing during encoding
//  }
//}
//
///// Conditional conformances
//extension CodableIgnored: Equatable where T: Equatable {
//  public static func == (lhs: CodableIgnored<T>, rhs: CodableIgnored<T>) -> Bool {
//    lhs.wrappedValue == rhs.wrappedValue
//  }
//}
//
//extension CodableIgnored: Hashable where T: Hashable {
//  public func hash(into hasher: inout Hasher) {
//    hasher.combine(wrappedValue)
//  }
//}
//
//extension CodableIgnored: Sendable where T: Sendable {}
