import 'dart:convert';

import 'package:landlearn/service/db/database.dart';

class ContentData {
  late final Content content;
  final words = <WordObject>[];

  List<int> get wordIds => words.map((e) => e.id).toList();

  ContentData(this.content) {
    getWords();
  }

  // Map<String, List<WordData>> get wordsSorted => {
  //       for (final char in alphabeta)
  //         char: words.value
  //             .where((element) => element.word.word.startsWith(char))
  //             .toList()
  //     };

  // double get awarnessPercent =>
  //     ((words.value.where((element) => element.word.know).length /
  //             words.value.length) *
  //         100);

  double get awarnessPercent =>
      (words.where((element) => element.know).length / words.length) * 100;

  void getWords() {
    if (!content.data.startsWith('[')) {
      return;
    }

    words.clear();

    final List decoded = json.decode(content.data);

    decoded.forEach(
      (item) {
        final id = item[0] as int;
        final count = item[1] as int;

        bool know = false;
        if (item.length >= 3) {
          know = item[2] as bool;
        }

        words.add(WordObject(id, count, know));
      },
    );
  }
}

class WordObject {
  final int id;
  int count = 0;
  bool know = false;

  WordObject(this.id, this.count, this.know);
}
