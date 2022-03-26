import CleverAdsSolutions

public class AdContentDelegate: CASCallback {
    var placement: String?
    let channel: FlutterMethodChannel

    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }

    public func setPlacement(placement: String) {
        self.placement = placement
    }

    public func willShown(adStatus ad: CASImpression) {
        channel.invokeMethod("onShown", arguments: [placement!, ad.adType.toPrefix(), ad.network, ad.priceAccuracy, ad.cpm, ad.status, ad.error, ad.versionInfo, ad.identifier])
    }

    public func didShowAdFailed(error: String) {
        channel.invokeMethod("onShowFailed", arguments: [placement!, error])
    }

    public func didClickedAd() {
        channel.invokeMethod("onClicked", arguments: placement!)
    }

    public func didCompletedAd() {
        channel.invokeMethod("onComplete", arguments: placement!)
    }

    public func didClosedAd() {
        channel.invokeMethod("onClosed", arguments: placement!)
    }
}
