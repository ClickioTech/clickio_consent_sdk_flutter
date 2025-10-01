# Clickio Consent SDK for Flutter

A Flutter plugin that wraps the native Clickio Consent SDK for Android and iOS, providing a unified API for managing user consent in compliance with GDPR, TCF, GPP, and other regulations.
 
1. [Requirements](#requirements)
2. [Installation](#installation)
3. [Quick Start](#quick-start)
4. [Setup and Usage](#setup-and-usage)
5. [Methods](#methods)
6. [Integration with Third-Party Libraries for Google Consent Mode](#integration-with-third-party-libraries-for-google-consent-mode)
7. [Integration with Third-Party Libraries When Google Consent Mode Is Disabled](#integration-with-third-party-libraries-when-google-consent-mode-is-disabled)
8. [Delaying Google Mobile Ads display until ATT and User Consent](#delaying-google-mobile-ads-display-until-att-and-user-consent)
9. [WebView Consent Synchronization](#webview-consent-synchronization)
10. [Running the Plugin Example App](#running-the-plugin-example-app)

## Requirements

Before integrating the ClickioConsentSdk (hereinafter reffered to as the Clickio SDK), ensure that your Flutter application meets the following requirements:

### Android

- **Minimum SDK Version**: `21` (Android 5.0)
- **Target/Compile SDK Version**: The minimum required for Google Play compliance.
- **Permissions**: The SDK requires internet access. Add the following permissions to your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

The plugin requires your `MainActivity` to extend `FlutterFragmentActivity` instead of the default `FlutterActivity`.
This is necessary because under the hood, the WebView plugin uses a **Fragment-based approach**, and the WebView factory expects a `FragmentActivity` context. If your activity does not extend `FlutterFragmentActivity`, you may see errors in the log when opening the WebView dialog.

#### In your app MainActivity.kt file:
```kotlin
package com.example.myapp

import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity() {
    // Your usual setup here
}
```



### iOS

- **Minimum iOS Version**: `15.0+`
- **Swift Version**: `5.0+`
- **Permissions:** The SDK requires App Tracking Transparency (ATT) permission. Add the following permissions to your `Info.plist`:

```xml
<key>NSUserTrackingUsageDescription</key>
<string>Add your data usage description</string>
```

## Installation

### Use this plugin as a library

#### Depend on it

Run this command:

With Flutter:
<pre>
$ flutter pub add clickio_consent_sdk
</pre>

This will add a line like this to your `pubspec.yaml` (and run an implicit `flutter pub get`):

```yaml
dependencies:
  clickio_consent_sdk: ^1.0.1
```

Alternatively, your editor might support `flutter pub get`. Check the docs for your editor to learn more.

#### Import it

Now in your Dart code, you can use:

```dart
import 'package:clickio_consent_sdk/clickio_consent_sdk.dart';
```

---

## Quick Start

Here’s the minimal implementation to get started with the `clickio_consent_sdk` in a Flutter project.

### Import the SDK:

```dart
import 'package:clickio_consent_sdk/clickio_consent_sdk.dart';
```

### Initialize the SDK and open Consent Window:

Replace `your_clickio_site_id` with your actual [**Site ID**](https://docs.clickio.com/books/clickio-consent-cmp/page/google-consent-mode-v2-implementation#bkmrk-access-the-template%3A).

```dart
final clickioConsentSdk = ClickioConsentSdk();
final config = Config(siteId: 'your_clickio_site_id');

Future<void> initializeSdk() async {
  await clickioConsentSdk.setLogsMode(mode: LogsMode.verbose);
  await clickioConsentSdk.initialize(config: config);
 
}
```

After initialization, open the consent window like this:

```dart
await clickioConsentSdk.openDialog(
  mode: DialogMode.resurfaceMode,
  attNeeded: true,
);
```

✅ After successful initialization, the SDK will open the consent dialog if it is required for the current user.

---

## Setup and Usage

### App Tracking Transparency (ATT) Permission

`Clickio SDK` supports [two distinct scenarios](#example-scenarios) for handling ATT permissions If your app collects and shares user data with third parties for tracking across apps or websites, **you must**:

1. Add the [`NSUserTrackingUsageDescription`](https://developer.apple.com/documentation/BundleResources/Information-Property-List/NSUserTrackingUsageDescription) key in your `Info.plist`.
2. Choose an ATT permission handling strategy using the [`openDialog`](#opening-the-consent-dialog) method.

If you're managing ATT permissions manually and have already added [`NSUserTrackingUsageDescription`](https://developer.apple.com/documentation/BundleResources/Information-Property-List/NSUserTrackingUsageDescription), you can skip ATT integration here and just use the consent flow.

#### Important:
- **make sure that user has given permission in the ATT dialog and only then perfrom [`openDialog`](#opening-the-consent-dialog) method call! Showing CMP regardles given ATT Permission is not recommended by Apple. Moreover, [`openDialog`](#opening-the-consent-dialog) API call can be blocked by Apple until user makes their choice.**

👉 See [User Privacy and Data Use](https://developer.apple.com/app-store/user-privacy-and-data-use/) and [App Privacy Details](https://developer.apple.com/app-store/app-privacy-details/) for more details.

---

### Singleton Access

All methods should be accessed via a singleton instance of the SDK:

```dart
final clickioConsentSdk = ClickioConsentSdk();
```

---

### Initialization

Use the `initialize` method to initialize the SDK:

```dart
await clickioConsentSdk.initialize(
  config: Config(
    siteId: 'your_clickio_site_id',
    language: 'en', // language is optional
    ), 
);
```

`Config` parameters:
- `siteId` – Your Clickio Site ID (**required**)
- `language` – Optional, 2-letter [ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes) language code (e.g., 'en', 'de')

---

### Handling SDK Readiness

Make sure to use SDK methods **after** the SDK is fully ready. You can do this via your app lifecycle or after `initialize`. (No explicit `onReady` in Flutter – manage readiness with your app state.)

---

### Functionality Overview

#### Opening the Consent Dialog

To open the consent dialog:

```dart
await clickioConsentSdk.openDialog(
  mode: DialogMode.resurface, // or DialogMode.defaultMode
  attNeeded: true,
);
```

#### Parameters:
- `mode` - defines when the dialog should be shown. Possible values::
  - `DialogMode.defaultMode` –  Opens the dialog if GDPR applies and user hasn't given consent.
  - `DialogMode.resurface` – Always forces dialog to open, regardless of the user’s jurisdiction, allowing users to modify settings for GDPR compliance or to opt out under US regulations.
- `attNeeded`: Determines if ATT is required.

> 💡 If your app has it's own ATT Permission manager you just pass `false` in `attNeeded` parameter and call your own ATT method. Keep in mind that in this case consent screen will be shown regardless given ATT Permission.

---

### Handling `singleTask` Launch Mode and Consent Dialog

When your app's Android MainActivity is configured with `launchMode="singleTask"` (set in `AndroidManifest.xml`), returning to the app (e.g., via the launcher icon) can cause the Consent Dialog to close unexpectedly.

To ensure the Consent Dialog is displayed correctly when the launch mode set to `"singleTask"`, handle opening consent dialog in Flutter’s didChangeAppLifecycleState callback.

#### Example:

```dart
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.resumed) {
    _reopenConsentDialog();
  }
}

Future<void> _reopenConsentDialog() async {
  final consentState = await ClickioConsentSdk.checkConsentState();

  if (consentState == ConsentState.gdprNoDecision) {
    // Only show if user hasn't made a decision yet
    await ClickioConsentSdk.openDialog(attNeeded: true);
  } else {
    debugPrint('Consent already decided, not reopening dialog.');
  }
}
```

---

### Example Scenarios:

**1. Show ATT Permission first, then show Consent Dialog only if user has granted ATT Permission:**  
*(Apple recommended)*

```dart
await clickioConsentSdk.openDialog(
  mode: DialogMode.defaultMode,
  attNeeded: true,
);
```

**2. Show only Consent Dialog bypassing ATT Permission demonstration:**

```dart
await clickioConsentSdk.openDialog(
  mode: DialogMode.defaultMode,
  attNeeded: false,
);
```

#### Important:
- **we suggest you to use this approach only if you handle ATT Permission on your own.**
- **make sure that user has given permission in the ATT dialog and only then perfrom [`openDialog`](#opening-the-consent-dialog) method call! Otherwise it will lead to incorrect work of the SDK: showing CMP regardles given ATT Permission is not recommended by Apple. Moreover, [`openDialog`](#opening-the-consent-dialog) API calls to SDK's domains will be blocked by Apple until user provides their permission in ATT dialog.**


---

### Logging

To enable or disable logging:

```dart
await clickioConsentSdk.setLogsMode(
  mode: LogsMode.verbose,
); 
```

- `mode` parameter defines whether logging is enabled or not:
    -   `LogsMode.disabled` – Disables logging, default value
    -   `LogsMode.verbose`  – Enables logging

---

### Checking Consent Scope

```dart
Future<String> consentScope = clickioConsentSdk.getConsentScope();
```

Returns the applicable **consent scope**.

#### Return type: `String`

| Value           | Description                        |
|----------------|------------------------------------|
| `"gdpr"`        | GDPR applies                       |
| `"us"`          | US regulations apply               |
| `"out of scope"`| Neither GDPR nor US laws apply     |

---

### Checking Consent State

```dart
Future<ConsentState> consentState = clickioConsentSdk.getConsentState();
```

Determines the current **consent state** based on the applicable scope and force flag.

#### Return type: `ConsentState` enum

| Android             | iOS                 | Description                                                 |
|---------------------|---------------------|-------------------------------------------------------------|
| `NOT_APPLICABLE`    | `notApplicable`      | Consent is not required for the current region              |
| `GDPR_NO_DECISION`  | `gdprNoDecision`     | GDPR applies, no user decision made                         |
| `GDPR_DECISION_OBTAINED` | `gdprDecisionObtained` | GDPR applies and decision obtained                      |
| `US`                | `us`                 | US privacy laws apply                                       |

> ⚠️ **Note:** Enum casing differs by platform: Android uses **UPPER_SNAKE_CASE**, iOS uses **camelCase**.

---

### Checking Consent for a Purpose

```dart
Future<bool> consentForPurpose = clickioConsentSdk.getConsentForPurpose(
  purposeId: purposeId,
);
```

Checks whether consent was granted for a specific [**TCF purpose**](https://iabeurope.eu/iab-europe-transparency-consent-framework-policies/#headline-24-18959).

#### Parameter

- `purposeId` (`int`): The numeric ID of the TCF purpose.

#### Return type: `bool`

---

### Checking Consent for a Vendor

```dart
Future<bool> consentForVendor = clickioConsentSdk.getConsentForVendor(
  vendorId: vendorId,
);
```

Checks whether consent was granted for a specific [**TCF vendor**](https://iabeurope.eu/vendor-list-tcf/).

#### Parameter

- `vendorId` (`int`): The numeric ID of the vendor.

#### Return type: `bool`

---

## Methods

These methods allow you to query consent strings and granted vendor/purpose IDs, mirroring behavior from iOS/Android.

---

### `getTCString() → Future<String?>`
Returns the IAB TCF v2.2 string if it exists.

---

### `getACString() → Future<String?>`
Returns the Google additional consent string if it exists.

---

### `getGPPString() → Future<String?>`
Returns the Global Privacy Platform (GPP) string if it exists.

---

### `getConsentedTCFVendors() → Future<List<int>?>`
Returns the IDs of TCF vendors that have given consent.

---

### `getConsentedTCFLiVendors() → Future<List<int>?>`
Returns the IDs of TCF vendors that have given consent for legitimate interests.

---

### `getConsentedTCFPurposes() → Future<List<int>?>`
Returns the IDs of TCF purposes that have given consent.

---

### `getConsentedTCFLiPurposes() → Future<List<int>?>`
Returns the IDs of TCF purposes that have given consent as Legitimate Interest.

---

### `getConsentedGoogleVendors() → Future<List<int>?>`
Returns the IDs of Google vendors that have given consent.

---

### `getConsentedOtherVendors() → Future<List<int>?>`
Returns the IDs of non-TCF vendors that have given consent.

---

### `getConsentedOtherLiVendors() → Future<List<int>?>`
Returns the IDs of non-TCF vendors that have given consent for legitimate interests.

---

### `getConsentedNonTcfPurposes() → Future<List<int>?>`
Returns the IDs of non-TCF purposes (simplified purposes) that have given consent.

---

### `getGoogleConsentMode() → Future<GoogleConsentStatus?>`
Returns Google Consent Mode v2 flags wrapped into `GoogleConsentStatus` struct if Google Consent Mode enabled, otherwise will return `false`.

#### GoogleConsentStatus:
```dart
class GoogleConsentStatus {
  final bool analyticsStorageGranted;
  final bool adStorageGranted;
  final bool adUserDataGranted;
  final bool adPersonalizationGranted;
  final bool securityStorageGranted;
  final bool personalizationStorageGranted;
  final bool functionalityStorageGranted;

  GoogleConsentStatus({
    required this.analyticsStorageGranted,
    required this.adStorageGranted,
    required this.adUserDataGranted,
    required this.adPersonalizationGranted,
    required this.securityStorageGranted,
    required this.personalizationStorageGranted,
    required this.functionalityStorageGranted,
  });
}
```

- `analyticsStorageGranted` — Consent for analytics storage  
- `adStorageGranted` — Consent for ad storage  
- `adUserDataGranted` — Consent for processing user data for ads  
- `adPersonalizationGranted` — Consent for ad personalization
- `securityStorageGranted` — Consent for Security Storage.
- `personalizationStorageGranted` — Consent for Personalization Storage.
- `functionalityStorageGranted` — Consent for Functionality Storage. 

---

## Integration with Third-Party Libraries for Google Consent Mode

ClickioConsentSDK provides **automatic support** for transmitting **Google Consent Mode v2** flags to popular third-party platforms when enabled:

### ✅ Supported Platforms
- [**Firebase Analytics**](https://firebase.google.com/docs/analytics)
- [**Adjust**](https://www.adjust.com/)
- [**Airbridge**](https://www.airbridge.io/)
- [**AppsFlyer**](https://www.appsflyer.com/)

---

### 📊 Firebase Analytics

If the **Firebase Analytics SDK** is present in your project:

- ClickioConsentSDK will **automatically send** Google Consent Mode flags to Firebase **if integration is enabled**.
- Flags are transmitted:
  - **Immediately** after the consent dialog update (`onConsentUpdated`)
  - Or **on SDK initialization** if consent has already been given
- If logging is enabled:
  - A **success message** will confirm the transmission.
  - In case of errors, a **log error message** will appear.
- Make sure you're using a **recent version of Firebase Analytics** in your project for best results.

---

### 🚀 Adjust, Airbridge, AppsFlyer

If your project includes any of these SDKs **(Adjust, Airbridge, AppsFlyer)**, `ClickioConsentSDK` will automatically send Google Consent flags to them if _Clickio Google Consent Mode_ integration is **enabled**.

#### ⚠️ Important:
  - Interactions with `ClickioConsentSDK` should be performed **after initializing the third-party SDKs** since `ClickioConsentSDK` only transmits consent flags.
  - **Ensure** that you have completed the required tracking setup for Adjust, Airbridge, or AppsFlyer before integrating `ClickioConsentSDK`. This includes proper initialization and configuration of the SDK according to the vendor’s documentation.
  - If you're using **AppsFlyer** and need to support GDPR compliance via TCF, make sure to enable TCF data collection before SDK initialization: `enableTCFDataCollection(true)`. This allows AppsFlyer to automatically gather consent values (like `tcString`) from the CMP.

After successfully transmitting the flags, a log message will be displayed **(if logging is enabled)** to confirm the successful transmission. In case of an error, an error message will appear in the logs.

> 💡 **Note:** Keep your **Adjust**, **Airbridge**, or **AppsFlyer SDK** updated to ensure compatibility.


---

## Integration with Third-Party Libraries When Google Consent Mode Is Disabled

If **Google Consent Mode integration is disabled**, you can manually determine user consent and set flags accordingly for other SDKs like Firebase Analytics.

---

### Firebase Analytics Example:

```dart
final purpose1 = await clickioConsentSdk.getConsentForPurpose(purposeId: 1);
final purpose3 = await clickioConsentSdk.getConsentForPurpose(purposeId: 3);
final purpose4 = await clickioConsentSdk.getConsentForPurpose(purposeId: 4);
final purpose7 = await clickioConsentSdk.getConsentForPurpose(purposeId: 7);
final purpose8 = await clickioConsentSdk.getConsentForPurpose(purposeId: 8);
final purpose9 = await clickioConsentSdk.getConsentForPurpose(purposeId: 9);

final adStorage = purpose1;
final adUserData = purpose1 && purpose7;
final adPersonalization = purpose3 && purpose4;
final analyticsStorage = purpose8 && purpose9;

// Set Firebase Analytics consent flags
await FirebaseAnalytics.instance.setConsent(
  adStorageConsentGranted: adStorage,
  adUserDataConsentGranted: adUserData,
  adPersonalizationSignalsConsentGranted: adPersonalization,
  analyticsStorageConsentGranted: analyticsStorage
);
```

📚 [More about Consent Mode flags mapping with TCF and non-TCF purposes](https://docs.clickio.com/books/clickio-consent-cmp/page/google-consent-mode-v2-implementation#bkmrk-5.1.-tcf-mode)

---

## Delaying Google Mobile Ads display until ATT and User Consent

Sometimes you need to ensure that both Apple's App Tracking Transparency prompt and user consent decision have been recorded before initializing and loading Google Mobile Ads. To implement this flow:

1. **Wait for ATT authorization and CMP readiness**
  - First present the ATT prompt.
  - Then open Clickio SDK's consent dialog via `ClickioConsentSDK.openDialog()`.
2. **Use Clickio SDK's callbacks**
  - In the `onReady` callback, you know that SDK is ready & the CMP dialog can be shown.
  - In the `onConsentUpdated` callback, you know the user's consent decision has been recorded.
3. **Initialize and load ads only after consent**
  - Ensure that `checkConsentState() != gdprNoDecision` has been confirmed.
  - Then call `MobileAds.instance.initialize(...)` and load your banner.
This ensures that Google Mobile Ads is only started - and the banner only fetched — once you've obtained both ATT permission and explicit user decision from the CMP.

#### Note: Avoid double-starting

– E.g. if ads already started on initial accept, don’t restart after a later “resurface” consent change.

#### Code example:

```dart
// Keep track of whether Google Mobile Ads has already been started
bool _adsStarted = false;

void setupConsentAndAds() {
  // 1) Listen for SDK readiness (CMP can show)
  ClickioConsentSdk.onReady.listen((_) {
    // 2) Show CMP dialog
    ClickioConsentSDK.openDialog(
      mode: DialogMode.defaultMode,
      attNeeded: true,
    );

    // 3) Immediately check prior consent
    _tryStartAdsIfAllowed();
  });

  // 4) When consent changes, check again
  ClickioConsentSdk.onConsentUpdate.listen((_) {
    _tryStartAdsIfAllowed();
  });
}

Future<void> _tryStartAdsIfAllowed() async {
  final consentState = await ClickioConsentSDK.checkConsentState();
  
  if (consentState == ConsentState.gdprNoDecision) return;

  if (_adsStarted) {
    debugPrint('Ads already started');

    return;
  }

  debugPrint('Consent allows ads – starting Google Mobile Ads');

  await MobileAds.instance.initialize();

  _adsStarted = true;

  _loadBannerAd(); // Optional: Load your ad here
}

void _loadBannerAd() {
  // Load a simple banner ad
  BannerAd(
    adUnitId: '<YOUR_AD_UNIT_ID>',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  ).load();
}
```

---

## WebView Consent Synchronization

### Overview

When your Flutter app displays **content** (built with Dart) and **web content** inside a WebView (for example, embedded websites or widgets), it is important to synchronize user consent. Without synchronization, the Consent Management Platform (CMP) dialog may appear twice — once in the app layer and once inside the WebView content.

The `webViewLoadUrl()` method helps **synchronize consent** between app and web layers. It creates and returns a configured `WebView` widget for each platform (`AndroidView` for Android and `UiKitView` for iOS) to handle saved consent, which you can then embed into your app screens as needed. You can also customize the appearance through the `WebViewConfig` configuration class and wrap the view using Flutter widgets.

💡 **Tip:** Use this method whenever you need to display web content that must respect the user’s consent settings already established in the part of your Flutter app. This ensures a seamless experience and prevents duplicate consent prompts.

```dart
 Widget webViewLoadUrl({required String url, WebViewConfig? webViewConfig}) {
    final config = webViewConfig ?? WebViewConfig();

    return ClickioConsentSdkPlatform.instance.webViewLoadUrl(
      url: url,
      webViewConfig: config,
    );
  }
```

### Configuration

**`WebViewConfig` class:**
```dart
 class WebViewConfig {
  /// Background color of the WebView.
  /// Default: Colors.transparent. Example: 0xFFFFFFFF or Colors.white
  final Color? backgroundColor;

  /// Height of the WebView in pixels.
  /// Default: null - widget will expand to fill available space (match parent behavior)
  final int? height;

  /// Width of the WebView in pixels.
  /// Default: null - widget will expand to fill available space (match parent behavior)
  final int? width;

  /// Alignment of the WebView content inside its container.
  /// Default: WebViewGravity.center
  final WebViewGravity? gravity;

  const WebViewConfig({
    this.backgroundColor = Colors.transparent,
    this.height,
    this.width,
    this.gravity = WebViewGravity.center,
  });
}
```

**`WebViewGravity` enum:**
```dart
 enum WebViewGravity { top, center, bottom }
```

### Integration example

In Flutter app, you embed the WebView using the plugin’s `webViewLoadUrl()` method. You can place it anywhere in a typical widget tree, such as inside a `Dialog`, `Column`, `Align`, `SizedBox`, etc.

```dart
 void webViewLoadUrl() async {
    // Option B: Set web-driven close callback
    clickioConsentSdk.setOnWebClose(() async {
      await Navigator.maybePop(context); // close the dialog
      await clickioConsentSdk.cleanup(); // cleanup resources
    });

    // Create the WebView widget
    final webView = clickioConsentSdk.webViewLoadUrl(
      url: 'https://example.com',
      webViewConfig: WebViewConfig(
        backgroundColor: Colors.lightBlueAccent,
        height: 600,
        width: 350,
        gravity: WebViewGravity.center,
      ),
    );

    // Display the WebView inside a Dialog
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
                // Option A: Custom close button
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    await Navigator.maybePop(context); // close dialog with releasing resources
                  },
                ),
                // Your WebView widget with provided WebViewConfig
                webView, 
              ],
            ),
          ),
    );
  }

  // Best practice: when removing the WebView, call cleanup() to release resources
  await clickioConsentSdk.cleanup();
```

#### Note: To close the overlay, either (a) add an on-screen close button that sets the flag to false, or (b) provide an SDK callback so the web content can request closing (recommended for web-driven close).

#### When removing, don't forget to call the appropriate methods and clean up delegates/handlers through SDK's `cleanup()` method that safely releases webview resources and detach handlers:

```dart
await clickioConsentSdk.cleanup();
```
---

## Running the Plugin Example App

To get started with the plugin example application, follow the simple steps below. This will help you set up and run the app on your local machine.

1. **Clone the repository:**

```bash
  git clone <repository-url>
  cd <repository-folder>/example
```

2. **Get dependencies:**

```bash
  flutter pub get
```

3. **Run the example app:**


```bash
  flutter run
```