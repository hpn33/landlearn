import 'package:flutter/material.dart';

import 'content_view/content_view.dart';
import 'word_view/word_view.dart';

class DeskHomePage extends StatelessWidget {
  const DeskHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1140,
      child: Row(
        children: const [
          Expanded(flex: 4, child: WordView()),
          Expanded(flex: 3, child: SingleChildScrollView(child: ContentView())),
        ],
      ),
    );
  }
}
