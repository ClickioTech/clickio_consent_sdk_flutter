# Changelog

## 1.0.4

### Changed
- Updated native SDK dependencies:
  - **Android:** Updated ClickioConsentSDK Android to `1.0.1`.
  - **iOS:** Updated ClickioConsentSDKManager to `1.0.11-rc`.

## 1.0.3

### Fixed
- Resolved an issue where the CMP dialog failed to appear on app launch when using DialogMode.defaultMode on Android.
- The dialog now displays correctly on first launch, including clean installations on new devices.


## 1.0.2

### Fixed
- Fixed scrolling behavior in custom WebView on iOS.
- Fixed issue with synchronizing consent data in custom WebView.

## 1.0.1

### Added
- New method `webViewLoadUrl()` to load a custom URL with applied consent.
- New flags in `getGoogleConsentMode()`.

### BREAKING CHANGES
- **MainActivity must now extend `FlutterFragmentActivity` on Android.**  
  The plugin internally uses a Fragment-based WebView, so a `FragmentActivity` context is required.  
  If your activity does not extend `FlutterFragmentActivity`, you may see errors in the log when opening the WebView.

## 1.0.0

### Added
- Initial release of the SDK.
- Example app demonstrating basic SDK usage and consent flow.
- Detailed documentation for setup and integration.
