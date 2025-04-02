import 'package:clickio_consent_sdk/dialog_mode.dart';
import 'clickio_consent_sdk_platform_interface.dart';

class ClickioConsentSdk {
  Future<String?> initialize({
    required String appId,
    String language = 'en',
  }) async {
    return ClickioConsentSdkPlatform.instance.initialize(
      appId: appId,
      language: language,
    );
  }

  Future<void> openDialog({DialogMode mode = DialogMode.defaultMode}) async {
    return ClickioConsentSdkPlatform.instance.openDialog(mode: mode);
  }

  Future<Map<String, String?>> getConsentData() async {
    return ClickioConsentSdkPlatform.instance.getConsentData();
  }
}
