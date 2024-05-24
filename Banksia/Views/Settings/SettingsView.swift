//
//  SettingsView.swift
//  Banksia
//
//  Created by Dave Coleman on 16/11/2023.
//

import SwiftUI
import SwiftData
import Grainient
import Swatches
import KeychainHandler
import Popup
import Icons
import Button
import APIHandler

@MainActor
struct SettingsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var pref: Preferences
    @EnvironmentObject var popup: PopupHandler
    
    @Environment(BanksiaHandler.self) private var bk
    
    @State private var apiKey: String = ""
    
    @State private var isShowingSecureInformation: Bool = false
    @State private var isConnectedToOpenAI: Bool = false
    @State private var isLoadingConnection: Bool = false
    
    let apiKeyString: String = "openAIAPIKey"
    
    var body: some View {
        
        
        @Bindable var bk = bk
        
        
        
//        TabView {
            Form {
                
                Section("Interface") {
                    LabeledContent {
                        Slider(
                            value: $bk.uiDimming,
                            in: 0.01...0.89) { changed in
                                if changed {
                                    pref.uiDimming = bk.uiDimming
                                }
                            }
                            .controlSize(.mini)
                            .tint(Swatch.lightGrey.colour)
                            .frame(
                                minWidth: 60,
                                maxWidth: 90
                            )
                    } label: {
                        Text("Interface dimming")
                    }
                }
                
                
                
                Section("API") {
                    LabeledContent {
                        Group {
                            if isShowingSecureInformation {
                                TextField("API Key", text: $apiKey, prompt: Text("Enter OpenAI API Key"))
                                    .onSubmit {
                                        Task {
                                            await submitAPIKey()
                                        }
                                    }
                            } else {
                                SecureField("API Key", text: $apiKey, prompt: Text("Enter OpenAI API Key"))
                                
                                    .onSubmit {
                                        Task {
                                            await submitAPIKey()
                                        }
                                    }
                            }
                        } // END group
                        .labelsHidden()
                    } label: {
                        HStack {
                            Text("API Key")
                            Button {
                                isShowingSecureInformation.toggle()
                            } label: {
                                Label(isShowingSecureInformation ? "Hide key" : "Show key", systemImage: Icons.eye.icon)
                            }
                            .buttonStyle(.customButton(size: .mini, status: isShowingSecureInformation ? .active : .normal, hasBackground: false, labelDisplay: .iconOnly))
                        }
                        .padding(.bottom, 6)
                        
                        if !apiKey.isEmpty {
                            HStack(spacing: 0) {
                                Text("Status: \(isConnectedToOpenAI ? "Connected" : "No connection")")
                                if isLoadingConnection {
                                    Image(systemName: Icons.rays.icon)
                                        .spinning()
                                }
                            }
                            .fixedSize(horizontal: true, vertical: false)
                        }
                    }
                    
                    
                    LabeledContent {
                        Picker("Select model", selection: $pref.gptModel) {
                            ForEach(AIModel.allCases.reversed(), id: \.self) { model in
                                Text(model.name).tag(model.value)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                    } label: {
                        Text("Select model")
                            .padding(.bottom, 6)
                        VStack(alignment: .leading) {
                            //                        Text("Current: \(pref.gptModel.name)")
                            Text("Context window: **\(pref.gptModel.contextWindow)**")
                            Text("Training cut-off: **\(pref.gptModel.trainingCutoff)**")
                            Text("More information: [\(pref.gptModel.value)](\(pref.gptModel.infoURL))")
                        }
                        
                        
                    }
                    
                    LabeledContent {
                        
                        Slider(
                            value: $pref.gptTemperature,
                            in: 0.0...1.0,
                            step: 0.1
                        )
                    } label: {
                        Text("GPT temperature")
                    }
                }
            } // END form
            .scrollContentBackground(.hidden)
            .formStyle(.grouped)
//        } // END tabview
//        .tabViewStyle(.automatic)
        .grainient(seed: 24139, dimming: .constant(0.3))
//        .task(id: apiKey) {
//            isConnectedToOpenAI = await verifyOpenAIConnection()
//        }
        
    }
}

extension SettingsView {
    
    private func verifyOpenAIConnection() async -> Bool {
        
        isLoadingConnection = true
        
        guard let key = KeychainHandler.shared.readString(for: apiKeyString) else {
            print("Could not get key from keychain")
            isLoadingConnection = false
            return false
        }
        
        let url: String = "https://api.openai.com/v1/models"
        
        do {
            let result: TestResponse = try await APIHandler.fetchAndDecodeJSON(
                url: URL(string: url),
                requestType: .get,
                bearerToken: key
            )
            print("Data from OpenAI: \(result)")
            
            isLoadingConnection = false
            return true
            
        } catch {
            isLoadingConnection = false
            return false
        }
        
    }
    
    private func submitAPIKey() async {
        do {
            try KeychainHandler.shared.save(self.apiKey, for: apiKeyString)
            self.isConnectedToOpenAI = await verifyOpenAIConnection()
        } catch {
            popup.showPopup(title: "Issue saving API Key", message: "Please try again.")
        }
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        
        SettingsView()
        
    }
    .environment(BanksiaHandler())
    .environmentObject(Preferences())
    .frame(width: 380, height: 700)
    .background(.contentBackground)
}

