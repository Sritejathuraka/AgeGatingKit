
//
//  SignificantChangeService.swift
//
//  Created by Sriteja Thuraka on 8/16/26.
//  Copyright © 2026 Sriteja Thuraka.
//  Licensed under the MIT License.
//  See LICENSE for details.
//
import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(PermissionKit)
import PermissionKit
#endif



enum SignificantChangeService {

    #if canImport(UIKit) && canImport(PermissionKit)

    static func requestPermission(
        
        description: String,
        presentingViewController: UIViewController

    ) async throws {
        guard #available(iOS 26.2, *) else {
            throw AgeGatingError.unsupportedOS
        }

        let topic = SignificantAppUpdateTopic(
            description: description
        )

        let question = PermissionQuestion(
            significantAppUpdateTopic: topic
        )

        try await AskCenter.shared.ask(
            question,
            in: presentingViewController
        )
    }
    #endif
#if canImport(UIKit) && canImport(PermissionKit)

static func responses() -> AsyncStream<SignificantChangeResponse> {

    AsyncStream { continuation in
        
        Task {
            guard #available(iOS 26.2, macOS 26.2, *) else {
                continuation.finish()
                return
            }

            let responses =
                AskCenter.shared.responses(
                    for: SignificantAppUpdateTopic.self
                )

            do {
                for try await value in responses {
                    let decision: SignificantChangeDecision
                    
                    switch value.choice.answer {
                    case .approval:
                        decision = .approved
                    case .denial:
                        decision = .denied
                    @unknown default:
                        decision = .unknown
                    }
                    let result = SignificantChangeResponse(
                        questionID: value.question.id.uuidString,
                        choiceID: value.choice.id,
                        decision: decision
                    )
                    continuation.yield(result)
                }
            } catch {
            }

            continuation.finish()
        }
    }
}

#endif

}
