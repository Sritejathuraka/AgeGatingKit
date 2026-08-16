//
//  SignificantChangeResponse.swift
//  Copyright © 2026 Sriteja Thuraka.
//  Licensed under the MIT License.
//  See LICENSE for details.

//

public enum SignificantChangeDecision {
    case approved
    case denied
    case unknown
}

public struct SignificantChangeResponse {
    public let questionID: String
    public let choiceID: String
    public let decision: SignificantChangeDecision
    
    public init(questionID: String, choiceID: String, decision: SignificantChangeDecision) {
        self.questionID = questionID
        self.choiceID = choiceID
        self.decision = decision
    }
}
