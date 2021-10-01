import 'package:flutter/material.dart';

class WordView extends StatelessWidget {
  const WordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: words(context),
    );
  }

  Widget words(BuildContext context) {
    // final words = Hive.box<WordObj>('words').values.toList()
    //   ..sort((a, b) => a.word.compareTo(b.word));

    return Column(
      children: [
        Text('Words'),
        Divider(),
        Expanded(
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (final word in []) Text('word.word'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
