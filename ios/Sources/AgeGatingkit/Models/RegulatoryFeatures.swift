
//
//  RegulatoryFeatures.swift
//  AgeGatingKit
//  Copyright © 2026 Sriteja Thuraka.
//  Licensed under the MIT License.
//  See LICENSE for details.
//

public struct RegulatoryFeatures {
    
    public let declaredAgeRangeRequired: Bool
    
    public let significantAppChangeRequiresParentalConsent: Bool

    public let significantAppChangeRequiresAdultNotification: Bool

    public init( declaredAgeRangeRequired: Bool, significantAppChangeRequiresParentalConsent: Bool, significantAppChangeRequiresAdultNotification: Bool

    ) {
        self.declaredAgeRangeRequired = declaredAgeRangeRequired
        self.significantAppChangeRequiresParentalConsent = significantAppChangeRequiresParentalConsent
        self.significantAppChangeRequiresAdultNotification = significantAppChangeRequiresAdultNotification
    }

}
