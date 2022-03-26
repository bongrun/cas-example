package com.cleveradssolutions.cas

import android.content.Context
import android.view.View
import com.cleversolutions.ads.AdPosition
import com.cleversolutions.ads.AdSize
import com.cleversolutions.ads.android.CASBannerView
import io.flutter.plugin.platform.PlatformView

internal class BannerView(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
    private val bannerView: CASBannerView = CASBannerView(context)

    override fun getView(): View {
        return bannerView
    }

    override fun dispose() {}

    init {
        bannerView.size = AdSize.BANNER
        bannerView.position = AdPosition.BottomCenter
    }

}