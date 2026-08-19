//
//  ViewController.swift
//  example-age-gating-iOS
//
//  Created by Sriteja Thuraka on 8/18/26.
//

import UIKit
import AgeGatingKit

final class ViewController: UIViewController {

    private let contentView = AgeGatingExampleView()
    private var responseTask: Task<Void, Never>?

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupActions()
        observeParentalConsentResponses()
    }

    deinit {
        responseTask?.cancel()
    }

    private func setupActions() {
        contentView.checkAgeButton.addTarget(
            self,
            action: #selector(checkAgeTapped),
            for: .touchUpInside
        )

        contentView.parentalConsentButton.addTarget(
            self,
            action: #selector(parentalConsentTapped),
            for: .touchUpInside
        )

        contentView.adultNotificationButton.addTarget(
            self,
            action: #selector(adultNotificationTapped),
            for: .touchUpInside
        )
    }

    @objc
    private func checkAgeTapped() {
        Task {
            await contentView.setCheckAgeLoading(true)

            defer {
                Task { @MainActor in
                    self.contentView.setCheckAgeLoading(false)
                }
            }

            do {
                let result = try await AgeGating.check(
                    ageGates: [13, 16, 18],
                    presentingViewController: self
                )

                await MainActor.run {
                    self.contentView.update(with: result)
                }
            } catch {
                await MainActor.run {
                    self.contentView.showEligibilityError()
                    self.showError(error)
                }
            }
        }
    }

    @objc
    private func parentalConsentTapped() {
        Task {
            await MainActor.run {
                contentView.setParentalConsentLoading(true)
                contentView.parentDecisionLabel.text = "Sending request..."
            }

            do {
                try await AgeGating.requestSignificatntAppUpdatePermission(
                    description:
                        "Parental consent required for changes in the latest release.",
                    presentingViewController: self
                )

                await MainActor.run {
                    contentView.setParentalConsentLoading(false)
                    contentView.parentalConsentButton.isEnabled = false
                    contentView.parentDecisionLabel.text = "Waiting for parent..."
                }
            } catch {
                await MainActor.run {
                    contentView.setParentalConsentLoading(false)
                    contentView.parentDecisionLabel.text = "Error"
                    showError(error)
                }
            }
        }
    }

    @objc
    private func adultNotificationTapped() {
        Task {
            await MainActor.run {
                contentView.setAdultNotificationLoading(true)
                contentView.adultNotificationStatusLabel.text = "Opening..."
            }

            do {
                try await AgeGating.showSignificantAppUpdateAdultNotification(
                    decription:
                        "Please review changes in the latest release.",
                    presentingViewController: self
                )

                await MainActor.run {
                    contentView.setAdultNotificationLoading(false)
                    contentView.adultNotificationStatusLabel.text = "Completed"
                }
            } catch {
                await MainActor.run {
                    contentView.setAdultNotificationLoading(false)
                    contentView.adultNotificationStatusLabel.text = "Error"
                    showError(error)
                }
            }
        }
    }

    private func observeParentalConsentResponses() {
        responseTask?.cancel()

        responseTask = Task { [weak self] in
            guard let self else { return }

            for await response in AgeGating.significantAppUpdateResponses() {
                guard !Task.isCancelled else { break }

                await MainActor.run {
                    self.contentView.updateParentDecision(response.decision)
                }
            }
        }
    }

    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "AgeGatingKit Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )

        present(alert, animated: true)
    }
}
