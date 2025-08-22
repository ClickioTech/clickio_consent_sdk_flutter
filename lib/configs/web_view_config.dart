import 'package:flutter/material.dart';

import '../enums/enums.dart';

class WebViewConfig {
  // Default value - transparent, example of value: 0xFFFF0000 or Colors.white
  final Color? backgroundColor;

  // Value in px, default value (-1) = match parent (max size)
  final int? height;

  // Value in px, default value (-1) = match parent (max size)
  final int? width;

  final WebViewGravity? gravity;

  const WebViewConfig({
    this.backgroundColor = Colors.transparent,
    this.height,
    this.width,
    this.gravity = WebViewGravity.center,
  });
}
