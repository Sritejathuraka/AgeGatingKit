//  AgeGating.swift
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

public enum AgeGating {

    #if canImport(UIKit)

    public static func check(
        ageGates: [Int],
        presentingViewController: UIViewController
    ) async throws -> AgeGatingResult {

        // 1. Check whether age features are applicable
        let eligibility =
            try await AgeAssuranceService.isEligibleForAgeFeatures()

        // 2. If not eligible (or unsupported), return immediately
        guard eligibility == true else {
            return AgeGatingResult(
                isEligibleForAgeFearures: eligibility,
                regulatoryFeatures: nil,
                ageRange: nil
            )
        }

        // 3. Get Apple's required regulatory features
        let regulatoryFeatures =
            try await AgeAssuranceService.requiredRegulatoryFeatures()

        // 4. Request the age range
        let ageRange =
            try await AgeAssuranceService.requestAgeRange(
                ageGates: ageGates,
                presentingViewController: presentingViewController
            )

        // 5. Return everything to the developer
        return AgeGatingResult(
            isEligibleForAgeFearures: eligibility,
            regulatoryFeatures: regulatoryFeatures,
            ageRange: ageRange
        )
    }
    
    // MARK: - Significant Change - Parental Consent
    
    public static func requestSignificatntAppUpdatePermission(
        description: String,
        presentingViewController: UIViewController
    ) async throws {
        try await SignificantChangeService.requestPermission(
            description: description,
            presentingViewController: presentingViewController
        )
    }
    
    public static func significantAppUpdateResponses()
    -> AsyncStream<SignificantChangeResponse> {
        SignificantChangeService.responses()
    }
    
    // MARK: - Significant Change - Adult Notification
    
    public static func showSignificantAppUpdateAdultNotification(
        decription: String,
        presentingViewController: UIViewController
    ) async throws {
        try await AdultNotificationService.showAcknowledgement(
            description: decription,
            presentingViewController: presentingViewController
        )
    }
    

    #endif
}
