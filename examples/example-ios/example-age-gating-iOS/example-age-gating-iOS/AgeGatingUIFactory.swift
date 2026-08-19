//
//  AgeGatingUIFactory.swift
//  example-age-gating-iOS
//
//  Created by Sriteja Thuraka on 8/19/26.
//

import UIKit

enum AgeGatingUIFactory {

    static func makeCard(
        accentColor: UIColor,
        icon: String,
        title: String,
        subtitle: String,
        step: String,
        content: [UIView]
    ) -> UIView {

        let card = UIView()
        card.backgroundColor = .secondarySystemGroupedBackground
        card.layer.cornerRadius = 18
        card.layer.borderWidth = 1
        card.layer.borderColor =
            accentColor.withAlphaComponent(0.20).cgColor

        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.07
        card.layer.shadowRadius = 10
        card.layer.shadowOffset = CGSize(width: 0, height: 4)

        let iconView = UIImageView(
            image: UIImage(systemName: icon)
        )

        iconView.tintColor = .white
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false

        let iconContainer = UIView()
        iconContainer.backgroundColor = accentColor
        iconContainer.layer.cornerRadius = 24
        iconContainer.translatesAutoresizingMaskIntoConstraints = false

        iconContainer.addSubview(iconView)

        NSLayoutConstraint.activate([
            iconContainer.widthAnchor.constraint(equalToConstant: 48),
            iconContainer.heightAnchor.constraint(equalToConstant: 48),

            iconView.centerXAnchor.constraint(
                equalTo: iconContainer.centerXAnchor
            ),

            iconView.centerYAnchor.constraint(
                equalTo: iconContainer.centerYAnchor
            ),

            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24)
        ])

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = accentColor

        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0

        let textStack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel
        ])

        textStack.axis = .vertical
        textStack.spacing = 4

        let badge = PaddingLabel()
        badge.text = step
        badge.font = .systemFont(ofSize: 12, weight: .semibold)
        badge.textColor = accentColor
        badge.backgroundColor =
            accentColor.withAlphaComponent(0.10)

        badge.layer.cornerRadius = 10
        badge.clipsToBounds = true
        badge.textAlignment = .center

        badge.edgeInsets = UIEdgeInsets(
            top: 5,
            left: 10,
            bottom: 5,
            right: 10
        )

        let header = UIStackView(arrangedSubviews: [
            iconContainer,
            textStack,
            UIView(),
            badge
        ])

        header.axis = .horizontal
        header.spacing = 12
        header.alignment = .top

        let stack = UIStackView(
            arrangedSubviews: [header] + content
        )

        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(
                equalTo: card.topAnchor,
                constant: 18
            ),
            stack.leadingAnchor.constraint(
                equalTo: card.leadingAnchor,
                constant: 18
            ),
            stack.trailingAnchor.constraint(
                equalTo: card.trailingAnchor,
                constant: -18
            ),
            stack.bottomAnchor.constraint(
                equalTo: card.bottomAnchor,
                constant: -18
            )
        ])

        return card
    }

    static func configurePrimaryButton(
        _ button: UIButton,
        title: String,
        systemImage: String,
        enabled: Bool
    ) {
        var configuration = UIButton.Configuration.filled()

        configuration.title = title
        configuration.image = UIImage(systemName: systemImage)
        configuration.imagePadding = 10
        configuration.cornerStyle = .large
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .systemBlue

        configuration.contentInsets =
            NSDirectionalEdgeInsets(
                top: 13,
                leading: 18,
                bottom: 13,
                trailing: 18
            )

        button.configuration = configuration
        button.isEnabled = enabled

        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(
                greaterThanOrEqualToConstant: 50
            )
        ])
    }

    static func setLoading(
        _ loading: Bool,
        on button: UIButton,
        title: String,
        systemImage: String
    ) {
        var configuration =
            button.configuration ??
            UIButton.Configuration.filled()

        if loading {
            configuration.title = "Please wait..."
            configuration.image = nil
            configuration.showsActivityIndicator = true
            button.isEnabled = false
        } else {
            configuration.title = title
            configuration.image =
                UIImage(systemName: systemImage)

            configuration.showsActivityIndicator = false
            button.isEnabled = true
        }

        button.configuration = configuration
    }

    static func makeStatusColumn(
        icon: String,
        title: String,
        valueLabel: UILabel
    ) -> UIView {

        let iconView = UIImageView(
            image: UIImage(systemName: icon)
        )

        iconView.tintColor = .systemBlue

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font =
            .systemFont(ofSize: 12, weight: .medium)

        titleLabel.textColor = .secondaryLabel

        valueLabel.font =
            .systemFont(ofSize: 14, weight: .semibold)

        valueLabel.textColor = .systemBlue
        valueLabel.numberOfLines = 0

        let textStack = UIStackView(arrangedSubviews: [
            titleLabel,
            valueLabel
        ])

        textStack.axis = .vertical
        textStack.spacing = 3

        let stack = UIStackView(arrangedSubviews: [
            iconView,
            textStack
        ])

        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center

        return stack
    }

    static func makeStatusRow(
        icon: String,
        title: String,
        valueLabel: UILabel,
        tintColor: UIColor
    ) -> UIView {

        let iconView = UIImageView(
            image: UIImage(systemName: icon)
        )

        iconView.tintColor = tintColor

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font =
            .systemFont(ofSize: 14, weight: .medium)

        valueLabel.font =
            .systemFont(ofSize: 14, weight: .semibold)

        valueLabel.textColor = .secondaryLabel
        valueLabel.textAlignment = .right

        let stack = UIStackView(arrangedSubviews: [
            iconView,
            titleLabel,
            UIView(),
            valueLabel
        ])

        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center

        return stack
    }

    static func makeDecisionRow(
        icon: String,
        title: String,
        valueLabel: UILabel
    ) -> UIView {

        let iconView = UIImageView(
            image: UIImage(systemName: icon)
        )

        iconView.tintColor = .secondaryLabel

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font =
            .systemFont(ofSize: 13, weight: .medium)

        valueLabel.font =
            .systemFont(ofSize: 14, weight: .semibold)

        valueLabel.textColor = .secondaryLabel

        let textStack = UIStackView(arrangedSubviews: [
            titleLabel,
            valueLabel
        ])

        textStack.axis = .vertical
        textStack.spacing = 3

        let stack = UIStackView(arrangedSubviews: [
            iconView,
            textStack,
            UIView()
        ])

        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center

        return stack
    }

    static func separator() -> UIView {
        let view = UIView()
        view.backgroundColor = .separator

        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(
                equalToConstant: 0.5
            )
        ])

        return view
    }
}
