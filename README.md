# Clickio Consent SDK for Flutter

A Flutter plugin that wraps the native Clickio Consent SDK for Android and iOS, providing a unified API for managing user consent in compliance with GDPR, TCF, GPP, and other regulations.
 
1. [Requirements](#requirements)
2. [Installation](#installation)
3. [Quick Start](#quick-start)
4. [Setup and Usage](#setup-and-usage)
5. [Methods](#methods)
6. [Integration with Third-Party Libraries for Google Consent Mode](#integration-with-third-party-libraries-for-google-consent-mode)
7. [Integration with Third-Party Libraries When Google Consent Mode Is Disabled](#⚙️-integration-with-third-party-libraries-when-google-consent-mode-is-disabled)

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
  clickio_consent_sdk: ^1.0.0
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

### Initialize the SDK and Open Consent Window:

Replace `your_clickio_site_id` with your actual [**Site ID**](https://docs.clickio.com/books/clickio-consent-cmp/page/google-consent-mode-v2-implementation#bkmrk-access-the-template%3A).

```dart
final clickioConsentSdk = ClickioConsentSdk();
final config = Config(siteId: 'your_clickio_site_id');

Future<void> initializeSdk() async {
  await clickioConsentSdk.initialize(config: config);
  await clickioConsentSdk.setLogsMode(mode: LogsMode.verbose);
}
```

After initialization, open the consent window like this:

```dart
await clickioConsentSdk.openDialog(
  mode: DialogMode.resurfaceMode,
  showATTFirst: true,
  attNeeded: true,
);
```

✅ In this code, after successful initialization, the SDK will open the Consent Window, a transparent screen with a WebView containing the consent form.

---

## Setup and Usage

### App Tracking Transparency (ATT) Permission

`Clickio SDK` supports [three](#example-scenarios) distinct scenarios for handling ATT permissions If your app collects and shares user data with third parties for tracking across apps or websites, **you must**:

1. Add the [`NSUserTrackingUsageDescription`](https://developer.apple.com/documentation/BundleResources/Information-Property-List/NSUserTrackingUsageDescription) key in your `Info.plist`.
2. Choose an ATT permission handling strategy using the [`openDialog`](#opening-the-consent-dialog) method.

If you're managing ATT permissions manually and have already added [`NSUserTrackingUsageDescription`](https://developer.apple.com/documentation/BundleResources/Information-Property-List/NSUserTrackingUsageDescription), you can skip ATT integration here and just use the consent flow.

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
  showATTFirst: true,
  attNeeded: true,
);
```

### Parameters:
- `mode` - defines when the dialog should be shown. Possible values::
  - `DialogMode.defaultMode` –  Opens the dialog if GDPR applies and user hasn't given consent.
  - `DialogMode.resurface` – Always forces dialog to open, regardless of the user’s jurisdiction, allowing users to modify settings for GDPR compliance or to opt out under US regulations.
- `showATTFirst`: Show ATT prompt **before** consent dialog.
- `attNeeded`: Determines if ATT is required.

> 💡 If your app has it's own ATT Permission manager you just pass `false` in `showATTFirst` & `attNeeded` parameters and call your own ATT method. Keep in mind that in this case consent screen will be shown regardless given ATT Permission.

---

### Example Scenarios:

**1. Show ATT Permission first, then show Consent Dialog only if user has granted ATT Permission:**  
*(Apple recommended)*

```dart
await clickioConsentSdk.openDialog(
  mode: DialogMode.defaultMode,
  showATTFirst: true,
  attNeeded: true,
);
```

**2. Show Consent Dialog first, then show ATT Permission regardless user choice in the Consent Dialog:**

```dart
await clickioConsentSdk.openDialog(
  mode: DialogMode.defaultMode,
  showATTFirst: false,
  attNeeded: true,
);
```

**3. Show only Consent Dialog bypassing ATT Permission demonstration:**

```dart
await clickioConsentSdk.openDialog(
  mode: DialogMode.defaultMode,
  showATTFirst: false,
  attNeeded: false,
);
```

#### Note: we suggest you to use this approach only if you handle ATT Permission on your own.

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
Returns the Google Consent Mode v2 status if enabled. Otherwise returns `null`.

#### GoogleConsentStatus:
```dart
class GoogleConsentStatus {
  final bool analyticsStorageGranted;
  final bool adStorageGranted;
  final bool adUserDataGranted;
  final bool adPersonalizationGranted;

  GoogleConsentStatus({
    required this.analyticsStorageGranted,
    required this.adStorageGranted,
    required this.adUserDataGranted,
    required this.adPersonalizationGranted,
  });
}
```

- `analyticsStorageGranted` — Consent for analytics storage  
- `adStorageGranted` — Consent for ad storage  
- `adUserDataGranted` — Consent for processing user data for ads  
- `adPersonalizationGranted` — Consent for ad personalization  

---

Sure! Here's a **fancy documentation block** with headings, bullet points, and formatting for clarity and visual appeal:

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

If your project includes **any of these SDKs**:

- ClickioConsentSDK will **automatically send** Google Consent Mode flags **if integration is enabled**.
- ⚠️ Important:
  - You must **initialize the third-party SDKs before** interacting with ClickioConsentSDK.
  - ClickioConsentSDK **does not handle** SDK configuration—this is up to the developer.
- With logging enabled:
  - A **success log** confirms flag transmission.
  - Errors will be shown in logs if transmission fails.
- Keep your **Adjust**, **Airbridge**, or **AppsFlyer SDK** updated to ensure compatibility.

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

// ✅ Set Firebase Analytics consent flags
await FirebaseAnalytics.instance.setConsent(
  adStorageConsentGranted: adStorage,
  adUserDataConsentGranted: adUserData,
  adPersonalizationSignalsConsentGranted: adPersonalization,
  analyticsStorageConsentGranted: analyticsStorage
);
```

📚 [More about Consent Mode flags mapping with TCF and non-TCF purposes](https://docs.clickio.com/books/clickio-consent-cmp/page/google-consent-mode-v2-implementation#bkmrk-5.1.-tcf-mode)
