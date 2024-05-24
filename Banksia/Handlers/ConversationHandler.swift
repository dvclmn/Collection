//
//  ConversationHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 15/11/2023.
//

import Foundation
import SwiftUI
import SwiftData
import Grainient

@Observable
final class ConversationHandler {
    
    let bk = BanksiaHandler()
    let pref = Preferences()
    
    var searchText: String = ""
    var isSearching: Bool = false
    
    var currentConversationID: Conversation.ID? = nil
    
    var grainientSeed: Int? = nil
    
    var isResponseLoading: Bool = false
    
    var isRequestingNewConversation: Bool = false
    var isConversationEditorShowing: Bool = false
    
    var selectedParagraph: String = ""
    
    /// This history should only be sent to GPT, not be saved to a Conversation. The Conversation has it's own array of Messages
    var messageHistory: String = ""
    
    var editorHeight: Double = ConversationHandler.defaultEditorHeight
    
    static let defaultEditorHeight: Double = 200
    
    func getCurrentConversation(within conversations: [Conversation]) -> Conversation? {
        conversations.first(where: {$0.id == currentConversationID})
    }
    
    func getConversation(from id: Conversation.ID, within conversations: [Conversation]) -> Conversation? {
        return conversations.first(where: {$0.id == id})
    }
    
    func createMessageHistory(for conversation: Conversation, latestMessage: Message) async {
        
        guard let messages = conversation.messages, !messages.isEmpty else {
            messageHistory = ""
            print("No message in conversation")
            return
        }
        
        let sortedMessages = messages.sorted { $0.timestamp < $1.timestamp }
        
        let maxMessageContextCount: Int = 8
        
        
        let historicalMessages: [Message] = sortedMessages.suffix(maxMessageContextCount).dropLast()
        
        let reSortedMessages = historicalMessages.sorted(by: {$0.timestamp > $1.timestamp})
        let historyFormatted: String = reSortedMessages.map {
            formatMessageForGPT($0)
        }.joined(separator: "\n\n")
        
        let latestMessageFormatted: String = "\(formatMessageForGPT(latestMessage))\n\n"
        let historyHeading: String = "## Conversation History\n"
        
        let queryID: String = latestMessage.persistentModelID.hashValue.description
        let queryFooter: String = "\n--- END Query #\(queryID) ---\n\n"
        
        
        messageHistory = """
        \(latestMessageFormatted)
        \(historyHeading)
        \(historyFormatted)
        \(queryFooter)
        """
        
        print(messageHistory)
        
    } // END createMessageHistory
    
    func getRandomParagraph() -> String {
        ExampleText.paragraphs.randomElement() ?? "No paragraphs available"
    }
    
    func formatMessageForGPT(_ message: Message) -> String {
        print("|--- formatMessageForGPT --->")
        
        let messageID: String = message.persistentModelID.hashValue.description
        
        let messageBegin: String = "\n\n### Message ID: \(messageID)\n"
        let timeStamp: String = "*Timestamp:* \(message.timestamp.formatted(.dateTime.year().month().day().hour().minute().second()))"
        let type: String = "*Author:* \(message.type.name)"
        let conversationID: String = "*Conversation ID:* \(message.conversation?.persistentModelID.hashValue.description ?? "No Conversation ID")"
        let content: String = "*Message:*\n\n\(message.content)"
        let messageEnd: String = "\n --- END Message ID: \(messageID) --- \n\n"
        
        let formattedMessage: String = """
        \(messageBegin)
        \(timeStamp)
        \(type)
        \(conversationID)
        \(content)
        \(messageEnd)
        """
        print(">--- END formatMessageForGPT ---|\n")
        return formattedMessage
    }
    
}

enum ConversationState {
    case blank
    case none
    case single
    case multiple
    
    init(totalConversations: Int, selectedConversation: Set<Conversation.ID>) {
        if totalConversations == 0 {
            self = .blank
        } else {
            switch selectedConversation.count {
            case 0:
                self = .none
            case 1:
                self = .single
            default:
                self = .multiple
            }
        } // END empty conversations check
    } // END init
    
    var emoji: [String] {
        switch self {
        case .blank:
            return ["🕸️", "🎃", "🌴", "🌵"]
        case .none:
            return ["🫧", "👠", "🪨", "🪸", "🕳️"]
        case .single:
            return []
        case .multiple:
            return ["💃", "🪶", "🐝", "🍌", "🦎"]
        }
    } // END emoji
    
    var title: [String] {
        switch self {
        case .blank:
            return [
                "Begin a new conversation",
                "Time to start a chat",
                "No conversations here"
            ]
        case .none:
            return [
                "Nothing selected",
                "No conversations selected",
                "Select a conversation"
            ]
        case .single:
            return []
        case .multiple:
            return [
                "Multiple conversations",
                "Multiple chats selected",
                "A few conversations selected"
            ]
        }
    } // END title
    
    var message: [String] {
        switch self {
        case .blank:
            return [
                "You have no conversations. Create a new one to get started.",
                "It's as good a time as any to create a conversation."
            ]
        case .none:
            return [
                "Make a selection from the list in the sidebar.",
                "You can pick something from the sidebar on the left."
            ]
        case .single:
            return []
        case .multiple:
            return [
                "You can delete them, or select other options from the toolbar above."
            ]
        }
    } // END title
    
    func randomEmoji() -> String {
        self.emoji.randomElement() ?? ""
    }
    func randomTitle() -> String {
        self.title.randomElement() ?? ""
    }
    func randomMessage() -> String {
        self.message.randomElement() ?? ""
    }
    
} // END coversation state


