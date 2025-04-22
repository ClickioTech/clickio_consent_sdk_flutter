# Clickio Consent SDK for Flutter

A Flutter plugin that wraps the native Clickio Consent SDK for Android and iOS, providing a unified API for managing user consent in compliance with GDPR, TCF, GPP, and other regulations.

## 📌 Requirements

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

## 📦 Installation

### Use this plugin as a library

#### Depend on it

Run this command:

<pre>
With Flutter:

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

Here’s a **Flutter Quick Start** section written in the same style as the native iOS and Android ones:

---

## 🔥 Quick Start

Here’s the minimal implementation to get started with the `clickio_consent_sdk` in a Flutter project.

### Import the SDK:

```dart
import 'package:clickio_consent_sdk/clickio_consent_sdk.dart';
```

### Initialize the SDK and Open Consent Window:

Replace `your_clickio_site_id` with your actual site ID.

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

✅ In this code, after successful initialization, the SDK will automatically open the Consent Window, a transparent screen with a WebView containing the consent form.

---

## 🛠 Setup and Usage

### App Tracking Transparency (ATT) Permission

If your app collects and shares user data with third parties for tracking across apps or websites, **you must**:

1. Add the `NSUserTrackingUsageDescription` key in your `Info.plist`.
2. Choose an ATT permission handling strategy using the `openDialog` method.

If you're managing ATT permissions manually and have already added `NSUserTrackingUsageDescription`, you can skip ATT integration here and just use the consent flow.

👉 See [ User Privacy and Data Use](https://developer.apple.com/app-store/user-privacy-and-data-use/) and [App Privacy Details](https://developer.apple.com/app-store/app-privacy-details/) for more details.

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
- `language` – Optional, 2-letter ISO 639-1 language code (e.g., 'en', 'de')

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
  mode: LogsMode.verbose, // or LogsMode.disabled
); 
```

- `mode` parameter defines whether logging is enabled or not:
    -   `LogsMode.disabled` – Disables logging, default value
    -   `LogsMode.verbose`  – Enables logging

---

### Checking Consent Scope

```dart
final scope = await clickioConsentSdk.getConsentScope();
```

Returns the applicable consent scope as String.

**Returns:**
- `"gdpr"` – GDPR applies
- `"us"` – US regulations apply
- `"out of scope"` – Neither applies

---

### Checking Consent State

```dart
final state = await clickioConsentSdk.getConsentState();
```

Determines the consent state based on the scope and force flag and returns ConsentState.

**Returns:**
- `notApplicable`
- `gdprNoDecision`
- `gdprDecisionObtained`
- `us`

---

### Checking Consent for a Purpose

```dart
final hasConsent = await clickioConsentSdk.getConsentForPurpose(
  purposeId: purposeId,
);
```

#### Parameters

- `purposeId` *(int)*: The numeric ID of the TCF purpose to check.

Verifies whether consent for a specific TCF purpose has been granted by using `IABTCF_PurposeConsents` string.

**For a vendor:**

```dart
final hasConsent = await clickioConsentSdk.getConsentForVendor(
  vendorId: 123,
);
```

---

## 🔐 Get Consent Strings

- `getTCString()`
- `getACString()`
- `getGPPString()`

```dart
final tcString = await clickioConsentSdk.getTCString();
```

---

## ✅ Get Consented Entities

These methods return stringified IDs for the respective categories:

- `getConsentedTCFVendors()`
- `getConsentedTCFLiVendors()`
- `getConsentedTCFPurposes()`
- `getConsentedTCFLiPurposes()`
- `getConsentedGoogleVendors()`
- `getConsentedOtherVendors()`
- `getConsentedOtherLiVendors()`
- `getConsentedNonTcfPurposes()`

---

## 📊 Google Consent Mode

Retrieve Google Consent Mode string:

```dart
final mode = await clickioConsentSdk.getGoogleConsentMode();
```

---
