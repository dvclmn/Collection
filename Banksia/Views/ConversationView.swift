//
//  ConversationView.swift
//  Banksia
//
//  Created by Dave Coleman on 19/11/2023.
//

import SwiftUI
import SwiftData
import Styles
import Utilities
import ResizableView

struct ConversationView: View {
    @Environment(BanksiaHandler.self) private var bk
    @Environment(ConversationHandler.self) private var conv
    @EnvironmentObject var pref: Preferences
    @Environment(\.modelContext) private var modelContext
    
    
    
    @Query private var messages: [Message]
    
    var conversation: Conversation?
    
    init(filter: Predicate<Message>? = nil, conversation: Conversation?) {
        self.conversation = conversation
        
        if let filter = filter {
            _messages = Query(filter: filter)
        } else {
            _messages = Query()
        }
    }
    
    var body: some View {
        
        @Bindable var conv = conv
        @Bindable var bk = bk
        
        
            
            if let conversation = conversation, let conversationMessages = conversation.messages {
                
                var searchResults: [Message] {
                    conversationMessages.filter { message in
                        if conv.searchText.count > 1 {
                            return message.content.localizedCaseInsensitiveContains(conv.searchText)
                        } else {
                            return true
                        }
                    }
                }
                
                ScrollView(.vertical) {
                    LazyVStack(spacing: 12) {
                        ForEach(searchResults.sorted(by: { $0.timestamp < $1.timestamp }), id: \.timestamp) { message in
                            
                            SingleMessageView(message: message)
                            
                        } // END ForEach
                        //                    Text("End of messages")
                    } // END lazy vstack
                    .scrollTargetLayout()
                    .padding(.bottom, 80)
                } // END scrollview
                .safeAreaPadding(.bottom, conv.editorHeight + 30)
                //            .searchable(text: $conv.searchText, isPresented: $conv.isSearching, prompt: Text("Search messages"))
                //                                        .scrollPosition(id: message.timestamp)
                .defaultScrollAnchor(.bottom)
                
                .overlay(alignment: .bottom) {
                    MessageInputView(
                        conversation: conversation
                    )
                }
                .sheet(isPresented: $bk.isConversationEditorShowing) {
                    
                    ConversationEditorView(conversation: conversation)
                    
                }
                //            .onAppear {
                //                if isPreview {
                //                    editorHeight = 100
                //                }
                //            }
                .overlay {
                    if bk.isQuickNavShowing {
                        QuickNavView()
                    }
                }
                
                
            } else {
                Text("No messages yet")
            } // END messages check
        
        //        .toolbar {
        //            ToolbarItem {
        //                Button {
        //                    bk.isConversationEditorShowing.toggle()
        //                } label: {
        //                    Label("Edit conversation prompt", systemImage: Icons.edit.icon)
        //                }
        //            }
        //        }
        
        
    } // END view body
    
    //    private func scrollToNextID() {
    //        print("Let's scroll to next")
    //
    //        guard let messages = conversation.messages else {
    //            print("Couldn't get first convo's messages")
    //            return
    //        }
    //
    //        guard let id = messageID else {
    //            print("Couldn't get id to equal message")
    //            return
    //        }
    //
    //        guard id != messages.last?.id else {
    //            print("id ended up being the same as messages.last")
    //            return
    //        }
    //
    //        guard let index = messages.firstIndex(where: { $0.id == id }) else {
    //            print("couldn't get index to equal the first message where the message ID matched the `messageID` binding")
    //            return
    //        }
    //
    //
    //        withAnimation {
    //            messageID = messages[index + 1].id
    //            print(messageID ?? UUID())
    //        }
    //    }
    
    //    private func scrollToPreviousID() {
    //        print("Let's scroll to next")
    //
    //        guard let messages = conversation.messages else {
    //            print("Couldn't get first convo's messages")
    //            return
    //        }
    //
    //        guard let id = messageID, id != messages.first?.id,
    //              let index = messages.firstIndex(where: { $0.id == id })
    //        else {
    //            print("Couldn't get that complex stuff")
    //            return
    //        }
    //
    //        withAnimation {
    //            messageID = messages[index - 1].id
    //            print(messageID ?? UUID())
    //        }
    //    }
    
    
}


#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        
        ContentView()
            .environment(BanksiaHandler())
            .environment(ConversationHandler())
            .environmentObject(Preferences())
            .frame(width: 480, height: 700)
        
    }
}
