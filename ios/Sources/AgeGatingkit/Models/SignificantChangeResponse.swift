//
//  SignificantChangeResponse.swift
//  Created by Sriteja Thuraka on 8/16/26.
//  Copyright © 2026 Sriteja Thuraka.
//  Licensed under the MIT License.
//  See LICENSE for details.

//

public enum SignificantChangeDecision: String, Codable, Sendable {
    case approved
    case denied
    case unknown
}

public struct SignificantChangeResponse: Codable, Sendable {
    public let questionID: String
    public let choiceID: String
    public let decision: SignificantChangeDecision
    
    public init(questionID: String, choiceID: String, decision: SignificantChangeDecision) {
        self.questionID = questionID
        self.choiceID = choiceID
        self.decision = decision
    }
}
