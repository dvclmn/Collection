//
//  SingleMessageView.swift
//  Banksia
//
//  Created by Dave Coleman on 11/4/2024.
//

import SwiftUI
import SwiftData
import Styles
import GeneralUtilities
import Icons

struct SingleMessageView: View {
    @Environment(BanksiaHandler.self) private var bk
    @Environment(ConversationHandler.self) private var conv
    
    @State private var isHovering: Bool = false
    
    @Bindable var message: Message
    
    let messageMaxWidth: Double = 300
    
    let authorAltPadding: Double = 80
    
    @FocusState private var isFocused
    
    var body: some View {
        
        //        var match: [String] {
        //            return [conv.searchText].filter { message.content.localizedCaseInsensitiveContains($0) }
        //        }
        //
        //        var highlighted: AttributedString {
        //            var result = AttributedString(message.content)
        //            _ = match.map {
        //                let ranges = message.content.ranges(of: $0, options: [.caseInsensitive])
        //                ranges.forEach { range in
        //                    result[range].backgroundColor = .orange.opacity(0.2)
        //                }
        //            }
        //            return result
        //        }
        //
        
        VStack {
            VStack {
                
                EditorRepresentable(
                    text: $message.content,
                    isFocused: $isFocused,
                    isEditable: false
                )
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(message.type == .user ? .blue : .gray).opacity(0.2))
                    .clipShape(.rect(cornerRadius: Styles.roundingMedium))
                    .padding(.leading, message.type == .user ? authorAltPadding : 0)
                    .padding(.trailing, message.type == .user ? 0 : authorAltPadding)
                    .padding(.bottom, 40)
                
                    .overlay(alignment: .topTrailing) {
                        if isHovering {
                            Button {
                                copyStringToClipboard(message.content)
                            } label: {
                                Label("Copy text", systemImage: Icons.copy.icon)
                            }
                            .buttonStyle(.customButton(size: .mini, labelDisplay: .iconOnly))
                            .padding(8)
                        }
                    }
                
            } // END inner vstack
            .frame(maxWidth: 620)
            .onTapGesture {
                withAnimation(Styles.animationQuick) {
                    isHovering.toggle()
                }
            }

        } // END outer vstack
        .padding(.horizontal, Styles.paddingText + Styles.paddingNSTextView)
        .frame(maxWidth: .infinity, alignment: message.type == .user ? .trailing : .leading)
    }
    
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        SingleMessageView(message: Message.response_02)
            .environment(BanksiaHandler())
            .environment(ConversationHandler())
            .frame(width: 500, height: 700)
    }
}
