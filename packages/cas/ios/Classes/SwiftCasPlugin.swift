import Flutter
import UIKit
import CleverAdsSolutions

public class SwiftCasPlugin: NSObject, FlutterPlugin {
    static var _channel: FlutterMethodChannel?

    private static let cleverAdsSolutions: CleverAdsSolutions = CleverAdsSolutions(
        rootViewController: UIApplication.shared.delegate!.window!!.rootViewController!
    )

    public static func register(with registrar: FlutterPluginRegistrar) {
        _channel = FlutterMethodChannel(name: "cas", binaryMessenger: registrar.messenger())
        let instance = SwiftCasPlugin()
        registrar.addMethodCallDelegate(instance, channel: _channel!)
        registrar.addApplicationDelegate(instance)
        _channel!.invokeMethod("test", arguments: [1,2])
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        var args: Dictionary<String, Any>;
        switch (call.method) {
        case "Initialize":
            args = call.arguments as! Dictionary<String, Any>
            SwiftCasPlugin.cleverAdsSolutions.initialize(
                managerID: args["managerID"] as! String,
                demoAdMode: (args["isTestBuild"] != nil) ? args["isTestBuild"] as! Bool : false,
                userID: args["userID"] as! String,
                onInit: { (_ success: Bool, _ error: String?) -> Void in
                    SwiftCasPlugin._channel!.invokeMethod("onInitializationListener", arguments: [success, error as Any])
                }
            )
        case "ShowInterstitialAd":
            args = call.arguments as! Dictionary<String, Any>
            SwiftCasPlugin.cleverAdsSolutions.showInterstitialAd(callback: AdContentDelegate(placement: args["placement"] as! String, channel: SwiftCasPlugin._channel!))
        case "ShowRewardedVideoAd":
            SwiftCasPlugin._channel?.invokeMethod("test2", arguments: [1,2])
            args = call.arguments as! Dictionary<String, Any>
            SwiftCasPlugin.cleverAdsSolutions.showRewardedVideoAd(callback: AdContentDelegate(placement: args["placement"] as! String, channel: SwiftCasPlugin._channel!))
            SwiftCasPlugin._channel?.invokeMethod("test3", arguments: [1,2])
        case "SetUserGdprConsent":
            args = call.arguments as! Dictionary<String, Any>
            SwiftCasPlugin.cleverAdsSolutions.setUserConsent(consent: args["consent"] as! Int)
        case "isAdReadyInterstitial": result(SwiftCasPlugin.cleverAdsSolutions.isAdReadyInterstitial())
        case "isAdReadyRewarded": result(SwiftCasPlugin.cleverAdsSolutions.isAdReadyRewarded())
        case "validateIntegration": SwiftCasPlugin.cleverAdsSolutions.validateIntegration()
            default: result(FlutterMethodNotImplemented)
        }
    }
}


class AdContentDelegate: CASCallback {
    let placement: String
    let channel: FlutterMethodChannel

    init(placement: String, channel: FlutterMethodChannel) {
        self.placement = placement
        self.channel = channel
    }

    func willShown(adStatus ad: CASImpression) {
        channel.invokeMethod("onShown", arguments: [placement, ad.adType.toPrefix(), ad.network, ad.priceAccuracy, ad.cpm, ad.status, ad.error, ad.versionInfo, ad.identifier])
    }

    func didShowAdFailed(error: String) {
        channel.invokeMethod("onShowFailed", arguments: [placement, error])
    }

    func didClickedAd() {
        channel.invokeMethod("onClicked", arguments: placement)
    }

    func didCompletedAd() {
        channel.invokeMethod("onComplete", arguments: placement)
    }

    func didClosedAd() {
        channel.invokeMethod("onClosed", arguments: placement)
    }
}
