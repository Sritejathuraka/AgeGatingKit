
//
//  RegulatoryFeatures.swift
//  AgeGatingKit
//  Created by Sriteja Thuraka on 8/16/26.
//  Copyright © 2026 Sriteja Thuraka.
//  Licensed under the MIT License.
//  See LICENSE for details.
//

public struct RegulatoryFeatures: Codable, Sendable {
    
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
