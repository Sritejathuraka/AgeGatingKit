//
//  AdultNotificationService.swift
//  AgeGatingkit
//
//  Created by Sriteja Thuraka on 8/16/26.
//  Copyright © 2026 Sriteja Thuraka.
//  Licensed under the MIT License.
//  See LICENSE for details.
//

import Foundation
import DeclaredAgeRange

#if canImport(UIKit)
import UIKit
#endif

enum AdultNotificationService {
    
    #if canImport(UIKit)

    static func showAcknowledgement(
        description: String,
        presentingViewController: UIViewController
    ) async throws {

        guard #available(iOS 26.4, *) else {
            throw AgeGatingError.unsupportedOS
        }

        guard let windowScene =
            await presentingViewController.view.window?.windowScene else {
            throw AgeGatingError.serviceUnavailable

        }

        try await AgeRangeService.shared.showSignificantUpdateAcknowledgment(
                in: windowScene,
                updateDescription: description
            )
    }

    #endif

}
