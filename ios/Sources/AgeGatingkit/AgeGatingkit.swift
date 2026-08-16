//  AgeGating.swift
//
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
                isELigibleForAgeFearures: eligibility,
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
            isELigibleForAgeFearures: eligibility,
            regulatoryFeatures: regulatoryFeatures,
            ageRange: ageRange
        )
    }
    
    public static func requestSignificatntAppUpdatePermission(
        descrition: String,
        presentingViewController: UIViewController
    ) async throws {
        try await SignificantChangeService.requestPermission(
            descrition: descrition,
            presentingViewController: presentingViewController
        )
    }
    
    public static func significantAppUpdateResponses()
    -> AsyncStream<SignificantChangeResponse> {
        SignificantChangeService.responses()
    }
    

    #endif
}
