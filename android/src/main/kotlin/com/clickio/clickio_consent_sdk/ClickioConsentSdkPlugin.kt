package com.clickio.clickio_consent_sdk

import android.app.Activity
import com.clickio.clickioconsentsdk.ClickioConsentSDK
import com.clickio.clickioconsentsdk.ClickioConsentSDK.Config
import com.clickio.clickioconsentsdk.LogsMode
import com.clickio.clickioconsentsdk.ExportData
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class ClickioConsentSdkPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "clickio_consent_sdk")
        channel.setMethodCallHandler(this)
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
        val act = activity ?: return result.error("NO_ACTIVITY", "Activity is null", null)
        val siteId: String = call.argument<String>("siteId") ?: return result.error("INVALID_ARGUMENT", "siteId is required", null)
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
        val act = activity ?: return result.error("NO_ACTIVITY", "Activity is null", null)
        val mode = when (call.argument<String>("mode")) {
            "resurface" -> ClickioConsentSDK.DialogMode.RESURFACE
            else -> ClickioConsentSDK.DialogMode.DEFAULT
        }

        ClickioConsentSDK.getInstance().openDialog(act, mode)
    }

    private fun getConsentScope(result: Result) {
        result.success(ClickioConsentSDK.getInstance().checkConsentScope().toString())
    }

    private fun getConsentState(result: Result) {
        result.success(ClickioConsentSDK.getInstance().checkConsentState().toString())
    }

    private fun getConsentForPurpose(call: MethodCall, result: Result) {
        val id = call.argument<Int>("id") ?: 1
        result.success(ClickioConsentSDK.getInstance().checkConsentForPurpose(id).toString())
    }

    private fun getConsentForVendor(call: MethodCall, result: Result) {
        val id = call.argument<Int>("id") ?: 9
        result.success(ClickioConsentSDK.getInstance().checkConsentForVendor(id).toString())
    }

    private fun getTCString(result: Result) {
        result.success(ExportData(activity!!).getTCString())
    }

    private fun getACString(result: Result) {
        result.success(ExportData(activity!!).getACString())
    }

    private fun getGPPString(result: Result) {
        result.success(ExportData(activity!!).getGPPString().toString())
    }

    private fun getGoogleConsentMode(result: Result) {
        result.success(ExportData(activity!!).getGoogleConsentMode().toString())
    }

    private fun getConsentedTCFVendors(result: Result) {
        result.success(ExportData(activity!!).getConsentedTCFVendors().toString())
    }

    private fun getConsentedTCFLiVendors(result: Result) {
        result.success(ExportData(activity!!).getConsentedTCFLiVendors().toString())
    }

    private fun getConsentedTCFPurposes(result: Result) {
        result.success(ExportData(activity!!).getConsentedTCFPurposes().toString())
    }

    private fun getConsentedTCFLiPurposes(result: Result) {
        result.success(ExportData(activity!!).getConsentedTCFLiPurposes().toString())
    }

    private fun getConsentedGoogleVendors(result: Result) {
        result.success(ExportData(activity!!).getConsentedGoogleVendors().toString())
    }

    private fun getConsentedOtherVendors(result: Result) {
        result.success(ExportData(activity!!).getConsentedOtherVendors().toString())
    }

    private fun getConsentedOtherLiVendors(result: Result) {
        result.success(ExportData(activity!!).getConsentedOtherLiVendors().toString())
    }

    private fun getConsentedNonTcfPurposes(result: Result) {
        result.success(ExportData(activity!!).getConsentedNonTcfPurposes().toString())
    }

    // --- Activity Lifecycle Hooks ---

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
