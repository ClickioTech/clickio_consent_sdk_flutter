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
        self.initializeConsentSDK(result: result)

      case "openDialog":
        self.openDialog(viewController: controller, result: result)

      case "getConsentData":
        self.getConsentData(result: result)

      default:
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Initialize ClickioConsentSDK
  private func initializeConsentSDK(result: @escaping FlutterResult) {
    let config = ClickioConsentSDK.Config(siteId: "241131", appLanguage: "en")

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
              code: "INITIALIZATIONч_ERROR", message: "Failed to initialize ClickioConsentSDK",
              details: error.localizedDescription))
        }
      }
    }
  }

  func requestATTIfNeeded(completion: @escaping () -> Void) {
    if #available(iOS 14, *) {
      ATTrackingManager.requestTrackingAuthorization { status in
        DispatchQueue.main.async {
          completion()
        }
      }
    } else {
      completion()
    }
  }

  // Open Consent Dialog
  private func openDialog(viewController: UIViewController, result: @escaping FlutterResult) {
    DispatchQueue.main.async {
      do {
        ClickioConsentSDK.shared.openDialog(
          mode: .resurface,
          in: viewController,
          showATTFirst: false,
          alwaysShowCMP: true,
          attNeeded: true
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

  // Get Consent Data
  private func getConsentData(result: @escaping FlutterResult) {
    let exportData = ExportData()

    let googleConsentMode = exportData.getGoogleConsentMode()
    let googleConsentString =
      "Analytics Storage: \(googleConsentMode?.analyticsStorageGranted ?? false), Ad Storage: \(googleConsentMode?.adStorageGranted ?? false), Ad User Data: \(googleConsentMode?.adUserDataGranted ?? false), Ad Personalization: \(googleConsentMode?.adPersonalizationGranted ?? false)"

    let consentData: [String: Any] = [
      "checkConsentScope": ClickioConsentSDK.shared.checkConsentScope() ?? "Unknown",
      "checkConsentState": ClickioConsentSDK.shared.checkConsentState()?.rawValue ?? "Unknown",
      "checkConsentForPurpose(1)": ClickioConsentSDK.shared.checkConsentForPurpose(purposeId: 1)?
        .description ?? "Unknown",
      "checkConsentForVendor(9)": ClickioConsentSDK.shared.checkConsentForVendor(vendorId: 9)?
        .description ?? "Unknown",
      "getTCString": exportData.getTCString() ?? "Unknown",
      "getACString": exportData.getACString() ?? "Unknown",
      "getGPPString": exportData.getGPPString() ?? "Unknown",
      "getConsentedTCFVendors": exportData.getConsentedTCFVendors()?.description ?? "Unknown",
      "getConsentedTCFLiVendors": exportData.getConsentedTCFLiVendors()?.description ?? "Unknown",
      "getConsentedTCFPurposes": exportData.getConsentedTCFPurposes()?.description ?? "Unknown",
      "getConsentedTCFLiPurposes": exportData.getConsentedTCFLiPurposes()?.description ?? "Unknown",
      "getConsentedGoogleVendors": exportData.getConsentedGoogleVendors()?.description ?? "Unknown",
      "getConsentedOtherVendors": exportData.getConsentedOtherVendors()?.description ?? "Unknown",
      "getConsentedOtherLiVendors": exportData.getConsentedOtherLiVendors()?.description
        ?? "Unknown",
      "getConsentedNonTcfPurposes": exportData.getConsentedNonTcfPurposes()?.description
        ?? "Unknown",
      "getGoogleConsentMode": googleConsentString,
    ]

    DispatchQueue.main.async {
      result(consentData)
    }

  }
}
