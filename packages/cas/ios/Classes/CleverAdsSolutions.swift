import Foundation
import CleverAdsSolutions

public class CleverAdsSolutions {
    private var rootViewController: UIViewController
    private var manager: CASMediationManager?
    private var delegate: AdContentDelegate?

    init(rootViewController: UIViewController?) {
        self.rootViewController = rootViewController.unsafelyUnwrapped
        CAS.settings.setDebugMode(false)
        CAS.settings.setTagged(audience: CASAudience.notChildren)
        CAS.settings.setAnalyticsCollection(enabled: true)
        CAS.settings.setInterstitialAdsWhenVideoCostAreLower(allow: true)
        CAS.settings.updateUser(consent: CASConsentStatus.accepted)
        CAS.settings.updateCCPA(status: CASCCPAStatus.optInSale)
    }

    public func initialize(
            managerID: String,
            demoAdMode: Bool = false,
            userID: String = "",
            onInit: CASInitializationCompletionHandler? = nil,
            channel: FlutterMethodChannel
    ) {
        manager = CAS.create(
                managerID: managerID,
                enableTypes: [CASTypeFlags.interstitial, CASTypeFlags.rewarded],
                demoAdMode: demoAdMode,
                userID: userID,
                onInit: onInit
        )
        delegate = AdContentDelegate(channel: channel)
    }

    public func setUserConsent(consent: Int) {
        CAS.settings.updateUser(consent: CASConsentStatus(rawValue: consent)!)
    }

    public func showInterstitialAd(placement: String) {
        delegate!.setPlacement(placement: placement)
        manager?.presentInterstitial(fromRootViewController: rootViewController, callback: delegate)
    }

    public func showRewardedVideoAd(placement: String) {
        delegate!.setPlacement(placement: placement)
        manager?.presentRewardedAd(fromRootViewController: rootViewController, callback: delegate)
    }

    public func isAdReadyInterstitial() -> Bool {
        return manager?.isAdReady(type: CASType.interstitial) ?? false
    }

    public func isAdReadyRewarded() -> Bool {
        return manager?.isAdReady(type: CASType.rewarded) ?? false
    }

    public func validateIntegration() {
        return CAS.validateIntegration()
    }
}
