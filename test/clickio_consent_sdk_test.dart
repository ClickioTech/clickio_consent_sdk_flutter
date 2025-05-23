import 'package:clickio_consent_sdk/clickio_consent_sdk.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clickio_consent_sdk/clickio_consent_sdk_platform_interface.dart';
import 'package:clickio_consent_sdk/clickio_consent_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockClickioConsentSdkPlatform
    with MockPlatformInterfaceMixin
    implements ClickioConsentSdkPlatform {
  @override
  Future<String?> initialize({required Config config}) async {
    throw UnimplementedError();
  }

  @override
  Future<void> setLogsMode({required LogsMode mode}) {
    throw UnimplementedError();
  }

  @override
  Future<String?> openDialog({
    DialogMode mode = DialogMode.defaultMode,
    required bool attNeeded,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<String?> getACString() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getConsentForPurpose({required int purposeId}) {
    throw UnimplementedError();
  }

  @override
  Future<String?> getConsentForVendor({required int vendorId}) {
    throw UnimplementedError();
  }

  @override
  Future<String?> getConsentScope() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getConsentState() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getConsentedGoogleVendors() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getConsentedNonTcfPurposes() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getConsentedOtherLiVendors() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getConsentedOtherVendors() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getConsentedTCFLiPurposes() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getConsentedTCFLiVendors() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getConsentedTCFPurposes() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getConsentedTCFVendors() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getGPPString() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getGoogleConsentMode() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getTCString() {
    throw UnimplementedError();
  }
}

void main() {
  final ClickioConsentSdkPlatform initialPlatform =
      ClickioConsentSdkPlatform.instance;

  test('$MethodChannelClickioConsentSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelClickioConsentSdk>());
  });
}
