import 'package:flutter/cupertino.dart';

enum ScreenSize { compact, medium, expanded }

extension SizeUtil on MediaQueryData {
  ScreenSize get screenSize {
    final width = size.width;

    if (width < 0.0) {
      throw Exception('screen width is negative');
    }

    if (width < 600) {
      return ScreenSize.compact;
    }

    if (width < 800) {
      return ScreenSize.medium;
    }

    return ScreenSize.expanded;
  }

  bool get isCompactScreen => screenSize == ScreenSize.compact;
  bool get isMediumScreen => screenSize == ScreenSize.medium;
  bool get isExpandedScreen => screenSize == ScreenSize.expanded;
}
