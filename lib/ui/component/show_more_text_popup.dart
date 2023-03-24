import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';

class ShowMoreTextPopup {
  double _popupWidth = 200.0;
  double _popupHeight = 200.0;
  double arrowHeight = 10.0;
  late OverlayEntry _entry;
  late String _text;
  late TextStyle _textStyle;
  late Offset _offset;
  late Rect _showRect;
  bool _isDownArrow = true;

  VoidCallback? dismissCallback;

  late Size _screenSize;

  late BuildContext context;
  late Color _backgroundColor;

  bool _isVisible = false;

  late BorderRadius _borderRadius;
  late EdgeInsetsGeometry _padding;

  ShowMoreTextPopup(
    this.context, {
    required double height,
    required double width,
    VoidCallback? onDismiss,
    Color? backgroundColor,
    required String text,
    TextStyle? textStyle,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    dismissCallback = onDismiss;
    _popupHeight = height;
    _popupWidth = width;
    _text = text;
    _textStyle = textStyle ??
        const TextStyle(
            fontWeight: FontWeight.normal, color: Color(0xFF000000));
    _backgroundColor = backgroundColor ?? const Color(0xFFFFA500);
    _borderRadius = borderRadius ?? BorderRadius.circular(10.0);
    _padding = padding ?? const EdgeInsets.all(4.0);
  }

  /// Shows a popup near a widget with key [widgetKey] .
  void showWithKey(GlobalKey widgetKey) {
    // get globalRect of widget with key [key]
    final renderBox =
        widgetKey.currentContext!.findRenderObject()! as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    final rect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      renderBox.size.width,
      renderBox.size.height,
    );

    show(rect);
  }

  /// Shows a popup near a widget with [rect].
  void show(Rect rect) {
    _showRect = rect;
    _screenSize = window.physicalSize / window.devicePixelRatio;

    // calculate position
    _offset = _calculateOffset(context);

    _entry = OverlayEntry(builder: (context) {
      return buildPopupLayout(_offset);
    });

    Overlay.of(context).insert(_entry);
    _isVisible = true;
  }

  /// Returns calculated widget offset using [context]
  Offset _calculateOffset(BuildContext context) {
    double dx = _showRect.left + _showRect.width / 2.0 - _popupWidth / 2.0;
    if (dx < 10.0) {
      dx = 10.0;
    }

    if (dx + _popupWidth > _screenSize.width && dx > 10.0) {
      double tempDx = _screenSize.width - _popupWidth - 10;
      if (tempDx > 10) dx = tempDx;
    }

    double dy = _showRect.top - _popupHeight;
    if (dy <= MediaQuery.of(context).padding.top + 10) {
      // not enough space above, show popup under the widget.
      dy = arrowHeight + _showRect.height + _showRect.top;
      _isDownArrow = false;
    } else {
      dy -= arrowHeight;
      _isDownArrow = true;
    }

    return Offset(dx, dy);
  }

  /// Builds Layout of popup for specific [offset]
  LayoutBuilder buildPopupLayout(Offset offset) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          dismiss();
        },
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: <Widget>[
              // triangle arrow
              Positioned(
                left: _showRect.left + _showRect.width / 2.0 - 7.5,
                top: _isDownArrow
                    ? offset.dy + _popupHeight
                    : offset.dy - arrowHeight,
                child: CustomPaint(
                  size: Size(15.0, arrowHeight),
                  painter: TrianglePainter(
                      isDownArrow: _isDownArrow, color: _backgroundColor),
                ),
              ),
              // popup content
              Positioned(
                left: offset.dx,
                top: offset.dy,
                child: Container(
                    padding: _padding,
                    width: _popupWidth,
                    height: _popupHeight,
                    decoration: BoxDecoration(
                        color: _backgroundColor,
                        borderRadius: _borderRadius,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFF808080),
                            blurRadius: 1.0,
                          ),
                        ]),
                    child: SingleChildScrollView(
                      child: Text(
                        _text,
                        style: _textStyle,
                      ),
                    )),
              )
            ],
          ),
        ),
      );
    });
  }

  /// Dismisses the popup
  void dismiss() {
    if (!_isVisible) {
      return;
    }

    _entry.remove();
    _isVisible = false;
    if (dismissCallback != null) {
      dismissCallback!();
    }
  }
}

/// [TrianglePainter] is custom painter for drawing a triangle for popup
/// to point specific widget
class TrianglePainter extends CustomPainter {
  final bool isDownArrow;
  final Color color;

  TrianglePainter({this.isDownArrow = true, required this.color});

  /// Draws the triangle of specific [size] on [canvas]
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final paint = Paint()
      ..strokeWidth = 2.0
      ..color = color
      ..style = PaintingStyle.fill;

    if (isDownArrow) {
      path
        ..moveTo(0.0, -1.0)
        ..lineTo(size.width, -1.0)
        ..lineTo(size.width / 2.0, size.height);
    } else {
      path
        ..moveTo(size.width / 2.0, 0.0)
        ..lineTo(0.0, size.height + 1)
        ..lineTo(size.width, size.height + 1);
    }

    canvas.drawPath(path, paint);
  }

  /// Specifies to redraw for [customPainter]
  @override
  bool shouldRepaint(CustomPainter customPainter) => true;
}
