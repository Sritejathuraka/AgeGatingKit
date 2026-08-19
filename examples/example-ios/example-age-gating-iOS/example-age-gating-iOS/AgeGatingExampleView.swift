//
//  AgeGatingExampleView.swift
//  example-age-gating-iOS
//
//  Created by Sriteja Thuraka on 8/18/26.
//

import UIKit
import AgeGatingKit

final class AgeGatingExampleView: UIView {

    let checkAgeButton = UIButton()
    let eligibilityLabel = UILabel()
    let ageRangeLabel = UILabel()

    let declaredAgeLabel = UILabel()
    let parentalConsentLabel = UILabel()
    let adultNotificationLabel = UILabel()

    let parentalConsentButton = UIButton()
    let parentDecisionLabel = UILabel()

    let adultNotificationButton = UIButton()
    let adultNotificationStatusLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemGroupedBackground
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @MainActor
    func update(with result: AgeGatingResult) {

        eligibilityLabel.text =
            result.isEligibleForAgeFearures == true ? "Eligible" : "Not Eligible"

        if let range = result.ageRange {
            if let lower = range.lowerBound,
               let upper = range.upperBound {
                ageRangeLabel.text = "\(lower) - \(upper)"
            } else if let lower = range.lowerBound {
                ageRangeLabel.text = "\(lower)+"
            } else if let upper = range.upperBound {
                ageRangeLabel.text = "Under \(upper + 1)"
            } else {
                ageRangeLabel.text = "--"
            }
        } else {
            ageRangeLabel.text = "--"
        }

        guard let features = result.regulatoryFeatures else {
            declaredAgeLabel.text = "--"
            parentalConsentLabel.text = "--"
            adultNotificationLabel.text = "--"

            parentalConsentButton.isEnabled = false
            adultNotificationButton.isEnabled = false

            return
        }

        declaredAgeLabel.text =
            features.declaredAgeRangeRequired ? "True" : "False"

        parentalConsentLabel.text =
            features.significantAppChangeRequiresParentalConsent
            ? "True"
            : "False"

        adultNotificationLabel.text =
            features.significantAppChangeRequiresAdultNotification
            ? "True"
            : "False"

        parentalConsentButton.isEnabled =
            features.significantAppChangeRequiresParentalConsent

        adultNotificationButton.isEnabled =
            features.significantAppChangeRequiresAdultNotification

        parentDecisionLabel.text =
            features.significantAppChangeRequiresParentalConsent
            ? "Not Requested"
            : "Not Required"

        adultNotificationStatusLabel.text =
            features.significantAppChangeRequiresAdultNotification
            ? "Not Shown"
            : "Not Required"
    }

    @MainActor
    func updateParentDecision(
        _ decision: SignificantChangeDecision
    ) {
        switch decision {
        case .approved:
            parentDecisionLabel.text = "Approved"
            parentalConsentButton.isEnabled = false

        case .denied:
            parentDecisionLabel.text = "Denied"
            parentalConsentButton.isEnabled = true

        case .unknown:
            parentDecisionLabel.text = "Unknown"
            parentalConsentButton.isEnabled = true

        @unknown default:
            parentDecisionLabel.text = "Unrecognized"
        }
    }

    @MainActor
    func setCheckAgeLoading(_ loading: Bool) {
        AgeGatingUIFactory.setLoading(
            loading,
            on: checkAgeButton,
            title: "Check Age Verification",
            systemImage: "magnifyingglass"
        )
    }

    @MainActor
    func setParentalConsentLoading(_ loading: Bool) {
        AgeGatingUIFactory.setLoading(
            loading,
            on: parentalConsentButton,
            title: "Request Parental Consent",
            systemImage: "shield"
        )
    }

    @MainActor
    func setAdultNotificationLoading(_ loading: Bool) {
        AgeGatingUIFactory.setLoading(
            loading,
            on: adultNotificationButton,
            title: "Show Adult Notification",
            systemImage: "bell"
        )
    }

    @MainActor
    func showEligibilityError() {
        eligibilityLabel.text = "Error"
    }

    private func setupUI() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        let header = makeHeader()
        let ageCard = makeAgeCard()
        let regulatoryCard = makeRegulatoryCard()
        let parentalCard = makeParentalCard()
        let adultCard = makeAdultCard()
        let infoBanner = makeInfoBanner()
        let footer = makeFooter()

        let mainStack = UIStackView(arrangedSubviews: [
            header,
            ageCard,
            regulatoryCard,
            parentalCard,
            adultCard,
            infoBanner,
            footer
        ])

