import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './clickio_consent_sdk_platform_interface.dart';
import './clickio_consent_sdk.dart';

/// An implementation of [ClickioConsentSdkPlatform] that uses method channels.
class MethodChannelClickioConsentSdk extends ClickioConsentSdkPlatform {
  static const _methodChannel = MethodChannel('clickio_consent_sdk');

  Future<void> _handleMethodCall(MethodCall call) async {
    ClickioConsentSdk.handleMethodCall(call.method);
  }

  @override
  Future<String?> initialize({required Config config}) async {
    try {
      _methodChannel.setMethodCallHandler(_handleMethodCall);

      final result = await _methodChannel.invokeMethod<String>('initialize', {
        'siteId': config.siteId,
        'language': config.language,
      });

      return result;
    } catch (e) {
      debugPrint('Error initializing SDK - $e');

      return null;
    }
  }

  @override
  Future<void> setLogsMode({required LogsMode mode}) async {
    await _methodChannel.invokeMethod('setLogsMode', {'mode': mode.name});
  }

  @override
  Future<String?> openDialog({
    required DialogMode mode,
    required bool attNeeded,
  }) async {
    try {
      final args = {
        'mode': mode.name,
        if (Platform.isIOS) ...{'attNeeded': attNeeded},
      };

      final result = await _methodChannel.invokeMethod<String>(
        'openDialog',
        args,
      );

      return result;
    } catch (e) {
      debugPrint('Error opening consent dialog - $e');

      return null;
    }
  }

  Future<void> cleanup() async {
    if (Platform.isIOS) await _methodChannel.invokeMapMethod('cleanup');
  }

  Future<String?> getConsentScope() async {
    try {
      final result = await _methodChannel.invokeMethod('getConsentScope');

      return result;
    } catch (e) {
      debugPrint('Error retrieving consent scope - $e');

      return null;
    }
  }

  Future<String?> getConsentState() async {
    try {
      final result = await _methodChannel.invokeMethod('getConsentState');

      return result;
    } catch (e) {
      debugPrint('Error retrieving consent state - $e');

      return null;
    }
  }

  Future<String?> getConsentForPurpose({required int purposeId}) async {
    try {
      final result = await _methodChannel.invokeMethod('getConsentForPurpose', {
        'id': purposeId,
      });

      return result;
    } catch (e) {
      debugPrint('Error retrieving consent for purpose - $e');
      return null;
    }
  }

  Future<String?> getConsentForVendor({required int vendorId}) async {
    try {
      final result = await _methodChannel.invokeMethod('getConsentForVendor', {
        'id': vendorId,
      });

      return result;
    } catch (e) {
      debugPrint('Error retrieving consent for vendor - $e');

      return null;
    }
  }

  Future<String?> getTCString() async {
    try {
      final result = await _methodChannel.invokeMethod('getTCString');

      return result;
    } catch (e) {
      debugPrint('Error retrieving TC String - $e');

      return null;
    }
  }

  Future<String?> getACString() async {
    try {
      final result = await _methodChannel.invokeMethod('getACString');

      return result;
    } catch (e) {
      debugPrint('Error retrieving AC String - $e');

      return null;
    }
  }

  Future<String?> getGPPString() async {
    try {
      final result = await _methodChannel.invokeMethod('getGPPString');

      return result;
    } catch (e) {
      debugPrint('Error retrieving GPP String - $e');
      return null;
    }
  }

  Future<String?> getConsentedTCFVendors() async {
    try {
      final result = await _methodChannel.invokeMethod(
        'getConsentedTCFVendors',
      );

      return result;
    } catch (e) {
      debugPrint('Error retrieving consented TCF vendors - $e');

      return null;
    }
  }

  Future<String?> getConsentedTCFLiVendors() async {
    try {
      final result = await _methodChannel.invokeMethod(
        'getConsentedTCFLiVendors',
      );

      return result;
    } catch (e) {
      debugPrint('Error retrieving consented TCF Li vendors - $e');

      return null;
    }
  }

  Future<String?> getConsentedTCFPurposes() async {
    try {
      final result = await _methodChannel.invokeMethod(
        'getConsentedTCFPurposes',
      );

      return result;
    } catch (e) {
      debugPrint('Error retrieving consented TCF purposes - $e');

      return null;
    }
  }

  Future<String?> getConsentedTCFLiPurposes() async {
    try {
      final result = await _methodChannel.invokeMethod(
        'getConsentedTCFLiPurposes',
      );

      return result;
    } catch (e) {
      debugPrint('Error retrieving consented TCF Li purposes - $e');

      return null;
    }
  }

  Future<String?> getConsentedGoogleVendors() async {
    try {
      final result = await _methodChannel.invokeMethod(
        'getConsentedGoogleVendors',
      );

      return result;
    } catch (e) {
      debugPrint('Error retrieving consented Google vendors - $e');

      return null;
    }
  }

  Future<String?> getConsentedOtherVendors() async {
    try {
      final result = await _methodChannel.invokeMethod(
        'getConsentedOtherVendors',
      );

      return result;
    } catch (e) {
      debugPrint('Error retrieving consented other vendors - $e');

      return null;
    }
  }

  Future<String?> getConsentedOtherLiVendors() async {
    try {
      final result = await _methodChannel.invokeMethod(
        'getConsentedOtherLiVendors',
      );

      return result;
    } catch (e) {
      debugPrint('Error retrieving consented other Li vendors - $e');

      return null;
    }
  }

  Future<String?> getConsentedNonTcfPurposes() async {
    try {
      final result = await _methodChannel.invokeMethod(
        'getConsentedNonTcfPurposes',
      );

      return result;
    } catch (e) {
      debugPrint('Error retrieving consented non-TCF purposes - $e');

      return null;
    }
  }

  Future<String?> getGoogleConsentMode() async {
    try {
      final result = await _methodChannel.invokeMethod('getGoogleConsentMode');

      return result;
    } catch (e) {
      debugPrint('Error retrieving Google consent mode - $e');

      return null;
    }
  }
}
