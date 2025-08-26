# Changelog

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
