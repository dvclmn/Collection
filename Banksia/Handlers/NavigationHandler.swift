//
//  NavigationHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 23/5/2024.
//

import Foundation
import SwiftUI
import GeneralStyles
import Navigation
import Icons
import Grainient


class NavigationHandler: Navigable, ObservableObject {
    
    @Published public var path: [Page] = []
    @AppStorage("lastDestinationKey") var lastDestination: String?

    var navigationTitle: String? {
        if let pathLast = self.path.last?.name {
            return pathLast
        } else {
            return nil
        }
    }
    func navigate(to page: Page) {
        if path.last != page {
            path.append(page)
        } else {
            print("Already on \(page.name)")
        }
    }
    
    func updateLastDestination() {
        if let last = path.last {
            lastDestination = last.name
        } else {
            print("No last item in path")
        }
    }
    
    //    public func goBack() {
    //        if canGoBack {
    //            path.removeLast()
    //        }
    //    }
}

enum Page: Destination {
    
    case conversation(Conversation)
    case feedback
    
    var id: String {
        self.name
    }
    
    var name: String {
        switch self {
        case .conversation(let conversation):
            return conversation.name
        case .feedback:
            return "Feedback"
        }
    }
    
    var icon: String {
        switch self {
        case .conversation(let conversation):
            return conversation.icon ?? Icons.message.icon
        case .feedback:
            return Icons.text.icon
        }
    }
    
    var grainientSeed: Int? {
        switch self {
        case .conversation(let conversation):
            return conversation.grainientSeed
        case .feedback:
            return GrainientPreset.algae.seed
        }
    }
}
