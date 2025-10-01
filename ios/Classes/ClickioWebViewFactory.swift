import ClickioConsentSDKManager
import Flutter
import UIKit
import WebKit

public class ClickioWebViewFactory: NSObject, FlutterPlatformViewFactory {
    private var lastWebView: WKWebView?
    private let channel: FlutterMethodChannel

    public init(messenger: FlutterBinaryMessenger) {
        self.channel = FlutterMethodChannel(name: "clickio_webview", binaryMessenger: messenger)
        super.init()
    }

    public func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        let params = args as? [String: Any] ?? [:]

        guard let urlString = params["url"] as? String,
              URL(string: urlString) != nil,
              !urlString.isEmpty else {
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

        let height = (params["height"] as? Int).map { CGFloat($0) }
        let width = (params["width"] as? Int).map { CGFloat($0) }

        let gravity: WebViewGravity = {
            switch (params["gravity"] as? String)?.lowercased() {
            case "top": return .top
            case "bottom": return .bottom
            default: return .center
            }
        }()

        let webViewConfig = WebViewConfig(
            backgroundColor: backgroundColor,
            width: width,
            height: height,
            gravity: gravity
        )

        let controller = ClickioConsentSDK.shared.webViewLoadUrl(
            urlString: urlString,
            config: webViewConfig
        )

        if let wkWebView = controller.view as? WKWebView {
            self.lastWebView = wkWebView
        }

        return ClickioWebViewWrapper(webView: controller.view)
    }

    public func getLastWebView() -> WKWebView? {
        return lastWebView
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

public class ClickioWebViewWrapper: NSObject, FlutterPlatformView {
    private let webView: UIView

    init(webView: UIView) {
        self.webView = webView
    }

    public func view() -> UIView {
        return webView
    }
}

class ClickioWebViewCloseHandler: NSObject, WKScriptMessageHandler {
    private let channel: FlutterMethodChannel

    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "clickioClose" {
            channel.invokeMethod("webViewCloseRequest", arguments: nil)
        }
    }
}
