import 'package:clickio_consent_sdk/clickio_consent_sdk.dart';
import 'package:clickio_consent_sdk_example/widgets/primary_button.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: const MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final clickioConsentSdk = ClickioConsentSdk();
  final config = Config(siteId: '241131', language: 'en');

  Map<String, String?> _consentData = {};

  @override
  void initState() {
    super.initState();

    initializeSdk();
  }

  @override
  Widget build(BuildContext context) {
    final padding16 = SizedBox(height: 16);
    final padding4 = SizedBox(height: 4);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: const Text(
            'Clickio Consent SDK',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: SafeArea(
        child: Builder(
          builder:
              (context) => Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        padding16,
                        PrimaryButton(
                          title: 'Default Mode',
                          onTap: openDialogInDefaultMode,
                        ),
                        padding4,
                        PrimaryButton(
                          title: 'Resurface Mode',
                          onTap: openDialog,
                        ),
                        padding4,
                        PrimaryButton(
                          title: 'Custom URL',
                          onTap: webViewLoadUrl,
                        ),
                        padding4,
                        PrimaryButton(
                          title: 'Get Consent Data',
                          onTap: getConsentData,
                        ),
                      ],
                    ),
                  ),
                  padding16,
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children:
                            _consentData.entries.map((entry) {
                              return ListTile(
                                title: Text(
                                  entry.key,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(
                                  entry.value.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }

  Future<void> initializeSdk() async {
    await clickioConsentSdk.setLogsMode(mode: LogsMode.verbose);
    await clickioConsentSdk.initialize(config: config);
    await clickioConsentSdk.openDialog(attNeeded: true);
  }

  Future<void> openDialogInDefaultMode() async {
    await clickioConsentSdk.openDialog();
  }

  Future<void> openDialog() async {
    await clickioConsentSdk.openDialog(
      mode: DialogMode.resurface,
      attNeeded: true,
    );
  }

  Future<void> webViewLoadUrl() async {
    final backgroundColor = const Color.fromARGB(255, 227, 247, 246);

    clickioConsentSdk.setOnWebClose(() async {
      await Navigator.maybePop(context);
      await clickioConsentSdk.cleanup();
    });

    final webView = clickioConsentSdk.webViewLoadUrl(
      url: 'https://example.com',
      webViewConfig: WebViewConfig(
        backgroundColor: backgroundColor,
        height: 600,
        width: 350,
        gravity: WebViewGravity.center,
      ),
    );

    await showDialog(
      context: context,
      builder:
          (_) => Dialog(
            backgroundColor: backgroundColor,
            insetPadding: EdgeInsets.zero,
            clipBehavior: Clip.hardEdge,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Custom close button
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    // Removing WebView by button click
                    await Navigator.maybePop(context);
                  },
                ),
                // Custom WebView
                webView,
              ],
            ),
          ),
    );
  }

  Future<void> getConsentData() async {
    _consentData = await _getConsentData();

    setState(() => _consentData = _sortConsentData(_consentData));
  }

  Future<Map<String, String?>> _getConsentData() async {
    final sdk = clickioConsentSdk;

    final futures = {
      'checkConsentScope': sdk.getConsentScope(),
      'checkConsentState': sdk.getConsentState(),
      'checkConsentForPurpose(1)': sdk.getConsentForPurpose(purposeId: 1),
      'checkConsentForVendor(9)': sdk.getConsentForVendor(vendorId: 9),
      'getTCString': sdk.getTCString(),
      'getACString': sdk.getACString(),
      'getGPPString': sdk.getGPPString(),
      'getGoogleConsentMode': sdk.getGoogleConsentMode(),
      'getConsentedTCFVendors': sdk.getConsentedTCFVendors(),
      'getConsentedTCFLiVendors': sdk.getConsentedTCFLiVendors(),
      'getConsentedTCFPurposes': sdk.getConsentedTCFPurposes(),
      'getConsentedTCFLiPurposes': sdk.getConsentedTCFLiPurposes(),
      'getConsentedGoogleVendors': sdk.getConsentedGoogleVendors(),
      'getConsentedOtherVendors': sdk.getConsentedOtherVendors(),
      'getConsentedOtherLiVendors': sdk.getConsentedOtherLiVendors(),
      'getConsentedNonTcfPurposes': sdk.getConsentedNonTcfPurposes(),
    };

    final results = await Future.wait(
      futures.entries.map(
        (entry) async => MapEntry(entry.key, await entry.value),
      ),
    );

    return Map.fromEntries(results);
  }

  Map<String, String?> _sortConsentData(Map<String, String?> consentData) {
    final priorityKeys = [
      'checkConsentScope',
      'checkConsentState',
      'checkConsentForPurpose(1)',
      'checkConsentForVendor(9)',
      'getTCString',
      'getACString',
      'getGPPString',
      'getConsentedTCFVendors',
      'getConsentedTCFLiVendors',
      'getConsentedTCFPurposes',
      'getConsentedTCFLiPurposes',
      'getConsentedGoogleVendors',
      'getConsentedOtherVendors',
      'getConsentedOtherLiVendors',
      'getConsentedNonTcfPurposes',
      'getGoogleConsentMode',
    ];

    Map<String, String?> sortedConsentData = {};

    for (var key in priorityKeys) {
      if (consentData.containsKey(key)) {
        sortedConsentData[key] = consentData[key];
      }
    }

    return sortedConsentData;
  }
}
