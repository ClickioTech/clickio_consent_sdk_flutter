package com.clickio.clickio_consent_sdk

import android.content.Context
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.FragmentActivity
import com.clickio.clickioconsentsdk.ClickioConsentSDK
import com.clickio.clickioconsentsdk.ClickioConsentSDK.Config
import com.clickio.clickioconsentsdk.WebViewConfig
import com.clickio.clickioconsentsdk.WebViewGravity
import com.clickio.clickioconsentsdk.LogsMode
import com.clickio.clickioconsentsdk.ExportData
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import android.util.Log
import java.util.Locale

class ClickioWebViewFactory(
    private val fragmentActivity: FragmentActivity
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val params = args as? Map<String, Any?> ?: emptyMap()

        val url = params["url"] as? String ?: ""
        val backgroundColor = (params["backgroundColor"] as? Number)?.toInt() ?: 0
        val height = params["height"] as? Int ?: -1
        val width = params["width"] as? Int ?: -1        
        val gravity: WebViewGravity = (params["gravity"] as? String)?.let {
            runCatching { WebViewGravity.valueOf(it.uppercase(Locale.ROOT)) }.getOrNull()
        } ?: WebViewGravity.CENTER

        val webViewConfig = WebViewConfig(
            backgroundColor = backgroundColor,
            height = height,
            width = width,
            gravity = gravity
        )

        val webView = ClickioConsentSDK.getInstance().webViewLoadUrl(
            fragmentActivity,
            url,
            webViewConfig
        )

        return object : PlatformView {
            override fun getView(): View = webView
            override fun dispose() {}
        }
    }
}

class ClickioConsentSdkPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var fragmentActivity: FragmentActivity? = null
    private var pluginBinding: FlutterPlugin.FlutterPluginBinding? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        pluginBinding = binding
        channel = MethodChannel(binding.binaryMessenger, "clickio_consent_sdk")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        pluginBinding = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        val act = binding.activity
        if (act is FragmentActivity) {
            fragmentActivity = act

            // Register the PlatformViewFactory now that we have the FragmentActivity
            pluginBinding?.platformViewRegistry?.registerViewFactory(
                "clickio_webview",
                ClickioWebViewFactory(act)
            )
        } else {
            throw IllegalStateException("Activity must be a FragmentActivity")
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        fragmentActivity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        fragmentActivity = null
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initialize" -> initialize(call, result)
            "setLogsMode" -> setLogsMode(call, result)
            "openDialog" -> openDialog(call, result)
            "getConsentScope" -> getConsentScope(result)
            "getConsentState" -> getConsentState(result)
            "getConsentForPurpose" -> getConsentForPurpose(call, result)
            "getConsentForVendor" -> getConsentForVendor(call, result)
            "getTCString" -> getTCString(result)
            "getACString" -> getACString(result)
            "getGPPString" -> getGPPString(result)
            "getConsentedTCFVendors" -> getConsentedTCFVendors(result)
            "getConsentedTCFLiVendors" -> getConsentedTCFLiVendors(result)
            "getConsentedTCFPurposes" -> getConsentedTCFPurposes(result)
            "getConsentedTCFLiPurposes" -> getConsentedTCFLiPurposes(result)
            "getConsentedGoogleVendors" -> getConsentedGoogleVendors(result)
            "getConsentedOtherVendors" -> getConsentedOtherVendors(result)
            "getConsentedOtherLiVendors" -> getConsentedOtherLiVendors(result)
            "getConsentedNonTcfPurposes" -> getConsentedNonTcfPurposes(result)
            "getGoogleConsentMode" -> getGoogleConsentMode(result)
            else -> result.notImplemented()
        }
    }

    private fun initialize(call: MethodCall, result: Result) {
        val act = fragmentActivity ?: return result.error("NO_ACTIVITY", "FragmentActivity is null", null)
        val siteId: String = call.argument<String>("siteId")
            ?: return result.error("INVALID_ARGUMENT", "siteId is required", null)
        val language = call.argument<String>("language") ?: "en"
        val config = Config(siteId, language)

        val clickioConsentSdk = ClickioConsentSDK.getInstance()
        clickioConsentSdk.initialize(act, config)

        clickioConsentSdk.onReady {
            channel.invokeMethod("onReady", null)
        }

        clickioConsentSdk.onConsentUpdated {
            channel.invokeMethod("onConsentUpdate", null)
        }

        result.success(null)
    }

    private fun setLogsMode(call: MethodCall, result: Result) {
        val mode = when (call.argument<String>("mode")) {
            "verbose" -> LogsMode.VERBOSE
            else -> LogsMode.DISABLED
        }
        ClickioConsentSDK.getInstance().setLogsMode(mode)
        result.success(null)
    }

    private fun openDialog(call: MethodCall, result: Result) {
        val act = fragmentActivity ?: return result.error("NO_ACTIVITY", "FragmentActivity is null", null)
        val mode = when (call.argument<String>("mode")) {
            "resurface" -> ClickioConsentSDK.DialogMode.RESURFACE
            else -> ClickioConsentSDK.DialogMode.DEFAULT
        }
        ClickioConsentSDK.getInstance().openDialog(act, mode)
        result.success(null)
    }

    private fun getConsentScope(result: Result) = result.success(ClickioConsentSDK.getInstance().checkConsentScope().toString())
   
    private fun getConsentState(result: Result) = result.success(ClickioConsentSDK.getInstance().checkConsentState().toString())
   
    private fun getConsentForPurpose(call: MethodCall, result: Result) {
        val id = call.argument<Int>("id") ?: 1
        result.success(ClickioConsentSDK.getInstance().checkConsentForPurpose(id).toString())
    }
   
    private fun getConsentForVendor(call: MethodCall, result: Result) {
        val id = call.argument<Int>("id") ?: 9
        result.success(ClickioConsentSDK.getInstance().checkConsentForVendor(id).toString())
    }
   
    private fun getTCString(result: Result) { result.success(ExportData(fragmentActivity!!).getTCString()) }
   
    private fun getACString(result: Result) { result.success(ExportData(fragmentActivity!!).getACString()) }
   
    private fun getGPPString(result: Result) { result.success(ExportData(fragmentActivity!!).getGPPString().toString()) }
   
    private fun getGoogleConsentMode(result: Result) { result.success(ExportData(fragmentActivity!!).getGoogleConsentMode().toString()) }
   
    private fun getConsentedTCFVendors(result: Result) { result.success(ExportData(fragmentActivity!!).getConsentedTCFVendors().toString()) }
   
    private fun getConsentedTCFLiVendors(result: Result) { result.success(ExportData(fragmentActivity!!).getConsentedTCFLiVendors().toString()) }
   
    private fun getConsentedTCFPurposes(result: Result) { result.success(ExportData(fragmentActivity!!).getConsentedTCFPurposes().toString()) }
   
    private fun getConsentedTCFLiPurposes(result: Result) { result.success(ExportData(fragmentActivity!!).getConsentedTCFLiPurposes().toString()) }
   
    private fun getConsentedGoogleVendors(result: Result) { result.success(ExportData(fragmentActivity!!).getConsentedGoogleVendors().toString()) }
   
    private fun getConsentedOtherVendors(result: Result) { result.success(ExportData(fragmentActivity!!).getConsentedOtherVendors().toString()) }
   
    private fun getConsentedOtherLiVendors(result: Result) { result.success(ExportData(fragmentActivity!!).getConsentedOtherLiVendors().toString()) }
   
    private fun getConsentedNonTcfPurposes(result: Result) { result.success(ExportData(fragmentActivity!!).getConsentedNonTcfPurposes().toString()) }
}
