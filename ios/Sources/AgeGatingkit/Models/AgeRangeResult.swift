

//  AgeRangeResult.swift
//  AgeGatingKit
//
//  Copyright © 2026 Sriteja Thuraka.
//  Licensed under the MIT License.
//  See LICENSE for details.
//

public struct AgeRangeResult {

    public let lowerBound: Int?
    public let upperBound: Int?

    public init(
        lowerBound: Int?,
        upperBound: Int?
    ) {
        self.lowerBound = lowerBound
        self.upperBound = upperBound
    }
}
