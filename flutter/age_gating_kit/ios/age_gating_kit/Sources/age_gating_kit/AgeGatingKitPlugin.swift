import Flutter
import UIKit
import AgeGatingKit
import DeclaredAgeRange
import PermissionKit

public class AgeGatingKitPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "age_gating_kit",
            binaryMessenger: registrar.messenger()
        )

        let instance = AgeGatingKitPlugin()

        registrar.addMethodCallDelegate(
            instance,
            channel: channel
        )
    }

    public func handle(
        _ call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        switch call.method {

        case "checkAge":
            checkAge(result: result)

        case "requestParentalConsent":
            let arguments = call.arguments as? [String: Any]

            let description =
                arguments?["description"] as? String
                ?? "This app has introduced significant changes."

            requestParentalConsent(
                description: description,
                result: result
            )

        case "showAdultNotification":
            let arguments = call.arguments as? [String: Any]

            let description =
                arguments?["description"] as? String
                ?? "This app has introduced significant changes."

            showAdultNotification(
                description: description,
                result: result
            )

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Check Age
private func checkAge(
    result: @escaping FlutterResult
) {
    Task {
        do {
            let viewController =
                try await MainActor.run {
                    try getViewController()
                }

            let nativeResult = try await AgeGating.check(
                ageGates: [13, 16, 18],
                presentingViewController: viewController
            )

            // keep the rest of your existing code here

                let lowerBound =
                    nativeResult.ageRange?.lowerBound

                let upperBound =
                    nativeResult.ageRange?.upperBound

                let ageRange: String?

                if let lowerBound {
                    if let upperBound {
                        ageRange = "\(lowerBound)-\(upperBound)"
                    } else {
                        ageRange = "\(lowerBound)+"
                    }
                } else {
                    ageRange = nil
                }

                var requiredRegulatoryFeatures: [String] = []

                if nativeResult
                    .regulatoryFeatures?
                    .declaredAgeRangeRequired == true {

                    requiredRegulatoryFeatures.append(
                        "declaredAgeRangeRequired"
                    )
                }

                if nativeResult
                    .regulatoryFeatures?
                    .significantAppChangeRequiresParentalConsent == true {

                    requiredRegulatoryFeatures.append(
                        "significantAppChangeRequiresParentalConsent"
                    )
                }

                if nativeResult
                    .regulatoryFeatures?
                    .significantAppChangeRequiresAdultNotification == true {

                    requiredRegulatoryFeatures.append(
                        "significantAppChangeRequiresAdultNotification"
                    )
                }

                let response: [String: Any] = [
                    "isEligibleForAgeFeatures":
                        nativeResult.isEligibleForAgeFearures ?? false,

                    "ageRange":
                        ageRange ?? NSNull(),

                    "requiredRegulatoryFeatures":
                        requiredRegulatoryFeatures
                ]

                await MainActor.run {
                    result(response)
                }

            } catch {
                await MainActor.run {
                    result(
                        FlutterError(
                            code: "AGE_GATING_ERROR",
                            message: error.localizedDescription,
                            details: String(describing: error)
                        )
                    )
                }
            }
        }
    }

    // MARK: - Parental Consent

    private func requestParentalConsent(
        description: String,
        result: @escaping FlutterResult
    ) {
        guard #available(iOS 26.2, *) else {
            result(
                FlutterError(
                    code: "UNSUPPORTED_IOS_VERSION",
                    message:
                        "Parental consent requires iOS 26.2 or later.",
                    details: nil
                )
            )
            return
        }

        Task { @MainActor in
            do {
                guard let viewController =
                        Self.topViewController()
                else {
                    result(
                        FlutterError(
                            code: "NO_VIEW_CONTROLLER",
                            message:
                                "Unable to find active UIViewController.",
                            details: nil
                        )
                    )
                    return
                }

                let topic =
                    SignificantAppUpdateTopic(
                        description: description
                    )

                let question =
                    PermissionQuestion(
                        significantAppUpdateTopic: topic
                    )

                try await AskCenter.shared.ask(
                    question,
                    in: viewController
                )

                result([
                    "status": "pending",
                    "message":
                        "Parental consent request was sent."
                ])

            } catch {
                result(
                    FlutterError(
                        code: "PARENTAL_CONSENT_ERROR",
                        message: error.localizedDescription,
                        details: String(describing: error)
                    )
                )
            }
        }
    }

    // MARK: - Adult Notification

    private func showAdultNotification(
        description: String,
        result: @escaping FlutterResult
    ) {
        guard #available(iOS 26.4, *) else {
            result(
                FlutterError(
                    code: "UNSUPPORTED_IOS_VERSION",
                    message:
                        "Adult significant-update notification requires iOS 26.4 or later.",
                    details: nil
                )
            )
            return
        }

        Task { @MainActor in
            do {
                guard let windowScene =
                        Self.activeWindowScene()
                else {
                    result(
                        FlutterError(
                            code: "NO_WINDOW_SCENE",
                            message:
                                "Unable to find active UIWindowScene.",
                            details: nil
                        )
                    )
                    return
                }

                let features =
                    try await AgeRangeService.shared
                        .requiredRegulatoryFeatures

                guard features.contains(
                    .significantAppChangeRequiresAdultNotification
                ) else {

                    result([
                        "status": "notRequired",
                        "message":
                            "Adult notification is not required."
                    ])

                    return
                }

                try await AgeRangeService.shared
                    .showSignificantUpdateAcknowledgment(
                        in: windowScene,
                        updateDescription: description
                    )

                result([
                    "status": "acknowledged",
                    "message":
                        "Adult significant-update notification was acknowledged."
                ])

            } catch {
                result(
                    FlutterError(
                        code: "ADULT_NOTIFICATION_ERROR",
                        message: error.localizedDescription,
                        details: String(describing: error)
                    )
                )
            }
        }
    }

    // MARK: - Helpers

  @MainActor
private func getViewController() throws -> UIViewController {
    guard let viewController = Self.topViewController() else {
        throw NSError(
            domain: "AgeGatingKit",
            code: 1,
            userInfo: [
                NSLocalizedDescriptionKey:
                    "Unable to find active UIViewController."
            ]
        )
    }

    return viewController
}

    @MainActor
    private static func activeWindowScene()
        -> UIWindowScene? {

        UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first {
                $0.activationState == .foregroundActive
            }
    }

    @MainActor
    private static func topViewController()
        -> UIViewController? {

        guard let windowScene =
                activeWindowScene()
        else {
            return nil
        }

        guard let root =
                windowScene.windows
                    .first(where: { $0.isKeyWindow })?
                    .rootViewController
        else {
            return nil
        }

        return topViewController(from: root)
    }

    @MainActor
    private static func topViewController(
        from viewController: UIViewController
    ) -> UIViewController {

        if let presented =
                viewController.presentedViewController {

            return topViewController(
                from: presented
            )
        }

        if let navigation =
                viewController as? UINavigationController,
           let visible =
                navigation.visibleViewController {

            return topViewController(
                from: visible
            )
        }

        if let tab =
                viewController as? UITabBarController,
           let selected =
                tab.selectedViewController {

            return topViewController(
                from: selected
            )
        }

        return viewController
    }
}