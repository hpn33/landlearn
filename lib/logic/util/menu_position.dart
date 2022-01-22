import 'package:flutter/material.dart';

RelativeRect buttonMenuPosition(BuildContext context) {
  // final bool isEnglish =
  //     LocalizedApp.of(context).delegate.currentLocale.languageCode == 'en';
  final RenderBox bar = context.findRenderObject() as RenderBox;
  final RenderBox overlay =
      Overlay.of(context)!.context.findRenderObject() as RenderBox;
  const Offset offset = Offset.zero;

  final RelativeRect position = RelativeRect.fromRect(
    Rect.fromPoints(
      bar.localToGlobal(
          // isEnglish
          //     ? bar.size.centerRight(offset)
          //     :
          bar.size.centerLeft(offset),
          ancestor: overlay),
      bar.localToGlobal(
          // isEnglish
          //     ? bar.size.centerRight(offset)
          //     :
          bar.size.centerLeft(offset),
          ancestor: overlay),
    ),
    offset & overlay.size,
  );

  return position;
}
