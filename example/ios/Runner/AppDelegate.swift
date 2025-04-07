import AppTrackingTransparency
import ClickioConsentSDKManager
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
      name: "clickio_consent_sdk", binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { (call, result) in
      switch call.method {
      case "initialize":
        self.initializeConsentSDK(call: call, result: result)

      case "openDialog":
        self.openDialog(call: call, viewController: controller, result: result)

      case "getConsentScope":
        self.getConsentScope(result: result)

      case "getConsentState":
        self.getConsentState(result: result)

      case "getConsentForPurpose":
        self.getConsentForPurpose(call: call, result: result)

      case "getConsentForVendor":
        self.getConsentForVendor(call: call, result: result)

      case "getTCString":
        self.getTCString(result: result)

      case "getACString":
        self.getACString(result: result)

      case "getGPPString":
        self.getGPPString(result: result)

      case "getConsentedTCFVendors":
        self.getConsentedTCFVendors(result: result)

      case "getConsentedTCFLiVendors":
        self.getConsentedTCFLiVendors(result: result)

      case "getConsentedTCFPurposes":
        self.getConsentedTCFPurposes(result: result)

      case "getConsentedTCFLiPurposes":
        self.getConsentedTCFLiPurposes(result: result)

      case "getConsentedGoogleVendors":
        self.getConsentedGoogleVendors(result: result)

      case "getConsentedOtherVendors":
        self.getConsentedOtherVendors(result: result)

      case "getConsentedOtherLiVendors":
        self.getConsentedOtherLiVendors(result: result)

      case "getConsentedNonTcfPurposes":
        self.getConsentedNonTcfPurposes(result: result)

      case "getGoogleConsentMode":
        self.getGoogleConsentMode(result: result)

      default:
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Initialize ClickioConsentSDK
  private func initializeConsentSDK(call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any]
    let appId = args?["appId"] as? String ?? ""
    let language = args?["language"] as? String ?? "en"

    if appId.isEmpty {
      result(FlutterError(code: "MISSING_ARGUMENTS", message: "'appId' is required", details: nil))
      return
    }

    let config = ClickioConsentSDK.Config(siteId: appId, appLanguage: language)

    Task {
      do {
        await ClickioConsentSDK.shared.initialize(configuration: config)
        DispatchQueue.main.async {
          result("ClickioConsentSDK initialized successfully")
        }
      } catch {
        DispatchQueue.main.async {
          result(
            FlutterError(
              code: "INITIALIZATION_ERROR", message: "Failed to initialize ClickioConsentSDK",
              details: error.localizedDescription))
        }
      }
    }
  }

  // Open Consent Dialog
  private func openDialog(
    call: FlutterMethodCall, viewController: UIViewController, result: @escaping FlutterResult
  ) {
    let args = call.arguments as! [String: Any]
    let dialogMode = args["mode"] as! String
    let mode: ClickioConsentSDK.DialogMode = dialogMode == "resurfaceMode" ? .resurface : .default
    let showATTFirst = args["showATTFirst"] as! Bool
    let alwaysShowCMP = args["alwaysShowCMP"] as! Bool
    let attNeeded = args["attNeeded"] as! Bool

    DispatchQueue.main.async {
      do {
        ClickioConsentSDK.shared.openDialog(
          mode: mode,
          in: viewController,
          showATTFirst: showATTFirst,
          alwaysShowCMP: alwaysShowCMP,
          attNeeded: attNeeded
        )

        result("Consent Dialog Opened")
      } catch {
        result(
          FlutterError(
            code: "OPEN_DIALOG_ERROR",
            message: "Failed to open Clickio Consent dialog",
            details: error.localizedDescription
          )
        )
      }
    }
  }

  private func getConsentScope(result: FlutterResult) {
    result(ClickioConsentSDK.shared.checkConsentScope())
  }

  private func getConsentState(result: FlutterResult) {
    result(ClickioConsentSDK.shared.checkConsentState()?.rawValue)
  }

  private func getConsentForPurpose(call: FlutterMethodCall, result: FlutterResult) {
    if let args = call.arguments as? [String: Any],
      let purposeId = args["id"] as? Int
    {
      result(ClickioConsentSDK.shared.checkConsentForPurpose(purposeId: purposeId)?.description)
    } else {
      result(FlutterError(code: "ARGUMENT_ERROR", message: "Missing purposeId", details: nil))
    }
  }

  private func getConsentForVendor(call: FlutterMethodCall, result: FlutterResult) {
    if let args = call.arguments as? [String: Any],
      let vendorId = args["id"] as? Int
    {
      result(
        ClickioConsentSDK.shared.checkConsentForVendor(vendorId: vendorId)?.description
      )
    } else {
      result(FlutterError(code: "ARGUMENT_ERROR", message: "Missing vendorId", details: nil))
    }
  }

  private func getTCString(result: FlutterResult) {
    result(ExportData().getTCString())
  }

  private func getACString(result: FlutterResult) {
    result(ExportData().getACString())
  }

  private func getGPPString(result: FlutterResult) {
    result(ExportData().getGPPString())
  }

  private func getConsentedTCFVendors(result: FlutterResult) {
    result(ExportData().getConsentedTCFVendors()?.description)
  }

  private func getConsentedTCFLiVendors(result: FlutterResult) {
    result(ExportData().getConsentedTCFLiVendors()?.description)
  }

  private func getConsentedTCFPurposes(result: FlutterResult) {
    result(ExportData().getConsentedTCFPurposes()?.description)
  }

  private func getConsentedTCFLiPurposes(result: FlutterResult) {
    result(ExportData().getConsentedTCFLiPurposes()?.description)
  }

  private func getConsentedGoogleVendors(result: FlutterResult) {
    result(ExportData().getConsentedGoogleVendors()?.description)
  }

  private func getConsentedOtherVendors(result: FlutterResult) {
    result(ExportData().getConsentedOtherVendors()?.description)
  }

  private func getConsentedOtherLiVendors(result: FlutterResult) {
    result(ExportData().getConsentedOtherLiVendors()?.description)
  }

  private func getConsentedNonTcfPurposes(result: FlutterResult) {
    result(ExportData().getConsentedNonTcfPurposes()?.description)
  }

  private func getGoogleConsentMode(result: FlutterResult) {
    let googleConsent = ExportData().getGoogleConsentMode()
    let formatted =
      "Analytics Storage: \(googleConsent?.analyticsStorageGranted ?? false), "
      + "Ad Storage: \(googleConsent?.adStorageGranted ?? false), "
      + "Ad User Data: \(googleConsent?.adUserDataGranted ?? false), "
      + "Ad Personalization: \(googleConsent?.adPersonalizationGranted ?? false)"
    result(formatted)
  }

}
