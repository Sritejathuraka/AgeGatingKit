//
//  AgeGatingResult.swift
//  AgeGatingKit
//  Created by Sriteja Thuraka on 8/16/26.
//  Copyright © 2026 Sriteja Thuraka.
//  Licensed under the MIT License.
//  See LICENSE for details.
//

public struct AgeGatingResult {
    
    public let isEligibleForAgeFearures: Bool?
    
    public let regulatoryFeatures: RegulatoryFeatures?
    
    public let ageRange: AgeRangeResult?
    
    public init(isEligibleForAgeFearures: Bool?, regulatoryFeatures: RegulatoryFeatures?, ageRange: AgeRangeResult?) {
        self.isEligibleForAgeFearures = isEligibleForAgeFearures
        self.regulatoryFeatures = regulatoryFeatures
        self.ageRange = ageRange
    }
    
}
