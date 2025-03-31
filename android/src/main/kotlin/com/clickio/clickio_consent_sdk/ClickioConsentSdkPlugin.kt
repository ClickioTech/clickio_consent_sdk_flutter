package com.clickio.clickio_consent_sdk

import android.app.Activity
import android.content.Context
import com.clickio.clickioconsentsdk.ClickioConsentSDK
import com.clickio.clickioconsentsdk.ClickioConsentSDK.Config
import com.clickio.clickioconsentsdk.ExportData
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** ClickioConsentSdkPlugin */
class ClickioConsentSdkPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "clickio_consent_sdk")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initialize" -> {
                activity?.let { act ->
                    val appId = call.argument<String>("appId") ?: return@let result.error("INVALID_ARGUMENT", "appId is required", null)
                    val language = call.argument<String>("language") ?: return@let result.error("INVALID_ARGUMENT", "language is required", null)
                    val config = Config(appId, language)

                    ClickioConsentSDK.getInstance().initialize(act, config)

                    result.success("ClickioConsentSDK initialized")
                } ?: result.error("NO_ACTIVITY", "Activity is null", null)
            }
            "openDialog" -> {
                activity?.let { act ->
                    val modeString = call.argument<String>("mode") ?: "defaultMode"
                    val mode = when (modeString) {
                        "resurfaceMode" -> ClickioConsentSDK.DialogMode.RESURFACE
                        else -> ClickioConsentSDK.DialogMode.DEFAULT
                    }

                    ClickioConsentSDK.getInstance().openDialog(act, mode)

                    result.success("Consent Dialog opened")
                } ?: result.error("NO_ACTIVITY", "Activity is null", null)
            }
            "getConsentData" -> {
                activity?.let { act ->

                    val consentData = loadConsentData(act)

                    result.success(consentData)
                }  ?: result.error("NO_ACTIVITY", "Activity is null", null)
            }
            else -> result.notImplemented()
        }
    }

    private fun loadConsentData(context: Context): Map<String, String?> {
        val consentSDK = ClickioConsentSDK.getInstance()
        val exportData = ExportData(context)

        return mapOf(
            "checkConsentScope" to consentSDK.checkConsentScope().toString(),
            "checkConsentState" to consentSDK.checkConsentState().toString(),
            "checkConsentForPurpose(1)" to consentSDK.checkConsentForPurpose(1).toString(),
            "checkConsentForVendor(9)" to consentSDK.checkConsentForVendor(9).toString(),
            "getTCString" to exportData.getTCString(),
            "getACString" to exportData.getACString(),
            "getGPPString" to exportData.getGPPString().toString(),
            "getGoogleConsentMode" to exportData.getGoogleConsentMode().toString(),
            "getConsentedTCFVendors" to exportData.getConsentedTCFVendors().toString(),
            "getConsentedTCFLiVendors" to exportData.getConsentedTCFLiVendors().toString(),
            "getConsentedTCFPurposes" to exportData.getConsentedTCFPurposes().toString(),
            "getConsentedTCFLiPurposes" to exportData.getConsentedTCFLiPurposes().toString(),
            "getConsentedGoogleVendors" to exportData.getConsentedGoogleVendors().toString(),
            "getConsentedOtherVendors" to exportData.getConsentedOtherVendors().toString(),
            "getConsentedOtherLiVendors" to exportData.getConsentedOtherLiVendors().toString(),
            "getConsentedNonTcfPurposes" to exportData.getConsentedNonTcfPurposes().toString()
        )
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}

