//
//  ToolbarView.swift
//  Banksia
//
//  Created by Dave Coleman on 10/4/2024.
//

import SwiftUI
import SwiftData
import GeneralStyles
import Navigation
import Popup
import Sidebar
import Modifiers
import Grainient
import Icons
import TextField
import GeneralUtilities
import Swatches

struct ToolbarView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(ConversationHandler.self) private var conv
    @Environment(BanksiaHandler.self) private var bk
    @EnvironmentObject var nav: NavigationHandler
    
    @EnvironmentObject var popup: PopupHandler
    @EnvironmentObject var sidebar: SidebarHandler
    @EnvironmentObject var pref: Preferences
    
    @State private var isLoading: Bool = false
    
    @State private var isToolbarMenuPresented: Bool = false
    @State private var isToolbarMenuToggleEnabled: Bool = true
    
    @State private var isRenaming: Bool = false
    
    @FocusState private var isSearchFocused: Bool
    
    
    @Bindable var conversation: Conversation
    
    var body: some View {
        
        @Bindable var conv = conv
        
        HStack(spacing: 14) {
            
            Text(nav.navigationTitle ?? "Banksia")
                .font(.title2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .renamable(
                    isRenaming: $isRenaming,
                    itemName: conversation.name
                ) { newName in
                    conversation.name = newName
                    popup.showPopup(title: "Renamed to \"\(newName)\"")
                }
            
            Spacer()
            
            if !sidebar.isSidebarVisible {
                NewConversationButton()
            }
            
            // MARK: - 􀈎 Edit conversation
            Button {
                conv.isConversationEditorShowing.toggle()
            } label: {
                Label("Edit conversation prompt", systemImage: Icons.edit.icon)
            }
            
            
            // MARK: - 􁎄 Grainient picker
//            GrainientPicker(
//                seed: $conversation.grainientSeed,
//                popup: popup
//            )
            
            
            
            // MARK: - 􀍠 Options
            Button {
                isToolbarMenuPresented = true

            } label: {
                Label("More options", systemImage: Icons.ellipsis.icon)
            }
            .disabled(!isToolbarMenuToggleEnabled)
            //            .buttonStyle(.customButton(labelDisplay: .iconOnly))
            
            .popover(isPresented: $isToolbarMenuPresented) {
                ConversationOptionsView(conversation: conversation)
            }
            .task(id: isToolbarMenuPresented) {
                if !isToolbarMenuPresented {
                    await disableToolbarMenuToggle()
                }
            }
            
            
            
            // MARK: - Search
            TextField("Search messages", text: $conv.searchText, prompt: Text("Search…"))
                .textFieldStyle(.customField(text: $conv.searchText, isFocused: isSearchFocused))
                .focused($isSearchFocused)
                .frame(maxWidth: isSearchFocused ? 240 : 120)
                .onExitCommand {
                    isSearchFocused = false
                }
            
        } // END toolbar hstack
        .buttonStyle(
            .customButton(
                hasBackground: false,
                labelDisplay: .iconOnly
            )
        )
        .animation(Styles.animation, value: isSearchFocused)
        .safeAreaPadding(.leading, isPreview && !sidebar.isSidebarVisible ? Styles.toolbarSpacing : (sidebar.isSidebarVisible ? sidebar.sidebarWidth : Styles.paddingToolbarTrafficLightsWidth))
        .frame(
            maxWidth: .infinity,
            minHeight: Styles.toolbarHeight,
            maxHeight: Styles.toolbarHeight,
            alignment: .leading
        )
        /// Allows space for the sidebar toggle button 􀨱 when the sidebar is hidden
        .padding(.leading, sidebar.isSidebarVisible ? 0 : 30)
        
        .padding(.horizontal, Styles.toolbarSpacing)
        .background {
            Rectangle().fill(.ultraThinMaterial)
                .safeAreaPadding(.leading, sidebar.isSidebarVisible ? sidebar.sidebarWidth : 0)
        }

        
        // MARK: - 􀨱 Sidebar buttons
        .overlay(alignment: .leading) {
            
            HStack {
//            if sidebar.isRoomForSidebar {
                    Button {
                            if !sidebar.isRoomForSidebar {
                                sidebar.requestRoomForSidebar()
                            } else {
                                
                                sidebar.toggleSidebar()
                                
                            }
                    } label: {
                        Label("Toggle sidebar", systemImage: Icons.sidebarAlt.icon)
                    }
                    
//                }  END room for sidebar check
                
                // MARK: - 􀅼 New conversation
                if sidebar.isSidebarVisible {
                    NewConversationButton()
                        .buttonStyle(.customButton(hasBackground: false, labelDisplay: .iconOnly))
                    
                    
                } // END sidebar showing check
            } // END hstack
            .task(id: conv.currentRequest) {
                switch conv.currentRequest {
                case .search:
                    isSearchFocused = true
                default:
                    break
                }
                conv.currentRequest = .none
            }

            .safeAreaPadding(.leading, isPreview ? Styles.toolbarSpacing : Styles.paddingToolbarTrafficLightsWidth)
                .buttonStyle(.customButton(hasBackground: false, labelDisplay: .iconOnly))
        } // END toolbar sidebar controls overlay
        
    }
}

extension ToolbarView {
    
    func disableToolbarMenuToggle() async {
        isToolbarMenuToggleEnabled = false
        try? await Task.sleep(for: .seconds(0.5))
        isToolbarMenuToggleEnabled = true
    }
    
    @ViewBuilder
    func NewConversationButton() -> some View {
        Button {
            conv.currentRequest = .new
        } label: {
            Label("New conversation", systemImage: Icons.plus.icon)
        }
    }
}
