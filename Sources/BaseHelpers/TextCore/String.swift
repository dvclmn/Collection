//
//  String.swift
//  TextCore
//
//  Created by Dave Coleman on 9/10/2024.
//

import Foundation


public extension String {
  
  var longestLineLength: Int {
    let lines = self.split(
      separator: "\n",
      maxSplits: Int.max,
      omittingEmptySubsequences: false
    )
    let longestLine = lines.map { $0.count }.max() ?? 1
    return longestLine
  }
  
  func indentingEachLine(_ level: Int = 1, indentChar: String = "\t") -> String {
    let indent = String(repeating: indentChar, count: level)
    return self.split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)
      .map { indent + $0 }
      .joined(separator: "\n")
  }
  

  func components(separatedBy separator: Character) -> [String] {
    return self.split(separator: separator).map(String.init)
  }
  
  var wordCount: Int {
    let words = self.split { !$0.isLetter }
    return words.count
  }
  
  func nsRange(from range: Range<String.Index>) -> NSRange {
    return NSRange(range, in: self)
  }
  
  func range(from nsRange: NSRange) -> Range<String.Index>? {
    return Range(nsRange, in: self)
  }
  
  func substring(with nsRange: NSRange) -> Substring? {
    guard let range = self.range(from: nsRange) else { return nil }
    return self[range]
  }
  
  /// A `prefix(_ maxLength: Int)` alternative, returning a `String` rather than `Substring`
  ///
  func preview(
    _ maxLength: Int = 20,
    hasDividers: Bool = true,
    showsEnd: Bool = true
  ) -> String {
    let totalLength = self.count
    
    /// Handle the case where the provided string is actually *shorter*
    /// than the `maxLength`
    if totalLength <= maxLength {
      
      if self.isEmpty {
        
        return "(Empty line)"
      } else {
        return hasDividers ? "\n---\n\(self)\n---\n\n" : self
      }
      
    }
    
    let prefixLength = min(maxLength / 2, totalLength / 2)
    let suffixLength = min(maxLength - prefixLength - 3, totalLength - prefixLength - 3)
    
    let prefix = self.prefix(prefixLength)
    let suffix = showsEnd ? self.suffix(suffixLength) : ""
    
    let result = "\(prefix)...\(suffix)"
    
    if hasDividers {
      return "\n---\n\(result)\n---\n\n"
    } else {
      return result
    }
  }
  
  
  
}



/// This extension seems to drive something like the below (as found in Banksia, to highlight search terms)
/*
 
 var match: [String] {
 return [conv.searchText].filter { message.content.localizedCaseInsensitiveContains($0) }
 }
 
 var highlighted: AttributedString {
 var result = AttributedString(message.content)
 _ = match.map {
 let ranges = message.content.ranges(of: $0, options: [.caseInsensitive])
 ranges.forEach { range in
 result[range].backgroundColor = .orange.opacity(0.2)
 }
 }
 return result
 }
 
 */

//public extension StringProtocol {
//
//    func ranges<T: StringProtocol>(
//        of stringToFind: T,
//        options: String.CompareOptions = [],
//        locale: Locale? = nil
//    ) -> [Range<AttributedString.Index>] {
//
//        var ranges: [Range<String.Index>] = []
//        var attributedRanges: [Range<AttributedString.Index>] = []
//        let attributedString = AttributedString(self)
//
//        while let result = range(
//            of: stringToFind,
//            options: options,
//            range: (ranges.last?.upperBound ?? startIndex)..<endIndex,
//            locale: locale
//        ) {
//            ranges.append(result)
//            let start = AttributedString.Index(result.lowerBound, within: attributedString)!
//            let end = AttributedString.Index(result.upperBound, within: attributedString)!
//            attributedRanges.append(start..<end)
//        }
//        return attributedRanges
//    }
//}
