//
//  DetailView.swift
//  Banksia
//
//  Created by Dave Coleman on 23/5/2024.
//

import SwiftUI
//import Navigation
import Popup
import Sidebar
import SwiftData
import StateView

struct DetailView: View {
    @EnvironmentObject var popup: PopupHandler
    @EnvironmentObject var sidebar: SidebarHandler
    
    @Query private var conversations: [Conversation]
    
    @State private var scrolledMessageID: Message.ID?
    
    var page: Page? = nil
    
    var body: some View {
        
        VStack {
            switch page {
                
            case .conversation(let conversationStatic):
                
                if let conversation = conversations.first(where: {$0.persistentModelID == conversationStatic.persistentModelID}) {
                    
                    HStack(spacing: 0) {
                        SidebarView()
                        
                        VStack {
                            ConversationView(
                                conversation: conversation,
                                scrolledMessageID: $scrolledMessageID
                            )
                        }
                        
                    } // END hstack
                    
                    .overlay(alignment: .top) {
                        ToolbarView(conversation: conversation)
                    }
                    .overlay(alignment: .top) {
                        PopupView(
                            topOffset: 70,
                            popup: popup
                        )
                        .safeAreaPadding(.leading, sidebar.isSidebarVisible ? sidebar.sidebarWidth : 0)
                    }
                    .navigationBarBackButtonHidden(true)
                    
                } else {
                    StateView(title: "No Conversations")
                }
                
            case .none:
                HStack(spacing: 0) {
                    SidebarView()
                    
                    StateView(title: "No Page Selection")
                    
                } // END hstack
                
    //            .overlay(alignment: .top) {
    //                ToolbarView(conversation: conversation)
    //            }
                .overlay(alignment: .top) {
                    PopupView(
                        topOffset: 70,
                        popup: popup
                    )
                    .safeAreaPadding(.leading, sidebar.isSidebarVisible ? sidebar.sidebarWidth : 0)
                }
                .navigationBarBackButtonHidden(true)
            }
        } // END main vstack
        .overlay {
            QuickOpenView()
        }

    }
}

//extension DetailView {
//    
//    @ViewBuilder
//    func Detail() -> some View {
//        
//    }
//    
//}
