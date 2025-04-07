import 'dart:io';

import 'package:clickio_consent_sdk/dialog_mode.dart';
import 'package:flutter/material.dart';
import 'package:clickio_consent_sdk/clickio_consent_sdk.dart';

import './clickio_consent_sdk_ios.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _clickioConsentSdk = ClickioConsentSdk();
  final _clickioConsentSdkIOS = ClickioConsentSdkIOS();

  Map<String, String?> _consentData = {};

  @override
  void initState() {
    super.initState();

    initilizeSdk();
  }

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 16),
              // Display the consent data
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

  Future<void> initilizeSdk() async {
    final appId = '241131';

    if (Platform.isAndroid) {
      _clickioConsentSdk.initialize(appId: appId);
    } else {
      _clickioConsentSdkIOS.initialize(appId: appId);
    }
  }

  Future<void> openDialog() async {
    if (Platform.isAndroid) {
      await _clickioConsentSdk.openDialog(mode: DialogMode.resurfaceMode);
    } else {
      await _clickioConsentSdkIOS.openDialog(
        mode: DialogMode.resurfaceMode,
        showATTFirst: true,
        alwaysShowCMP: true,
        attNeeded: true,
      );
    }
  }

  Future<void> getConsentData() async {
    // Get Consent Data
    if (Platform.isAndroid) {
      _consentData = await getAndroidConsentData();
    } else {
      _consentData = await getIosConsentData();
    }

    setState(() {
      _consentData = _sortConsentData(_consentData);
    });
  }

  Future<Map<String, String?>> getAndroidConsentData() async {
    final sdk = _clickioConsentSdk;
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

  Future<Map<String, String?>> getIosConsentData() async {
    final sdk = _clickioConsentSdkIOS;
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

    // Add a separator after the first four items
    Map<String, String?> finalConsentData = {};
    int index = 0;

    sortedConsentData.forEach((key, value) {
      finalConsentData[key] = value;
      index++;

      if (index == 4) {
        finalConsentData["____________"] = "";
      }
    });

    return finalConsentData;
  }
}
