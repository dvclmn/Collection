//
//  File.swift
//
//
//  Created by Dave Coleman on 23/7/2024.
//

public enum PrintInfo {
    case userDefaultsURL
}

import SwiftUI

public struct PrintUserDefaults: ViewModifier {
    
    let info: PrintInfo
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                
                switch info {
                case .userDefaultsURL:
                    if let path = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first?.appendingPathComponent("Preferences").appendingPathComponent("com.yourcompany.yourapp.plist").path {
                        print("UserDefaults file path: \(path)")
                    }
                }
                
            }
    }
}
public extension View {
    func printInfo(
        _ info: PrintInfo
    ) -> some View {
        self.modifier(
            PrintUserDefaults(
                info: info
            )
        )
    }
}
