package com.cleveradssolutions.cas

import android.R.attr.tag
import android.app.Activity
import android.os.Bundle
import android.util.Log
import android.view.ViewGroup
import android.widget.Toast
import com.cleversolutions.ads.*
import com.cleversolutions.ads.PriceAccuracy
import com.cleversolutions.ads.android.CAS
import com.cleversolutions.ads.android.CASBannerView
import com.cleversolutions.basement.CASAnalytics


class CleverAdsSolutions(activity: Activity) {
    private val activity: Activity = activity
    private lateinit var manager: MediationManager

    init {
        CAS.settings.debugMode = false
        CAS.settings.taggedAudience = Audience.NOT_CHILDREN
        CAS.settings.analyticsCollectionEnabled = true;
        CAS.settings.allowInterstitialAdsWhenVideoCostAreLower = true;
        CAS.settings.userConsent = ConsentStatus.ACCEPTED;
    }

    fun initialize(
            appPackage: String,
            isTestBuild: Boolean = true,
            userID: String? = null,
            onInitializationListener: OnInitializationListener? = null,
            logger: (eventName: String) -> Unit
    ) {
        var buildManager = CAS.buildManager()
                .withManagerId(appPackage)
                .withTestAdMode(isTestBuild)
                .withAdTypes(AdType.Interstitial, AdType.Rewarded)
        if (userID != null) {
            buildManager.withUserID(userID)
        }
        if (onInitializationListener != null) {
            buildManager.withInitListener(onInitializationListener)
        }
        manager = buildManager.initialize(activity)

    }

    fun setUserConsent(consent: Int) {
        CAS.settings.userConsent = consent
    }

    fun showInterstitialAd(callback: AdCallback?) {
        manager.showInterstitial(activity, callback)
    }

    fun showRewardedVideoAd(callback: AdCallback?) {
        manager.showRewardedAd(activity, callback);
    }

    fun isAdReadyInterstitial(): Boolean {
        return manager.isAdReady(AdType.Interstitial);
    }

    fun isAdReadyRewarded(): Boolean {
        return manager.isAdReady(AdType.Rewarded);
    }

    fun validateIntegration() {
        CAS.validateIntegration(activity)
    }
}
