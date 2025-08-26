import 'package:flutter/material.dart';

import '../enums/enums.dart';

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
