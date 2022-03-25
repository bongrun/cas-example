import Foundation
import CleverAdsSolutions

public class CleverAdsSolutions {
    private var rootViewController: UIViewController
    private var manager: CASMediationManager?

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
            onInit: CASInitializationCompletionHandler? = nil
    ) {
        manager = CAS.create(
                managerID: managerID,
                enableTypes: [CASTypeFlags.interstitial, CASTypeFlags.rewarded],
                demoAdMode: demoAdMode,
                userID: userID,
                onInit: onInit
        )
    }

    public func setUserConsent(consent: Int) {
        CAS.settings.updateUser(consent: CASConsentStatus(rawValue: consent)!)
    }

    public func showInterstitialAd(callback: AdContentDelegate) {
        manager?.presentInterstitial(fromRootViewController: rootViewController, callback: callback)
    }

    public func showRewardedVideoAd(callback: AdContentDelegate) {
        print("444 111")
        print(callback == nil ? "null" : "not null")
        manager?.presentRewardedAd(fromRootViewController: rootViewController, callback: callback)
        print("444 222")
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
