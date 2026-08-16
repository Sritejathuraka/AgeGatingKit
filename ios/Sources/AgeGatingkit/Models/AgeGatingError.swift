import Foundation

//  AgeGatingError.swift
//
//  Copyright © 2026 Sriteja Thuraka.
//  Licensed under the MIT License.
//  See LICENSE for details.
//

public enum AgeGatingError: Error {
    
    case unsupportedOS
    case unavailable
    case ageRangeNotShared
    case invalidAgeRangeResponse
    case serviceUnavailable
    case permissionUnavailable
    case platformError(String)
}

extension AgeGatingError: LocalizedError {

    public var errorDescription: String? {
        switch self {

        case .unsupportedOS:
            return "Age assurance is not supported on this OS version."

        case .unavailable:
            return "Age assurance is currently unavailable."

        case .ageRangeNotShared:
            return "Age range information was not shared."

        case .invalidAgeRangeResponse:
            return "The age range response could not be interpreted."

        case .serviceUnavailable:
            return "The age assurance service is unavailable."

        case .permissionUnavailable:
            return "The required permission service is unavailable."

        case .platformError (let message):
            return message
        }
    }
}
