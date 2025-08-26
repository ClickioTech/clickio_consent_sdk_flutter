import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import './clickio_consent_sdk_method_channel.dart';
import './enums/enums.dart';
import './configs/configs.dart';

abstract class ClickioConsentSdkPlatform extends PlatformInterface {
  ClickioConsentSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static ClickioConsentSdkPlatform _instance = MethodChannelClickioConsentSdk();

  /// The default instance of [ClickioConsentSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelClickioConsentSdk].
  static ClickioConsentSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ClickioConsentSdkPlatform] when
  /// they register themselves.
  static set instance(ClickioConsentSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> initialize({required Config config}) async {
    return _instance.initialize(config: config);
  }

  Future<void> setLogsMode({required LogsMode mode}) async {
    return _instance.setLogsMode(mode: mode);
  }

  Future<void> openDialog({
    required DialogMode mode,
    required bool attNeeded,
  }) async {
    return _instance.openDialog(mode: mode, attNeeded: attNeeded);
  }

  Widget webViewLoadUrl({
    required String url,
    required WebViewConfig webViewConfig,
  }) {
    final viewType = 'clickio_webview';
    final backgroundColor = webViewConfig.backgroundColor?.toARGB32();

    Widget webView =
        defaultTargetPlatform == TargetPlatform.android
            ? SizedBox(
              height: webViewConfig.height?.toDouble(),
              width: webViewConfig.width?.toDouble(),
              child: AndroidView(
                viewType: viewType,
                creationParams: {
                  'url': url,
                  'backgroundColor': backgroundColor,
                  'height': webViewConfig.height,
                  'width': webViewConfig.width,
                  'gravity': webViewConfig.gravity?.name,
                },
                creationParamsCodec: const StandardMessageCodec(),
              ),
            )
            : defaultTargetPlatform == TargetPlatform.iOS
            ? UiKitView(
              viewType: viewType,
              creationParams: {
                'url': url,
                'backgroundColor': backgroundColor,
                'height': webViewConfig.height,
                'width': webViewConfig.width,
                'gravity': webViewConfig.gravity?.name,
              },
              creationParamsCodec: const StandardMessageCodec(),
            )
            : const SizedBox.shrink();

    if (defaultTargetPlatform == TargetPlatform.android) {
      Alignment alignment;

      switch (webViewConfig.gravity) {
        case WebViewGravity.top:
          alignment = Alignment.topCenter;
          break;
        case WebViewGravity.bottom:
          alignment = Alignment.bottomCenter;
          break;
        case WebViewGravity.center:
        default:
          alignment = Alignment.center;
      }

      webView = Align(alignment: alignment, child: webView);
    }

    return webView;
  }

  Future<String?> getConsentScope() async {
    return _instance.getConsentScope();
  }

  Future<String?> getConsentState() async {
    return _instance.getConsentState();
  }

  Future<String?> getConsentForPurpose({required int purposeId}) async {
    return _instance.getConsentForPurpose(purposeId: purposeId);
  }

  Future<String?> getConsentForVendor({required int vendorId}) async {
    return _instance.getConsentForVendor(vendorId: vendorId);
  }

  Future<String?> getTCString() async {
    return _instance.getTCString();
  }

  Future<String?> getACString() async {
    return _instance.getACString();
  }

  Future<String?> getGPPString() async {
    return _instance.getGPPString();
  }

  Future<String?> getConsentedTCFVendors() async {
    return _instance.getConsentedTCFVendors();
  }

  Future<String?> getConsentedTCFLiVendors() async {
    return _instance.getConsentedTCFLiVendors();
  }

  Future<String?> getConsentedTCFPurposes() async {
    return _instance.getConsentedTCFPurposes();
  }

  Future<String?> getConsentedTCFLiPurposes() async {
    return _instance.getConsentedTCFLiPurposes();
  }

  Future<String?> getConsentedGoogleVendors() async {
    return _instance.getConsentedGoogleVendors();
  }

  Future<String?> getConsentedOtherVendors() async {
    return _instance.getConsentedOtherVendors();
  }

  Future<String?> getConsentedOtherLiVendors() async {
    return _instance.getConsentedOtherLiVendors();
  }

  Future<String?> getConsentedNonTcfPurposes() async {
    return _instance.getConsentedNonTcfPurposes();
  }

  Future<String?> getGoogleConsentMode() async {
    return _instance.getGoogleConsentMode();
  }
}
