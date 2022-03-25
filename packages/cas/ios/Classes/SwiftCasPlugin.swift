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
                },
                channel: SwiftCasPlugin._channel!
            )
        case "ShowInterstitialAd":
            args = call.arguments as! Dictionary<String, Any>
            let adContentDelegate = AdContentDelegate(placement: args["placement"] as! String, channel: SwiftCasPlugin._channel!)
            SwiftCasPlugin.cleverAdsSolutions.showInterstitialAd(callback: adContentDelegate)
        case "ShowRewardedVideoAd":
            print("111")
            args = call.arguments as! Dictionary<String, Any>
            print("222")
            print("333")
            print("444")
            SwiftCasPlugin.cleverAdsSolutions.showRewardedVideoAd()
            print("555")
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
