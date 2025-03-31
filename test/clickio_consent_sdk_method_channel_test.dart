import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clickio_consent_sdk/clickio_consent_sdk_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelClickioConsentSdk platform = MethodChannelClickioConsentSdk();
  const MethodChannel channel = MethodChannel('clickio_consent_sdk');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
