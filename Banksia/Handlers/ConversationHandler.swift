//
//  ConversationHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 15/11/2023.
//

import SwiftUI
import SwiftData

extension BanksiaHandler {
    func deleteAll(for modelContext: ModelContext) {
        do {
            try modelContext.delete(model: Conversation.self)
        } catch {
            print("Failed to clear Conversations.")
        }
    } // END delete all
    
    func sendMessage(userMessage: String) {
        // Trim the message to remove leading and trailing whitespaces and newlines
        let trimmedMessage = userMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if the trimmed message is not empty
        if !trimmedMessage.isEmpty {
            // Ensure there is a current conversation selected
            guard let conversation = currentConversation else {
                print("No conversation selected")
                return
            }
            // Create a Message object for the user's message and append it to the conversation
            // This is within the non-empty message check to avoid creating empty messages
            let userMessageObject = Message(content: "Q: \(trimmedMessage)", isUser: true, conversation: conversation)
            conversation.messages.append(userMessageObject)
            
            // Fetch the response from the server or API
            // This is within the non-empty message check because we only want to fetch a response if there's an actual message
            fetchResponse(prompt: trimmedMessage) { result in
                // Handle the response on the main thread to update the UI
                DispatchQueue.main.async {
                    switch result {
                    case .success(let textResponse):
                        // Create a Message object for the response and append it to the conversation
                        let responseMessage = Message(content: "A: \(textResponse)", isUser: false, conversation: conversation)
                        conversation.messages.append(responseMessage)
                    case .failure(let error):
                        // Handle the error case by appending an error message to the conversation
                        let errorMessage = Message(content: "Error: \(error.localizedDescription)", isUser: false, conversation: conversation)
                        conversation.messages.append(errorMessage)
                    }
                    // Update the UI or save changes to the data model here if necessary
                } // END Dispatch queue
            } // END fetch response
        } else {
            print("Message is empty, nothing to send")
        } // END check for empty message
    } // END send message
}
