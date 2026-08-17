

//  AgeRangeResult.swift
//  AgeGatingKit
//
//  Created by Sriteja Thuraka on 8/16/26.
//  Copyright © 2026 Sriteja Thuraka.
//  Licensed under the MIT License.
//  See LICENSE for details.
//

public struct AgeRangeResult: Codable, Sendable {

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
