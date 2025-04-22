import './clickio_consent_sdk_platform_interface.dart';
import './config/config.dart';
import './enums/enums.dart';

export './config/config.dart';
export './enums/enums.dart';

class ClickioConsentSdk {
  Future<String?> initialize({required Config config}) async {
    return ClickioConsentSdkPlatform.instance.initialize(config: config);
  }

  Future<void> setLogsMode({required LogsMode mode}) async {
    return ClickioConsentSdkPlatform.instance.setLogsMode(mode: mode);
  }

  Future<void> onConsentUpdated() async {
    return ClickioConsentSdkPlatform.instance.onConsentUpdated();
  }

  Future<void> openDialog({
    DialogMode mode = DialogMode.defaultMode,
    bool showATTFirst = false,
    bool attNeeded = false,
  }) async {
    return ClickioConsentSdkPlatform.instance.openDialog(
      mode: mode,
      showATTFirst: showATTFirst,
      attNeeded: attNeeded,
    );
  }

  Future<String?> getConsentScope() async {
    return ClickioConsentSdkPlatform.instance.getConsentScope();
  }

  Future<String?> getConsentState() async {
    return ClickioConsentSdkPlatform.instance.getConsentState();
  }

  Future<String?> getConsentForPurpose({required int purposeId}) async {
    return ClickioConsentSdkPlatform.instance.getConsentForPurpose(
      purposeId: purposeId,
    );
  }

  Future<String?> getConsentForVendor({required int vendorId}) async {
    return ClickioConsentSdkPlatform.instance.getConsentForVendor(
      vendorId: vendorId,
    );
  }

  Future<String?> getTCString() async {
    return ClickioConsentSdkPlatform.instance.getTCString();
  }

  Future<String?> getACString() async {
    return ClickioConsentSdkPlatform.instance.getACString();
  }

  Future<String?> getGPPString() async {
    return ClickioConsentSdkPlatform.instance.getGPPString();
  }

  Future<String?> getConsentedTCFVendors() async {
    return ClickioConsentSdkPlatform.instance.getConsentedTCFVendors();
  }

  Future<String?> getConsentedTCFLiVendors() async {
    return ClickioConsentSdkPlatform.instance.getConsentedTCFLiVendors();
  }

  Future<String?> getConsentedTCFPurposes() async {
    return ClickioConsentSdkPlatform.instance.getConsentedTCFPurposes();
  }

  Future<String?> getConsentedTCFLiPurposes() async {
    return ClickioConsentSdkPlatform.instance.getConsentedTCFLiPurposes();
  }

  Future<String?> getConsentedGoogleVendors() async {
    return ClickioConsentSdkPlatform.instance.getConsentedGoogleVendors();
  }

  Future<String?> getConsentedOtherVendors() async {
    return ClickioConsentSdkPlatform.instance.getConsentedOtherVendors();
  }

  Future<String?> getConsentedOtherLiVendors() async {
    return ClickioConsentSdkPlatform.instance.getConsentedOtherLiVendors();
  }

  Future<String?> getConsentedNonTcfPurposes() async {
    return ClickioConsentSdkPlatform.instance.getConsentedNonTcfPurposes();
  }

  Future<String?> getGoogleConsentMode() async {
    return ClickioConsentSdkPlatform.instance.getGoogleConsentMode();
  }
}
