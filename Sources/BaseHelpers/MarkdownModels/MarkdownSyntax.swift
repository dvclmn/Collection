//
//  File.swift
//
//
//  Created by Dave Coleman on 10/8/2024.
//


import Foundation
import SwiftUI
import RegexBuilder


public extension Markdown {
  enum SyntaxType {
    case inline
    case block
  }
}


public extension Markdown {
  
  enum Syntax: Identifiable, Equatable, Hashable, Sendable {
    
    case heading(level: Int)
    
    case bold
    case italic
    case boldItalic
    
    case strikethrough
    case highlight
    case inlineCode
    
    case list
    
    case horizontalRule
    
    /// To be supported in future versions:
    // case table(columns: [PresentationIntent.TableColumn])
    // case tableCell(columnIndex: Int)
    // case tableHeaderRow
    // case tableRow(rowIndex: Int)
    
    case codeBlock
    //    case codeBlock(language: LanguageHint?)
    case quoteBlock
    
    case link
    case image
    
    nonisolated public var id: String {
      self.name
    }
    
    public var name: String {
      
      switch self {
        case .heading(let level):
          return "Heading \(level)"
          
        case .bold: return "Bold"
        case .italic: return "Italic"
        case .boldItalic: return "Bold Italic"
        case .strikethrough: return "Strikethrough"
        case .highlight: return "Highlight"
        case .inlineCode: return "Inline code"
        case .list: return "List"
        case .horizontalRule: return "Horizontal rule"
        case .codeBlock: return "Code block"
          
        case .quoteBlock: return "Quote"
        case .link: return "Link"
        case .image: return "Image"
      }
      
    }
    
    var type: SyntaxType {
      switch self {
        case
            .bold,
            .italic,
            .boldItalic,
            .strikethrough,
            .highlight,
            .inlineCode:
          return .inline
          
        case
            .heading,
            .codeBlock,
            .quoteBlock,
            .list,
            .link,
            .image,
            .horizontalRule:
          return .block

      }
    }
    
    var leadingCharacter: Character? {
      switch self {
        case .heading:
          return "#"
          
        case .bold, .italic, .boldItalic:
          return "*"
          
        case .inlineCode:
          return "`"
        case .highlight:
          return "="
        case .strikethrough:
          return "~"
        default:
          return nil
          
      }
    }
    
    var trailingCharacter: Character? {
      switch self {
        case .heading:
          return "\n"
          
        case .bold, .italic, .boldItalic, .inlineCode, .highlight, .strikethrough:
          /// These are 'symmetrical' syntaxes, so their leading and trailing characters will be the same
          return self.leadingCharacter
          
        default:
          return nil
      }
    }
    
    var leadingCharacterCount: Int? {
      switch self {
        case .heading(let level): level
        case .bold, .strikethrough, .highlight:
          2
        case .italic, .inlineCode:
          1
        case .boldItalic:
          3
          
        default:
          nil
      }
    }
    
    var trailingCharacterCount: Int? {
      switch self {
        case .heading(let level): level
        case .bold, .strikethrough, .highlight:
          2
        case .italic, .inlineCode:
          1
        case .boldItalic:
          3
          
        default:
          nil
      }
    }
    
    
//    public var shortcuts: [KBShortcut] {
//      switch self {
//        case .heading(let level):
//          return [
//            KBShortcut(
//              .character(Character("\(level)")),
//              modifiers: [.command]
//            )
//          ]
//          
//        case .bold:
//          return [
//            KBShortcut(
//              .character("b"),
//              modifiers: [.command],
//              label: KBShortcut.Label(title: self.name, icon: "bold")
//            )
//          ]
//        case .italic:
//          return [
//            KBShortcut(
//              .character("i"),
//              modifiers: [.command],
//              label: KBShortcut.Label(title: self.name, icon: "italic")
//            )
//          ]
//        case .boldItalic:
//          return [
//            KBShortcut(
//              .character("b"),
//              modifiers: [.command, .shift]
//            )
//          ]
//        case .inlineCode:
//          return [
//            KBShortcut(
//              .character("`"),
//              label: KBShortcut.Label(title: self.name, icon: "chevron.left.forwardslash.chevron.right")
//            )
//          ]
//        case .highlight:
//          return [
//            KBShortcut(
//              .character("h"),
//              modifiers: [.command]
//            )
//          ]
//        case .strikethrough:
//          return [
//            KBShortcut(
//              .character("s"),
//              modifiers: [.command]
//            )
//          ]
//          
//        default:
//          return []
//      }
//    }

    
//    static func findMatchingSyntax(for shortcut: KBShortcut) -> Markdown.Syntax? {
//      for syntax in Markdown.Syntax.allCases {
//        if syntax.shortcuts.contains(shortcut) {
//          return syntax
//        }
//      }
//      return nil
//    }
    
    
    
    
    
  }
  
  
}


extension Markdown.Syntax {
  
  static public var symmetricalSyntax: [Markdown.Syntax] {
    [
      .heading(level: 1),
      .heading(level: 2),
      .heading(level: 3),
      .heading(level: 4),
      .heading(level: 5),
      .heading(level: 6),
      .bold,
      .italic,
      .boldItalic,
      .inlineCode,
      .highlight,
      .strikethrough
    ]
  }
  
  static public var allCases: [Markdown.Syntax] {
    
    return [
      .heading(level: 1),
      .heading(level: 2),
      .heading(level: 3),
      .heading(level: 4),
      .heading(level: 5),
      .heading(level: 6),
      .bold,
      .italic,
      .boldItalic,
      .strikethrough,
      .highlight,
      .inlineCode,
      .list,
      .horizontalRule,
      .codeBlock,
      .quoteBlock,
      .link,
      .image
    ]
  }
  
  static public var testCases: [Markdown.Syntax] {
    return [
//      .bold,
//      .italic,
//      .boldItalic,
//      .strikethrough,
//      .highlight,
//      .inlineCode,
      .codeBlock
    ]
  }
}
