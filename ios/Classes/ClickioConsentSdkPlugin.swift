import ClickioConsentSDKManager
import Flutter
import UIKit

class ClickioWebViewFactory: NSObject, FlutterPlatformViewFactory {
  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    let params = args as? [String: Any] ?? [:]
      
    guard let urlString = params["url"] as? String, URL(string: urlString) != nil,
      !urlString.isEmpty
    else {
      print("ClickioWebViewFactory: invalid URL, returning empty view")

      return ClickioWebViewWrapper(webView: UIView())  
    }

    let backgroundColorValue = params["backgroundColor"] as? NSNumber ?? 0xFFFF_FFFF
    let backgroundColor = UIColor(
      red: CGFloat((backgroundColorValue.intValue >> 16) & 0xFF) / 255.0,
      green: CGFloat((backgroundColorValue.intValue >> 8) & 0xFF) / 255.0,
      blue: CGFloat(backgroundColorValue.intValue & 0xFF) / 255.0,
      alpha: CGFloat((backgroundColorValue.intValue >> 24) & 0xFF) / 255.0
    )

    let height: CGFloat? = {
        if let heightValue = params["height"] as? Int {
            return CGFloat(heightValue)
        }

        return nil
    }()

    let width: CGFloat? = {
        if let widthValue = params["width"] as? Int {
            return CGFloat(widthValue)
        }
        
        return nil
    }()

    let gravity: WebViewGravity = {
    if let gravityString = params["gravity"] as? String {
        switch gravityString.lowercased() {
        case "top":
            return .top
        case "center":
            return .center
        case "bottom":
            return .bottom
        default:
            return .center
        }
    }
    return .center
    }()

    let webViewConfig = WebViewConfig(
      backgroundColor: backgroundColor,
      width: width,
      height: height,
      gravity: gravity
    )

    let webViewController = ClickioConsentSDK.shared.webViewLoadUrl(
      urlString: urlString,
      config: webViewConfig
    )

    return ClickioWebViewWrapper(webView: webViewController.view)
  }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

class ClickioWebViewWrapper: NSObject, FlutterPlatformView {
  private let webView: UIView

  init(webView: UIView) {
    self.webView = webView
  }

  func view() -> UIView {
    return webView
  }
}

public class ClickioConsentSdkPlugin: NSObject, FlutterPlugin {
  private var channel: FlutterMethodChannel?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let methodChannel = FlutterMethodChannel(
      name: "clickio_consent_sdk",
      binaryMessenger: registrar.messenger()
    )

    let factory = ClickioWebViewFactory()
    registrar.register(factory, withId: "clickio_webview")

    let instance = ClickioConsentSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: methodChannel)

    ClickioConsentSDK.shared.onReady {
      methodChannel.invokeMethod("onReady", arguments: nil)
    }

    ClickioConsentSDK.shared.onConsentUpdated {
      methodChannel.invokeMethod("onConsentUpdate", arguments: nil)
    }
  }

  @MainActor
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initialize":
      self.initializeConsentSDK(call: call, result: result)
    case "setLogsMode":
      self.setLogsMode(call, result: result)
    case "openDialog":
      guard
        let controller = UIApplication.shared.windows.first(where: \.isKeyWindow)?
          .rootViewController
      else {
        result(
          FlutterError(
            code: "NO_VIEW_CONTROLLER",
            message: "Root view controller not found",
            details: nil))
        return
      }
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
      print("Unsupported method: \(call.method)")
      result(FlutterMethodNotImplemented)
    }
  }

  private func initializeConsentSDK(call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any]
    let siteId = args?["siteId"] as? String ?? ""
    let language = args?["language"] as? String ?? "en"

    if siteId.isEmpty {
      result(FlutterError(code: "MISSING_ARGUMENTS", message: "'siteId' is required", details: nil))
      return
    }

    let config = ClickioConsentSDK.Config(siteId: siteId, appLanguage: language)

    Task {
      do {
        await ClickioConsentSDK.shared.initialize(configuration: config)
        result("ClickioConsentSDK initialized successfully")
      }
    }
  }

  @MainActor
  private func setLogsMode(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
      let logMode = args["mode"] as? String
    else {
      return result(
        FlutterError(
          code: "INVALID_ARGUMENTS",
          message: "Missing or invalid arguments for setLogsMode",
          details: nil))
    }

    let mode: EventLogger.Mode

    switch logMode {
    case "verbose":
      mode = .verbose
    case "disabled":
      mode = .disabled
    default:
      return result(
        FlutterError(
          code: "INVALID_MODE",
          message: "Invalid logging mode: \(logMode)",
          details: nil))
    }

    ClickioConsentSDK.shared.setLogsMode(mode)

    result(nil)
  }

  @MainActor
  private func openDialog(
    call: FlutterMethodCall, viewController: UIViewController, result: @escaping FlutterResult
  ) {
    guard let args = call.arguments as? [String: Any],
      let dialogMode = args["mode"] as? String,
      let attNeeded = args["attNeeded"] as? Bool
    else {
      return result(
        FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid dialog parameters", details: nil))
    }

    let mode: ClickioConsentSDK.DialogMode = dialogMode == "resurface" ? .resurface : .default

    DispatchQueue.main.async {
      do {
        ClickioConsentSDK.shared.openDialog(
          mode: mode,
          in: viewController,
          attNeeded: attNeeded
        )

        result("Consent Dialog Opened")
      }
    }
  }

  @MainActor
  private func getConsentScope(result: FlutterResult) {
    result(ClickioConsentSDK.shared.checkConsentScope())
  }

  @MainActor
  private func getConsentState(result: FlutterResult) {
    if let consentState = ClickioConsentSDK.shared.checkConsentState() {
      result(consentState.rawValue)
    } else {
      result(
        FlutterError(
          code: "CONSENT_STATE_ERROR",
          message: "Failed to retrieve consent state",
          details: nil
        ))
    }
  }

  @MainActor
  private func getConsentForPurpose(call: FlutterMethodCall, result: FlutterResult) {
    guard let args = call.arguments as? [String: Any],
      let purposeId = args["id"] as? Int
    else {
      result(FlutterError(code: "ARGUMENT_ERROR", message: "Missing purposeId", details: nil))
      return
    }

    result(ClickioConsentSDK.shared.checkConsentForPurpose(purposeId: purposeId)?.description)
  }

  @MainActor
  private func getConsentForVendor(call: FlutterMethodCall, result: FlutterResult) {
    guard let args = call.arguments as? [String: Any],
      let vendorId = args["id"] as? Int
    else {
      result(FlutterError(code: "ARGUMENT_ERROR", message: "Missing vendorId", details: nil))
      return
    }

    result(ClickioConsentSDK.shared.checkConsentForVendor(vendorId: vendorId)?.description)
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
    let formatted = """
      Analytics Storage: \(googleConsent?.analyticsStorageGranted ?? false),
      Ad Storage: \(googleConsent?.adStorageGranted ?? false),
      Ad User Data: \(googleConsent?.adUserDataGranted ?? false),
      Ad Personalization: \(googleConsent?.adPersonalizationGranted ?? false)
      """

    result(formatted)
  }
}
