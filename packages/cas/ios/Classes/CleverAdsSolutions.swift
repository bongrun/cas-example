import Foundation
import CleverAdsSolutions

public class CleverAdsSolutions {
    private var rootViewController: UIViewController
    private var manager: CASMediationManager?
    private var delegateReward: AdContentDelegate?
    
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
        delegateReward = AdContentDelegate(placement: "test", channel: channel)
    }

    public func setUserConsent(consent: Int) {
        CAS.settings.updateUser(consent: CASConsentStatus(rawValue: consent)!)
    }

    public func showInterstitialAd(callback: AdContentDelegate) {
        manager?.presentInterstitial(fromRootViewController: rootViewController, callback: callback)
    }

    public func showRewardedVideoAd() {
        print("444 111")
        print(delegateReward == nil ? "null" : "not null")
        manager?.presentRewardedAd(fromRootViewController: rootViewController, callback: delegateReward)
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
