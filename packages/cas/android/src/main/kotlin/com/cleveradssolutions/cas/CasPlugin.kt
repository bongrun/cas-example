package com.cleveradssolutions.cas

import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import com.cleversolutions.ads.*
import com.cleversolutions.ads.android.CAS

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** CasPlugin */
class CasPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var cleverAdsSolutions: CleverAdsSolutions
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        flutterPluginBinding
                .platformViewRegistry
                .registerViewFactory("<cas-banner-view>", BannerViewFactory())
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "cas")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        try {
            when (call.method) {
                "Initialize" -> cleverAdsSolutions.initialize(
                        appPackage = call.argument<String>("appPackage")!!,
                        isTestBuild = call.argument<Boolean>("isTestBuild") ?: true,
                        userID = call.argument<String>("userID"),
                        onInitializationListener = OnInitializationListener { success, error ->
                            channel.invokeMethod("onInitializationListener", listOf(success, error))
                        },
                        logger = { eventName: String ->
                            channel.invokeMethod("logger", eventName)
                        }
                )
                "ShowInterstitialAd" -> cleverAdsSolutions.showInterstitialAd(object : AdCallback {
                    override fun onShown(ad: AdStatusHandler) {
                        channel.invokeMethod("onShown", listOf(call.argument<String>("placement")!!, ad.adType.toPrefix(), ad.network, ad.priceAccuracy, ad.cpm, ad.status, ad.error, ad.versionInfo, ad.identifier))
                    }

                    override fun onShowFailed(message: String) {
                        channel.invokeMethod("onShowFailed", listOf(call.argument<String>("placement")!!, message))
                    }

                    override fun onClicked() {
                        channel.invokeMethod("onClicked", call.argument<String>("placement")!!)
                    }

                    override fun onComplete() {
                        channel.invokeMethod("onComplete", call.argument<String>("placement")!!)
                    }

                    override fun onClosed() {
                        channel.invokeMethod("onClosed", call.argument<String>("placement")!!)
                    }
                })
                "ShowRewardedVideoAd" -> cleverAdsSolutions.showRewardedVideoAd(object : AdCallback {
                    override fun onShown(ad: AdStatusHandler) {
                        channel.invokeMethod("onShown", listOf(call.argument<String>("placement")!!, ad.adType.toPrefix(), ad.network, ad.priceAccuracy, ad.cpm, ad.status, ad.error, ad.versionInfo, ad.identifier))
                    }

                    override fun onShowFailed(message: String) {
                        channel.invokeMethod("onShowFailed", listOf(call.argument<String>("placement")!!, message))
                    }

                    override fun onClicked() {
                        channel.invokeMethod("onClicked", call.argument<String>("placement")!!)
                    }

                    override fun onComplete() {
                        channel.invokeMethod("onComplete", call.argument<String>("placement")!!)
                    }

                    override fun onClosed() {
                        channel.invokeMethod("onClosed", call.argument<String>("placement")!!)
                    }
                })
                "SetUserGdprConsent" -> cleverAdsSolutions.setUserConsent(call.argument<Int>("consent")!!)
                "isAdReadyInterstitial" -> return result.success(cleverAdsSolutions.isAdReadyInterstitial())
                "isAdReadyRewarded" -> return result.success(cleverAdsSolutions.isAdReadyRewarded())
                "validateIntegration" -> cleverAdsSolutions.validateIntegration()
                else -> return result.notImplemented()
            }
            return result.success(null)
        } catch (exception: Exception) {
            result.error(null, exception.message, null)
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        cleverAdsSolutions = CleverAdsSolutions(activity = binding.activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        cleverAdsSolutions = CleverAdsSolutions(activity = binding.activity)
    }

    override fun onDetachedFromActivity() {}
}
