import 'package:flutter/material.dart';
import 'package:landlearn/widget/content_status.dart';
import 'package:landlearn/widget/word_status.dart';

import 'content_view/content_view.dart';
import 'word_view/word_view.dart';

class DeskHomePage extends StatelessWidget {
  const DeskHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1140,
      child: Row(
        children: [
          const Expanded(flex: 5, child: WordView()),
          Expanded(flex: 3, child: _midColumn()),
          const Expanded(flex: 4, child: ContentView()),
        ],
      ),
    );
  }

  Widget _midColumn() {
    return Column(
      children: const [
        SizedBox(height: 20),
        ContentStatus(),
        WordStatus(),
      ],
    );
  }
}
