import 'package:clickio_consent_sdk/clickio_consent_sdk.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

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
    final indent = const SizedBox(height: 16);

    return MaterialApp(
      home: Scaffold(
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
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: openDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(12, 20, 67, 1.0),
                      ),
                      child: const Text(
                        'Open Consent Window',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: getConsentData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(12, 20, 67, 1.0),
                      ),
                      child: const Text(
                        'Get Consent Data',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              indent,
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
  }

  Future<void> openDialog() async {
    await clickioConsentSdk.openDialog(
      mode: DialogMode.resurface,
      showATTFirst: true,
      attNeeded: true,
    );

    await getConsentData();
  }

  Future<void> getConsentData() async {
    _consentData = await getAndroidConsentData();

    setState(() {
      _consentData = _sortConsentData(_consentData);
    });
  }

  Future<Map<String, String?>> getAndroidConsentData() async {
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

    final entries = await Future.wait(
      futures.entries.map(
        (entry) async => MapEntry(entry.key, await entry.value),
      ),
    );

    return Map.fromEntries(entries);
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
