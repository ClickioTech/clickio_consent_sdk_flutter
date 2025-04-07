import 'package:clickio_consent_sdk/dialog_mode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ClickioConsentSdkIOS {
  static const MethodChannel _channel = MethodChannel('clickio_consent_sdk');

  Future<String?> initialize({
    required String appId,
    String language = 'en',
  }) async {
    try {
      debugPrint(
        'Initializing ClickioConsentSDK with appId=$appId, language=$language',
      );

      final result = await _channel.invokeMethod('initialize', {
        'appId': appId,
        'language': language,
      });

      debugPrint(result);

      return result;
    } catch (e) {
      debugPrint('Error initializing SDK - $e');

      return null;
    }
  }

  Future<String?> openDialog({
    DialogMode mode = DialogMode.defaultMode,
    required bool showATTFirst,
    required bool alwaysShowCMP,
    required bool attNeeded,
  }) async {
    try {
      debugPrint('Opening consent dialog');

      final result = await _channel.invokeMethod('openDialog', {
        "mode": mode.name,
        "showATTFirst": showATTFirst,
        "alwaysShowCMP": alwaysShowCMP,
        "attNeeded": attNeeded,
      });

      debugPrint(result);

      return result;
    } catch (e) {
      debugPrint('Error opening consent dialog - $e');

      return null;
    }
  }

  Future<String?> getConsentScope() async {
    try {
      final result = await _channel.invokeMethod('getConsentScope');

      debugPrint('checkConsentScope: $result');

      return result;
    } catch (e) {
      debugPrint('Error retrieving consent scope - $e');

      return null;
    }
  }

  Future<String?> getConsentState() async {
    try {
      final result = await _channel.invokeMethod('getConsentState');

      debugPrint('checkConsentState: $result');

      return result;
    } catch (e) {
      debugPrint('Error retrieving consent state - $e');

      return null;
    }
  }

  Future<String?> getConsentForPurpose({required int purposeId}) async {
    try {
      final result = await _channel.invokeMethod('getConsentForPurpose', {
        'id': purposeId,
      });

      debugPrint('checkConsentForPurpose($purposeId): $result');

      return result;
    } catch (e) {
      debugPrint('Error retrieving consent for purpose - $e');
      return null;
    }
  }

  Future<String?> getConsentForVendor({required int vendorId}) async {
    try {
      final result = await _channel.invokeMethod('getConsentForVendor', {
        'id': vendorId,
      });

      debugPrint('checkConsentForVendor($vendorId): $result');

      return result;
    } catch (e) {
      debugPrint('Error retrieving consent for vendor - $e');

      return null;
    }
  }

  Future<String?> getTCString() async {
    try {
      final result = await _channel.invokeMethod('getTCString');

      debugPrint('getTCString: $result');

      return result;
    } catch (e) {
      debugPrint('Error retrieving TC String - $e');

      return null;
    }
  }

  Future<String?> getACString() async {
    try {
      final result = await _channel.invokeMethod('getACString');

      debugPrint('getACString: $result');

      return result;
    } catch (e) {
      debugPrint('Error retrieving AC String - $e');

      return null;
    }
  }

  Future<String?> getGPPString() async {
    try {
      final result = await _channel.invokeMethod('getGPPString');

      debugPrint('getGPPString: $result');

      return result;
    } catch (e) {
      debugPrint('Error retrieving GPP String - $e');
      return null;
    }
  }

  Future<String?> getConsentedTCFVendors() async {
    try {
      final result = await _channel.invokeMethod('getConsentedTCFVendors');

      debugPrint('getConsentedTCFVendors: $result');

      return result;
    } catch (e) {
      debugPrint('Error retrieving consented TCF vendors - $e');

      return null;
    }
  }

  Future<String?> getConsentedTCFLiVendors() async {
    try {
      final result = await _channel.invokeMethod('getConsentedTCFLiVendors');

      debugPrint('getConsentedTCFLiVendors: $result');

      return result;
    } catch (e) {
      debugPrint('Error retrieving consented TCF Li vendors - $e');

      return null;
    }
  }

  Future<String?> getConsentedTCFPurposes() async {
    try {
      final result = await _channel.invokeMethod('getConsentedTCFPurposes');

      debugPrint('getConsentedTCFPurposes: $result');

      return result;
    } catch (e) {
      debugPrint('Error retrieving consented TCF purposes - $e');

      return null;
    }
  }

  Future<String?> getConsentedTCFLiPurposes() async {
    try {
      final result = await _channel.invokeMethod('getConsentedTCFLiPurposes');

      debugPrint('getConsentedTCFLiPurposes: $result');

      return result;
    } catch (e) {
      debugPrint('Error retrieving consented TCF Li purposes - $e');

      return null;
    }
  }

  Future<String?> getConsentedGoogleVendors() async {
    try {
      final result = await _channel.invokeMethod('getConsentedGoogleVendors');

      debugPrint('getConsentedGoogleVendors: $result');

      return result;
    } catch (e) {
      debugPrint('Error retrieving consented Google vendors - $e');

      return null;
    }
  }

  Future<String?> getConsentedOtherVendors() async {
    try {
      final result = await _channel.invokeMethod('getConsentedOtherVendors');

      debugPrint('getConsentedOtherVendors: $result');

      return result;
    } catch (e) {
      debugPrint('Error retrieving consented other vendors - $e');

      return null;
    }
  }

  Future<String?> getConsentedOtherLiVendors() async {
    try {
      final result = await _channel.invokeMethod('getConsentedOtherLiVendors');

      debugPrint('getConsentedOtherLiVendors: $result');

      return result;
    } catch (e) {
      debugPrint('Error retrieving consented other Li vendors - $e');

      return null;
    }
  }

  Future<String?> getConsentedNonTcfPurposes() async {
    try {
      final result = await _channel.invokeMethod('getConsentedNonTcfPurposes');

      debugPrint('getConsentedNonTcfPurposes: $result');

      return result;
    } catch (e) {
      debugPrint('Error retrieving consented non-TCF purposes - $e');

      return null;
    }
  }

  Future<String?> getGoogleConsentMode() async {
    try {
      final result = await _channel.invokeMethod('getGoogleConsentMode');

      debugPrint('Google Consent Mode: $result');

      return result;
    } catch (e) {
      debugPrint('Error retrieving Google consent mode - $e');

      return null;
    }
  }
}
