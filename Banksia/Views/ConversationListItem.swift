//
//  ConversationListItem.swift
//  Banksia
//
//  Created by Dave Coleman on 19/11/2023.
//

import SwiftUI
import GeneralStyles
import Navigation
import Popup
import Sidebar
import Button
import Icons
import MultiSelect
import Renamable

struct ConversationListItem: View {
    @Environment(\.modelContext) private var modelContext
    
    @EnvironmentObject var nav: NavigationHandler
    @EnvironmentObject var bk: BanksiaHandler
    @Environment(ConversationHandler.self) private var conv
    
    @EnvironmentObject var sidebar: SidebarHandler
    @EnvironmentObject var popup: PopupHandler
    
    @State private var iconPickerShowing: Bool = false
    
    @State private var isRenaming: Bool = false
    
    var page: Page
    
    @Bindable var conversation: Conversation
    
    var body: some View {
        
        var isCurrentPage: Bool {
            return page == nav.path.last
        }
        
        NavigationLink(value: page) {
            
            Label(page.name, systemImage: "bubble.middle.bottom")
                .renamable(
                    isRenaming: $isRenaming,
                    itemName: conversation.name,
                    renameAction: { newName in
                        conversation.name = newName
                        popup.showPopup(title: "Renamed to \"\(conversation.name)\"")
                    })
                .frame(maxWidth: .infinity, alignment: .leading)
        } // END nav link
        .symbolRenderingMode(.hierarchical)
        .symbolVariant(.fill)
        .buttonStyle(.customButton(status: isCurrentPage ? .active : .normal, hasBackground: false))
        //        .multiSelect(
        //            item: conversation,
        //            displayedItems: displayedGames,
        //            cornerRadius: gameGridRounding
        //        )
        .contextMenu {
            Button {
                isRenaming = true
            } label: {
                Label("Rename…", systemImage: Icons.select.icon)
            }
            
            Button {
                do {
                    modelContext.delete(conversation)
                    try modelContext.save()
                    
                    popup.showPopup(title: "Deleted \(conversation.name)")
                } catch {
                    
                    print("Could not save")
                }
            } label: {
                Label("Delete conversation", systemImage: Icons.trash.icon)
            }
            
        } // END context menu
    }
}
//
//#Preview {
//    ConversationListItem(page: .conversation(Conversation.appKitDrawing), conversation: Conversation.appKitDrawing)
//        .environmentObject(BanksiaHandler())
//        .environmentObject(PopupHandler())
//}
