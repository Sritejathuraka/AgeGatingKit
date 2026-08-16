//

//  AgeAssuranceService.swift
//
//  Copyright © 2026 Sriteja Thuraka.
//  Licensed under the MIT License.
//  See LICENSE for details.
//
import Foundation
import DeclaredAgeRange
#if canImport(UIKit)

import UIKit

#endif



enum AgeAssuranceService {

    static func isEligibleForAgeFeatures() async throws -> Bool? {

        if #available(iOS 26.2, macOS 26.2, *) {
            return try await AgeRangeService.shared.isEligibleForAgeFeatures
        }

        return nil
    }
    
    static func requiredRegulatoryFeatures() async throws -> RegulatoryFeatures? {
        
        guard #available(iOS 26.4, macOS 26.4, *) else {
            return nil
        }
        
        let features = try await AgeRangeService.shared.requiredRegulatoryFeatures
        
        return RegulatoryFeatures(
            declaredAgeRangeRequired: features.contains(.declaredAgeRangeRequired),
            significantAppChangeRequiresParentalConsent: features.contains(.significantAppChangeRequiresParentalConsent),
            significantAppChangeRequiresAdultNotification: features.contains(.significantAppChangeRequiresAdultNotification)
        )
    }
    
    #if canImport(UIKit)
        
    static func requestAgeRange(
        ageGates: [Int],
        presentingViewController: UIViewController) async throws -> AgeRangeResult? {
            
        guard #available(iOS 26.2, *) else {
            throw AgeGatingError.unsupportedOS
        }

        guard (1...3).contains(ageGates.count) else {
            throw AgeGatingError.invalidAgeRangeResponse
        }

        let threshold1 = ageGates[0]
        let threshold2: Int? =
            ageGates.count >= 2 ? ageGates[1] : nil
        let threshold3: Int? =
            ageGates.count >= 3 ? ageGates[2] : nil
        let response =
            try await AgeRangeService.shared.requestAgeRange(
                ageGates: threshold1,
                threshold2,
                threshold3,
                in: presentingViewController
            )

        switch response {
        case .sharing(range: let range):
            return AgeRangeResult(
                lowerBound: range.lowerBound,
                upperBound: range.upperBound
            )
        case .declinedSharing:
            return nil
        @unknown default:

            throw AgeGatingError.invalidAgeRangeResponse

        }

    }
    #endif
}
