import 'package:flutter/material.dart';
import 'package:landlearn/ui/component/content_status.dart';
import 'package:landlearn/ui/component/word_status.dart';

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
          Expanded(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  _topRow(),
                  const Expanded(child: WordView()),
                ],
              ),
            ),
          ),
          const Expanded(flex: 5, child: ContentView()),
        ],
      ),
    );
  }

  Widget _topRow() {
    return SizedBox(
      height: 120,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: const [
            Expanded(child: ContentStatus()),
            Expanded(child: WordStatus()),
          ],
        ),
      ),
    );
  }
}