        mainStack.axis = .vertical
        mainStack.spacing = 18
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 24
            ),

            mainStack.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 20
            ),

            mainStack.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -20
            ),

            mainStack.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -32
            )
        ])
    }

    private func makeHeader() -> UIView {
        let title = UILabel()
        title.text = "AgeGatingKit Example"
        title.font = .systemFont(ofSize: 28, weight: .bold)
        title.textAlignment = .center

        let subtitle = UILabel()
        subtitle.text =
            "Demonstrates Apple Age & Parental Consent APIs"

        subtitle.font = .systemFont(ofSize: 15)
        subtitle.textColor = .secondaryLabel
        subtitle.textAlignment = .center
        subtitle.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [
            title,
            subtitle
        ])

        stack.axis = .vertical
        stack.spacing = 6

        return stack
    }

    private func makeAgeCard() -> UIView {
        AgeGatingUIFactory.configurePrimaryButton(
            checkAgeButton,
            title: "Check Age Verification",
            systemImage: "magnifyingglass",
            enabled: true
        )

        eligibilityLabel.text = "Not Checked"
        ageRangeLabel.text = "--"

        let status = UIStackView(arrangedSubviews: [
            AgeGatingUIFactory.makeStatusColumn(
                icon: "",
                title: "Eligibility",
                valueLabel: eligibilityLabel
            ),
            AgeGatingUIFactory.makeStatusColumn(
                icon: "",
                title: "Age Range",
                valueLabel: ageRangeLabel
            )
        ])

        status.axis = .horizontal
        status.distribution = .fillEqually
        status.spacing = 12

        return AgeGatingUIFactory.makeCard(
            accentColor: .systemBlue,
            icon: "checkmark.shield.fill",
            title: "1. Age Verification",
            subtitle:
                "Check if age features are available for the current user.",
            step: "Step 1",
            content: [
                checkAgeButton,
                AgeGatingUIFactory.separator(),
                status
            ]
        )
    }

    private func makeRegulatoryCard() -> UIView {
        declaredAgeLabel.text = "--"
        parentalConsentLabel.text = "--"
        adultNotificationLabel.text = "--"

        let container = UIStackView(arrangedSubviews: [
            AgeGatingUIFactory.makeStatusRow(
                icon: "checkmark.circle",
                title: "Declared Age Range Required",
                valueLabel: declaredAgeLabel,
                tintColor: .systemGreen
            ),

            AgeGatingUIFactory.separator(),

            AgeGatingUIFactory.makeStatusRow(
                icon: "checkmark.circle",
                title: "Parental Consent Required",
                valueLabel: parentalConsentLabel,
                tintColor: .systemGreen
            ),

            AgeGatingUIFactory.separator(),

            AgeGatingUIFactory.makeStatusRow(
                icon: "checkmark.circle",
                title: "Adult Notification Required",
                valueLabel: adultNotificationLabel,
                tintColor: .systemGreen
            )
        ])

        container.axis = .vertical
        container.spacing = 10
        container.isLayoutMarginsRelativeArrangement = true

        container.layoutMargins = UIEdgeInsets(
            top: 14,
            left: 14,
            bottom: 14,
            right: 14
        )

        container.backgroundColor =
            UIColor.systemGreen.withAlphaComponent(0.08)

        container.layer.cornerRadius = 14

        return AgeGatingUIFactory.makeCard(
            accentColor: .systemGreen,
            icon: "scale.3d",
            title: "2. Regulatory Features",
            subtitle:
                "Features required based on the user's age and region.",
            step: "Step 2",
            content: [container]
        )
    }

    private func makeParentalCard() -> UIView {
        AgeGatingUIFactory.configurePrimaryButton(
            parentalConsentButton,
            title: "Request Parental Consent",
            systemImage: "shield",
            enabled: false
        )

        parentDecisionLabel.text = "Not Requested"

        return AgeGatingUIFactory.makeCard(
            accentColor: .systemPurple,
            icon: "figure.and.child.holdinghands",
            title: "3. Parental Consent",
            subtitle:
                "Request permission from a parent for significant app changes.",
            step: "Step 3",
            content: [
                parentalConsentButton,
                AgeGatingUIFactory.separator(),
                AgeGatingUIFactory.makeDecisionRow(
                    icon: "clock",
                    title: "Parent Decision",
                    valueLabel: parentDecisionLabel
                )
            ]
        )
    }

    private func makeAdultCard() -> UIView {
        AgeGatingUIFactory.configurePrimaryButton(
            adultNotificationButton,
            title: "Show Adult Notification",
            systemImage: "bell",
            enabled: false
        )

        adultNotificationStatusLabel.text = "Not Required"

        return AgeGatingUIFactory.makeCard(
            accentColor: .systemOrange,
            icon: "bell.fill",
            title: "4. Adult Notification",
            subtitle:
                "Notify the adult about significant changes in the app.",
            step: "Step 4",
            content: [
                adultNotificationButton,
                AgeGatingUIFactory.separator(),
                AgeGatingUIFactory.makeDecisionRow(
                    icon: "exclamationmark.circle",
                    title: "Adult Notification",
                    valueLabel: adultNotificationStatusLabel
                )
            ]
        )
    }

    private func makeInfoBanner() -> UIView {
        let label = UILabel()
        label.text =
            "Check age → Review features → Request parental consent if needed → Show adult notification if needed"

        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [
            UIImageView(image: UIImage(systemName: "lightbulb.fill")),
            label
        ])

        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .top
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(
            top: 14,
            left: 16,
            bottom: 14,
            right: 16
        )

        stack.backgroundColor =
            UIColor.systemBlue.withAlphaComponent(0.08)

        stack.layer.cornerRadius = 14

        return stack
    }

    private func makeFooter() -> UIView {
        let label = UILabel()
        label.text = "Powered by AgeGatingKit"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [
            UIImageView(
                image: UIImage(
                    systemName:
                        "chevron.left.forwardslash.chevron.right"
                )
            ),
            label
        ])

        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center

        return stack
    }
}
