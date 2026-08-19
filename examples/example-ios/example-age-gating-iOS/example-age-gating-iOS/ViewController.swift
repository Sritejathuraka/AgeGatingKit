//
//  ViewController.swift
//  example-age-gating-iOS
//
//  Created by Sriteja Thuraka on 8/18/26.
//

import UIKit
import AgeGatingKit

class ViewController: UIViewController {
    
    // MARK: UI

    private let checkAgeButton = UIButton()
    private let eligibilityLabel = UILabel()
    private let ageRangeLabel = UILabel()

    private let declaredAgeLabel = UILabel()
    private let parentalConsentLabel = UILabel()
    private let adultNotificationLabel = UILabel()

    private let parentalConsentButton = UIButton()
    private let parentDecisionLabel = UILabel()
    private let adultNotificationButton = UIButton()

    private let adultNotificationStatusLabel = UILabel()
    
    private var ageGatingResult: AgeGatingResult?
    private var responseTask: Task<Void, Never>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        // Start listening for parental responses.
        observeParentalConsentResponses()
    }
    
    deinit {
            responseTask?.cancel()
        }
    
    // MARK: - Setup
    private func setupUI() {

        view.backgroundColor = .systemBackground
        title = "AgeGatingKit Example"

        // MARK: Configure labels

        eligibilityLabel.text = "Eligibility: Not Checked"
        ageRangeLabel.text = "Age Range: --"

        declaredAgeLabel.text = "Declared Age Range Required: --"
        parentalConsentLabel.text = "Parental Consent Required: --"
        adultNotificationLabel.text = "Adult Notification Required: --"

        parentDecisionLabel.text = "Parent Decision: --"
        adultNotificationStatusLabel.text = "Adult Notification: --"

        let labels = [
            eligibilityLabel,
            ageRangeLabel,
            declaredAgeLabel,
            parentalConsentLabel,
            adultNotificationLabel,
            parentDecisionLabel,
            adultNotificationStatusLabel
        ]

        labels.forEach {
            $0.numberOfLines = 0
            $0.font = .systemFont(ofSize: 16)
        }

        // MARK: Check Age Button

        var checkConfig = UIButton.Configuration.filled()
        checkConfig.title = "Check Age Verification"

        checkAgeButton.configuration = checkConfig

        checkAgeButton.addTarget(
            self,
            action: #selector(checkAgeOnTapped),
            for: .touchUpInside
        )

        // MARK: Parent Consent Button

        var parentConfig = UIButton.Configuration.filled()
        parentConfig.title = "Request Parental Consent"

        parentalConsentButton.configuration = parentConfig
        parentalConsentButton.isEnabled = false

        parentalConsentButton.addTarget(
            self,
            action: #selector(parentalConsentTapped),
            for: .touchUpInside
        )

        // MARK: Adult Notification Button

        var adultConfig = UIButton.Configuration.filled()
        adultConfig.title = "Show Adult Notification"

        adultNotificationButton.configuration = adultConfig
        adultNotificationButton.isEnabled = false

        adultNotificationButton.addTarget(
            self,
            action: #selector(adultNotificationTapped),
            for: .touchUpInside
        )

        // MARK: Section 1 - Age Verification

        let ageSection = UIStackView(arrangedSubviews: [
            sectionTitle("1. Age Verification"),
            checkAgeButton,
            eligibilityLabel,
            ageRangeLabel
        ])

        ageSection.axis = .vertical
        ageSection.spacing = 12

        // MARK: Section 2 - Regulatory Features

        let regulatorySection = UIStackView(arrangedSubviews: [
            sectionTitle("2. Regulatory Features"),
            declaredAgeLabel,
            parentalConsentLabel,
            adultNotificationLabel
        ])

        regulatorySection.axis = .vertical
        regulatorySection.spacing = 10

        // MARK: Section 3 - Parental Consent

        let parentalSection = UIStackView(arrangedSubviews: [
            sectionTitle("3. Parental Consent"),
            parentalConsentButton,
            parentDecisionLabel
        ])

        parentalSection.axis = .vertical
        parentalSection.spacing = 12

        // MARK: Section 4 - Adult Notification

        let adultSection = UIStackView(arrangedSubviews: [
            sectionTitle("4. Adult Notification"),
            adultNotificationButton,
            adultNotificationStatusLabel
        ])

        adultSection.axis = .vertical
        adultSection.spacing = 12

        // MARK: Main Stack

        let mainStack = UIStackView(arrangedSubviews: [
            ageSection,
            separator(),
            regulatorySection,
            separator(),
            parentalSection,
            separator(),
            adultSection
        ])

        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 24
            ),

            mainStack.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -24
            ),

            mainStack.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 24
            )
        ])
    }
    
    @objc
    private func checkAgeOnTapped() {

        Task {
            do {
                let ageGating = try await AgeGating.check(
                    ageGates: [13, 16, 18],
                    presentingViewController: self
                )

                // 1. Eligibility
                if ageGating.isEligibleForAgeFearures == true {
                    eligibilityLabel.text = "Eligibility: ✅ Eligible"
                } else {
                    eligibilityLabel.text = "Eligibility: ❌ Not Eligible"

                    ageRangeLabel.text = "Age Range: Not Available"
                    parentalConsentButton.isEnabled = false
                    adultNotificationButton.isEnabled = false
                    return
                }

                // 2. Age Range
                if let ageRange = ageGating.ageRange {

                    let lower = ageRange.lowerBound
                    let upper = ageRange.upperBound

                    ageRangeLabel.text =
                        "Age Range: \(lower) - \(upper)"

                } else {
                    ageRangeLabel.text = "Age Range: Not Available"
                }

                // 3. Regulatory Features
                if let features = ageGating.regulatoryFeatures {

                    declaredAgeLabel.text =
                        "Declared Age Range Required: \(features.declaredAgeRangeRequired)"

                    parentalConsentLabel.text =
                        "Parental Consent Required: \(features.significantAppChangeRequiresParentalConsent)"

                    adultNotificationLabel.text =
                        "Adult Notification Required: \(features.significantAppChangeRequiresAdultNotification)"

                    // Enable buttons only when Apple says they are required
                    parentalConsentButton.isEnabled =
                        features.significantAppChangeRequiresParentalConsent

                    adultNotificationButton.isEnabled =
                        features.significantAppChangeRequiresAdultNotification

                    // Initial states
                    if features.significantAppChangeRequiresParentalConsent {
                        parentDecisionLabel.text =
                            "Parent Decision: Not Requested"
                    } else {
                        parentDecisionLabel.text =
                            "Parent Decision: Not Required"
                    }

                    if features.significantAppChangeRequiresAdultNotification {
                        adultNotificationStatusLabel.text =
                            "Adult Notification: Not Shown"
                    } else {
                        adultNotificationStatusLabel.text =
                            "Adult Notification: Not Required"
                    }

                } else {

                    declaredAgeLabel.text =
                        "Declared Age Range Required: --"

                    parentalConsentLabel.text =
                        "Parental Consent Required: --"

                    adultNotificationLabel.text =
                        "Adult Notification Required: --"

                    parentalConsentButton.isEnabled = false
                    adultNotificationButton.isEnabled = false
                }

            } catch {

                eligibilityLabel.text = "Eligibility: Error"
                showError(error)
            }
        }
    }
    
    @objc
    private func parentalConsentTapped() {
        
        // Parent consent required
        Task {
            do {
                parentDecisionLabel.text = "Parent Decision: Waiting..."

                try await AgeGating.requestSignificatntAppUpdatePermission(
                    description: "Parental consent required for changes in the latest release.",
                    presentingViewController: self
                )

            } catch {
                parentDecisionLabel.text =
                    "Parent Decision: Error"
                showError(error)
            }
        }
    }
    
    @objc
    private func adultNotificationTapped() {
        
        // Adult notification required
        Task {
            do {
                try await AgeGating.showSignificantAppUpdateAdultNotification (
                    decription: "Please review changes in the latest release.",
                    presentingViewController: self
                )
                adultNotificationStatusLabel.text =
                    "Adult Notification: Completed"
            } catch {
                adultNotificationStatusLabel.text =
                    "Adult Notification: Error"

                showError(error)
            }
        }
    }
    
    
    private func observeParentalConsentResponses() {

        responseTask?.cancel()

        responseTask = Task { [weak self] in

            guard let self else { return }

            for await response in AgeGating.significantAppUpdateResponses() {

                guard !Task.isCancelled else {
                    break
                }

                print("AGE GATING RESPONSE: \(response)")

                await MainActor.run {

                    switch response.decision {

                    case .approved:
                        self.parentDecisionLabel.text =
                            "Parent Decision: Approved"

                        self.parentalConsentButton.isEnabled = false

                        print("UI UPDATED → Parent Decision: Approved")

                    case .denied:
                        self.parentDecisionLabel.text =
                            "Parent Decision: Denied"

                        print("UI UPDATED → Parent Decision: Denied")

                    case .unknown:
                        self.parentDecisionLabel.text =
                            "Parent Decision: Unknown"

                        print("UI UPDATED → Parent Decision: Unknown")

                    @unknown default:
                        self.parentDecisionLabel.text =
                            "Parent Decision: Unrecognized"
                    }

                    // Force layout refresh for debugging
                    self.parentDecisionLabel.setNeedsLayout()
                    self.parentDecisionLabel.superview?.layoutIfNeeded()
                }
            }
        }
    }
    
    
    
    // MARK: - Error

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
    
    // MARK: - UI Helper

       private func separator() -> UIView {

           let view = UIView()
           view.backgroundColor = .separator
           NSLayoutConstraint.activate([
               view.heightAnchor.constraint(equalToConstant: 1)
           ])
           return view
       }
    
    private func sectionTitle(_ text: String) -> UILabel {

        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        
        return label

    }


}

