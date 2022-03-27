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

    public func willShown(ad adStatus: CASStatusHandler) {
        print("onShown")
        channel.invokeMethod("onShown", arguments: [placement!, adStatus.adType.toPrefix(), adStatus.network, adStatus.priceAccuracy.rawValue, adStatus.cpm, adStatus.status, adStatus.error, adStatus.versionInfo, adStatus.identifier])
    }

    public func didShowAdFailed(error: String) {
        print("onShowFailed")
        channel.invokeMethod("onShowFailed", arguments: [placement!, error])
    }

    public func didClickedAd() {
        print("onClicked")
        channel.invokeMethod("onClicked", arguments: placement!)
    }

    public func didCompletedAd() {
        print("onComplete")
        channel.invokeMethod("onComplete", arguments: placement!)
    }

    public func didClosedAd() {
        print("onClosed")
        channel.invokeMethod("onClosed", arguments: placement!)
    }
}
