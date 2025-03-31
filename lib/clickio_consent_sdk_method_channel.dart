import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'clickio_consent_sdk_platform_interface.dart';
import 'dialog_mode.dart';

/// An implementation of [ClickioConsentSdkPlatform] that uses method channels.
class MethodChannelClickioConsentSdk extends ClickioConsentSdkPlatform {
  static const _methodChannel = MethodChannel('clickio_consent_sdk');

  @override
  Future<String?> initialize({
    required String appId,
    required String language,
  }) async {
    try {
      debugPrint(
        'Initializing ClickioConsentSDK with appId=$appId, language=$language',
      );

      final result = await _methodChannel.invokeMethod('initialize', {
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

  @override
  Future<String?> openDialog({required DialogMode mode}) async {
    try {
      debugPrint('Opening consent dialog with mode: $mode');

      final result = await _methodChannel.invokeMethod('openDialog', {
        'mode': mode.name == 'defaultMode' ? 'resurfaceMode' : mode.name,
      });

      debugPrint(result);

      return result;
    } catch (e) {
      debugPrint('Error opening consent dialog - $e');
      return null;
    }
  }

  @override
  Future<Map<String, String?>> getConsentData() async {
    try {
      final result = await _methodChannel.invokeMethod('getConsentData');

      if (result is Map) {
        debugPrint('Consent Data Map: $result');

        // Convert the Map<Object?, Object?> to Map<String, String?>
        final consentData = <String, String?>{};

        result.forEach((key, value) {
          // Ensure the key is a String and value is a String or null
          if (key is String) {
            // Convert value to String if it's not null
            consentData[key] = value?.toString();
          }
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
