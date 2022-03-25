import CleverAdsSolutions

public class AdContentDelegate: CASCallback {
    let placement: String
    let channel: FlutterMethodChannel

    init(placement: String, channel: FlutterMethodChannel) {
        print("INIT 111")
        self.placement = placement
        self.channel = channel
        print("INIT 222")
    }

    public func willShown(adStatus ad: CASImpression) {
        print("TEST TEST")
        channel.invokeMethod("onShown", arguments: [placement, ad.adType.toPrefix(), ad.network, ad.priceAccuracy, ad.cpm, ad.status, ad.error, ad.versionInfo, ad.identifier])
    }

    public func didShowAdFailed(error: String) {
        print("TEST TEST")
        channel.invokeMethod("onShowFailed", arguments: [placement, error])
    }

    public func didClickedAd() {
        print("TEST TEST")
        channel.invokeMethod("onClicked", arguments: placement)
    }

    public func didCompletedAd() {
        print("TEST TEST")
        channel.invokeMethod("onComplete", arguments: placement)
    }

    public func didClosedAd() {
        print("TEST TEST")
        channel.invokeMethod("onClosed", arguments: placement)
    }
}
