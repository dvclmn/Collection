//
//  File.swift
//
//
//  Created by Dave Coleman on 20/7/2024.
//

import Foundation

public struct OpenAIConfirmationResponse: Codable, Sendable {
  let object: String
  let data: [OpenAIConfirmationResponseData]
}
public struct OpenAIConfirmationResponseData: Codable, Sendable {
  let id: String
  let object: String
  let created: Int
  let owned_by: String
}

public struct OpenAI: Codable, Sendable {
  static let name: String = "OpenAI"
  
#if DEBUG
  static let apiKey: String = "openAIAPIKeyDebug"
  #else
  static let apiKey: String = "openAIAPIKey"
#endif
  
  
  static let endpoint: URL? = URL(string: "https://api.openai.com/v1/chat/completions")
  static let modelInfoURL: URL? = URL(string: "https://platform.openai.com/docs/models")
  
  static let requestType: APIRequestType = .post
  
  static let infoURLBase: String = "https://openai.com"
  
  /// # Headers
  ///
  /// Authentication
  ///
  public static let authHeaderKey: String = "Authorization"
  public static let orgHeaderKey: String = "OpenAI-Organization"
  public static let projectHeaderKey: String = "OpenAI-Project"
  
  /// Content type
  ///
  public static let contentTypeHeaderKey: String = "Content-Type"
  public static let contentTypeHeaderValue: String = "application/json"
  
  public static func headers(with key: String, for project: String? = nil) -> [String : String] {
    
    let result: [String : String]
    
    if let project = project {
      result = [
        contentTypeHeaderKey : contentTypeHeaderValue,
        authHeaderKey : "Bearer " + key,
        projectHeaderKey : project
      ]
    } else {
      result = [
        contentTypeHeaderKey : contentTypeHeaderValue,
        authHeaderKey : "Bearer " + key
      ]
    }

    return result
  }
  
  static let temperatureTip: String = "Lower values for temperature result in more consistent outputs (e.g. 0.2), while higher values generate more diverse and creative results (e.g. 1.0). Select a temperature value based on the desired trade-off between coherence and creativity for your specific application. The temperature can range is from 0 to 2."
}



public struct OpenAIStreamedResponse: StreamedResponse {
  let id: String
  let object: String // e.g. "chat.completion.chunk"
  let created: Int
  let model: String
  let choices: [Choice]
  let usage: Usage?
  
  public var responseData: StreamedResponseMessage? {
    return choices.first?.delta
  }
  
  /// `choices`
  public struct Choice: Decodable, Sendable {
    let index: Int
    let delta: Delta
    let finish_reason: String?
    
    /// `delta`
    public struct Delta: StreamedResponseMessage {
      let role: String?
      let content: String?
      
      public var text: String? {
        return content
      }
    }
  }
  
  /// `usage`
  public struct Usage: StreamedResponseUsage {
    let prompt_tokens: Int
    let completion_tokens: Int
    let total_tokens: Int
    
    public var input_tokens: Int? {
      return prompt_tokens
    }
    public var output_tokens: Int? {
      return completion_tokens
    }
  }
}
