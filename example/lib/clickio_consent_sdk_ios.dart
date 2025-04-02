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

  Future<String?> openDialog() async {
    try {
      debugPrint('Opening consent dialog');

      final result = await _channel.invokeMethod('openDialog');

      debugPrint(result);

      return result;
    } catch (e) {
      debugPrint('Error opening consent dialog - $e');

      return null;
    }
  }

  Future<Map<String, String?>> getConsentData() async {
    try {
      final result = await _channel.invokeMethod('getConsentData');

      if (result is Map) {
        debugPrint('Consent Data Map: $result');

        final consentData = <String, String?>{};

        result.forEach((key, value) {
          // Ensure the key is a String and value is a String or null
          if (key is String) consentData[key] = value?.toString();
        });

        return consentData;
      }

      return {};
    } catch (e) {
      debugPrint('Error retrieving consent data - $e');

      return {};
    }
  }
}
