import 'package:flutter/material.dart';

Widget ti({required String text, bool show = true}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      Container(
        width: 2,
        height: 5,
        color: show ? Colors.grey : null,
      ),
    ],
  );
}
