import 'package:clickio_consent_sdk/dialog_mode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clickio_consent_sdk/clickio_consent_sdk.dart';
import 'package:clickio_consent_sdk/clickio_consent_sdk_platform_interface.dart';
import 'package:clickio_consent_sdk/clickio_consent_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockClickioConsentSdkPlatform
    with MockPlatformInterfaceMixin
    implements ClickioConsentSdkPlatform {
  @override
  Future<String?> initialize({
    required String appId,
    required String language,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> openDialog({DialogMode mode = DialogMode.defaultMode}) async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, String?>> getConsentData() async {
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
