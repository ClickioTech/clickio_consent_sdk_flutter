import 'dart:async';

import './clickio_consent_sdk_platform_interface.dart';
import './config/config.dart';
import './enums/enums.dart';

export './config/config.dart';
export './enums/enums.dart';

/// A SDK class that provides methods for handling user consent and related functionalities.
/// This includes initialization, consent updates, dialog presentation, and retrieving consent information.
class ClickioConsentSdk {
  static final _onReadyController = StreamController<void>.broadcast();
  static final _onConsentUpdateController = StreamController<void>.broadcast();

  static Stream<void> get onReady => _onReadyController.stream;
  static Stream<void> get onConsentUpdate => _onConsentUpdateController.stream;

  static void handleMethodCall(String method) {
    switch (method) {
      case 'onReady':
        _onReadyController.add(null);
        break;
      case 'onConsentUpdate':
        _onConsentUpdateController.add(null);
        break;
    }
  }

  /// Initializes the SDK with a provided [Config] object.
  ///
  /// This method should be called at the beginning of the app to set up the SDK.
  ///
  /// [config] - The configuration parameters needed to initialize the SDK.
  ///
  /// Returns a [Future<String?>] indicating the result of the initialization process.
  Future<String?> initialize({required Config config}) async {
    return ClickioConsentSdkPlatform.instance.initialize(config: config);
  }

  /// Sets the log mode for the SDK.
  ///
  /// This method allows you to enable or disable logging for SDK operations.
  ///
  /// [mode] - The log mode to set. It can be one of the [LogsMode] values.
  Future<void> setLogsMode({required LogsMode mode}) async {
    return ClickioConsentSdkPlatform.instance.setLogsMode(mode: mode);
  }

  /// Opens the consent dialog with specified settings.
  ///
  /// You can customize the dialog's mode and whether the App Tracking Transparency (ATT) dialog should be shown first.
  ///
  /// [mode] - The dialog mode to be used. Defaults to [DialogMode.defaultMode].
  /// [attNeeded] - A flag indicating whether ATT consent is needed. Defaults to `false`.
  Future<void> openDialog({
    DialogMode mode = DialogMode.defaultMode,
    bool attNeeded = false,
  }) async {
    return ClickioConsentSdkPlatform.instance.openDialog(
      mode: mode,
      attNeeded: attNeeded,
    );
  }

  /// Retrieves the consent scope as a string.
  ///
  /// This method provides the current consent scope of the user.
  ///
  /// Returns a [Future<String?>] containing the consent scope, or `null` if not available.
  Future<String?> getConsentScope() async {
    return ClickioConsentSdkPlatform.instance.getConsentScope();
  }

  /// Retrieves the current consent state as a string.
  ///
  /// This method provides the current state of consent, which could be a status like "granted" or "denied".
  ///
  /// Returns a [Future<String?>] containing the consent state.
  Future<String?> getConsentState() async {
    return ClickioConsentSdkPlatform.instance.getConsentState();
  }

  /// Retrieves the consent status for a specific purpose based on its ID.
  ///
  /// [purposeId] - The unique identifier of the consent purpose.
  ///
  /// Returns a [Future<String?>] containing the consent status for the specified purpose.
  Future<String?> getConsentForPurpose({required int purposeId}) async {
    return ClickioConsentSdkPlatform.instance.getConsentForPurpose(
      purposeId: purposeId,
    );
  }

  /// Retrieves the consent status for a specific vendor based on its ID.
  ///
  /// [vendorId] - The unique identifier of the vendor.
  ///
  /// Returns a [Future<String?>] containing the consent status for the specified vendor.
  Future<String?> getConsentForVendor({required int vendorId}) async {
    return ClickioConsentSdkPlatform.instance.getConsentForVendor(
      vendorId: vendorId,
    );
  }

  /// Retrieves the Transparency and Consent (TC) string.
  ///
  /// The TC string is used to represent the user's consent information.
  ///
  /// Returns a [Future<String?>] containing the TC string.
  Future<String?> getTCString() async {
    return ClickioConsentSdkPlatform.instance.getTCString();
  }

  /// Retrieves the Acceptance Criteria (AC) string.
  ///
  /// The AC string represents the criteria under which the user accepted or rejected consent.
  ///
  /// Returns a [Future<String?>] containing the AC string.
  Future<String?> getACString() async {
    return ClickioConsentSdkPlatform.instance.getACString();
  }

  /// Retrieves the General Data Protection Regulation (GPP) string.
  ///
  /// The GPP string contains the user’s consent information in accordance with the GDPR.
  ///
  /// Returns a [Future<String?>] containing the GPP string.
  Future<String?> getGPPString() async {
    return ClickioConsentSdkPlatform.instance.getGPPString();
  }

  /// Retrieves the list of vendors that the user has consented to under the TC framework.
  ///
  /// Returns a [Future<String?>] containing the list of consented vendors.
  Future<String?> getConsentedTCFVendors() async {
    return ClickioConsentSdkPlatform.instance.getConsentedTCFVendors();
  }

  /// Retrieves the list of vendors that the user has consented to for legitimate interest under the TC framework.
  ///
  /// Returns a [Future<String?>] containing the list of consented vendors for legitimate interest.
  Future<String?> getConsentedTCFLiVendors() async {
    return ClickioConsentSdkPlatform.instance.getConsentedTCFLiVendors();
  }

  /// Retrieves the list of purposes the user has consented to under the TC framework.
  ///
  /// Returns a [Future<String?>] containing the list of consented purposes.
  Future<String?> getConsentedTCFPurposes() async {
    return ClickioConsentSdkPlatform.instance.getConsentedTCFPurposes();
  }

  /// Retrieves the list of purposes the user has consented to for legitimate interest under the TC framework.
  ///
  /// Returns a [Future<String?>] containing the list of consented purposes for legitimate interest.
  Future<String?> getConsentedTCFLiPurposes() async {
    return ClickioConsentSdkPlatform.instance.getConsentedTCFLiPurposes();
  }

  /// Retrieves the list of Google vendors the user has consented to.
  ///
  /// Returns a [Future<String?>] containing the list of consented Google vendors.
  Future<String?> getConsentedGoogleVendors() async {
    return ClickioConsentSdkPlatform.instance.getConsentedGoogleVendors();
  }

  /// Retrieves the list of other vendors the user has consented to.
  ///
  /// Returns a [Future<String?>] containing the list of consented other vendors.
  Future<String?> getConsentedOtherVendors() async {
    return ClickioConsentSdkPlatform.instance.getConsentedOtherVendors();
  }

  /// Retrieves the list of other vendors the user has consented to for legitimate interest.
  ///
  /// Returns a [Future<String?>] containing the list of consented other vendors for legitimate interest.
  Future<String?> getConsentedOtherLiVendors() async {
    return ClickioConsentSdkPlatform.instance.getConsentedOtherLiVendors();
  }

  /// Retrieves the list of non-TCF purposes the user has consented to.
  ///
  /// Returns a [Future<String?>] containing the list of consented non-TCF purposes.
  Future<String?> getConsentedNonTcfPurposes() async {
    return ClickioConsentSdkPlatform.instance.getConsentedNonTcfPurposes();
  }

  /// Retrieves the Google consent mode string.
  ///
  /// This method provides the consent mode string used for Google-related consent.
  ///
  /// Returns a [Future<String?>] containing the Google consent mode.
  Future<String?> getGoogleConsentMode() async {
    return ClickioConsentSdkPlatform.instance.getGoogleConsentMode();
  }
}
