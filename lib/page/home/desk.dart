import 'package:flutter/material.dart';

import 'content_view.dart';
import 'word_view/word_view.dart';

class DeskHomePage extends StatelessWidget {
  const DeskHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Row(
          children: [
            Expanded(child: WordView()),
            Expanded(child: ContentView()),
          ],
        ),
      ),
    );
  }
}
