//
//  SidebarView.swift
//  Banksia
//
//  Created by Dave Coleman on 10/4/2024.
//

import SwiftUI
import Styles
import SplitView
import Navigation

struct SidebarView: View {
    
    @Environment(BanksiaHandler.self) private var bk
    @Environment(ConversationHandler.self) private var conv
    @Environment(\.modelContext) var modelContext
    
    var conversations: [Conversation]
    
    var body: some View {
        
        @Bindable var bk = bk
        
        VStack {
            
            ForEach(conversations) { conversation in
                
                ConversationListItem(page: Page.conversation(conversation))
            } // END foreach
            
            
            //            .toolbar {
            //                ToolbarItem {
            //                    Button {
            //                        conv.isRequestingNewConversation = true
            //                    } label: {
            //                        Label("New conversation", systemImage: Icons.plus.icon)
            //                    }
            //                }
            //
            //                ToolbarItem {
            //                    Button {
            //                        bk.isGlobalConversationPreferencesShowing.toggle()
            //                    } label: {
            //                        Label("App-wide conversation preferences", systemImage: Icons.sliders.icon)
            //                    }
            //
            //
            //                }
            //            } // END toolbar
        } // END vstack
        .onAppear(perform: {
            bk.totalConversations = conversations.count
        })
        .onChange(of: conversations.count, {
            bk.totalConversations = conversations.count
        })
        
    }
}
//
//#Preview {
//    NavigationSplitView {
//        SidebarView(conversations: [Conversation.appKitDrawing, Conversation.childcare])
//    } detail: {
//        ConversationView(conversation: Conversation.appKitDrawing)
//    }
//    .environment(BanksiaHandler())
//    .environment(ConversationHandler())
//}
