//
//  AgeGatingResult.swift
//  AgeGatingKit
//
//  Copyright © 2026 Sriteja Thuraka.
//  Licensed under the MIT License.
//  See LICENSE for details.
//

public struct AgeGatingResult {
    
    public let isELigibleForAgeFearures: Bool
    
    public let regulatoryFeatures: RegulatoryFeatures?
    
    public let ageRange: AgeRangeResult?
    
    public init(isELigibleForAgeFearures: Bool, regulatoryFeatures: RegulatoryFeatures?, ageRange: AgeRangeResult?) {
        self.isELigibleForAgeFearures = isELigibleForAgeFearures
        self.regulatoryFeatures = regulatoryFeatures
        self.ageRange = ageRange
    }
    
}
