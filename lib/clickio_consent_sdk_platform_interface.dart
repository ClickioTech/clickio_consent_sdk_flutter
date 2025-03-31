import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'clickio_consent_sdk_method_channel.dart';
import 'dialog_mode.dart';

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

  Future<String?> initialize({
    required String appId,
    required String language,
  }) async {
    return _instance.initialize(appId: appId, language: language);
  }

  Future<void> openDialog({required DialogMode mode}) async {
    return _instance.openDialog(mode: mode);
  }

  Future<Map<String, String?>> getConsentData() async {
    return _instance.getConsentData();
  }
}
