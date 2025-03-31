import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:clickio_consent_sdk/clickio_consent_sdk.dart';

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

  Map<String, String?> _consentData = {}; // Map to hold consent data

  @override
  void initState() {
    super.initState();

    // Initialize SDK
    _clickioConsentSdk.initialize(appId: '241131', language: 'en');
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
        body: Column(
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await _clickioConsentSdk.openDialog(); // Open dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Color.fromRGBO(12, 20, 67, 1.0),
                    ),
                    child: const Text(
                      'Open Consent Window',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: () async {
                      // Get Consent Data
                      _consentData = await _clickioConsentSdk.getConsentData();
                      setState(() {}); // Update UI
                    },
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
                            entry.value ?? 'null',
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
    );
  }
}
