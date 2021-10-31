import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:landlearn/page/hub_provider.dart';
import 'package:landlearn/service/model/word_data.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/util/util.dart';

class ContentData {
  late final Content content;
  // final words = ValueNotifier(<WordData>[]);
  final words = <int, int>{}; //id, count

  ContentData(
      // Hub hub,
      this.content) {
    // hub.words.addListener(() => getWords(hub));

    // getWords(hub);
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

  void getWords() {
    if (!content.data.startsWith('[')) {
      return;
    }

    // words.value = [];
    words.clear();

    final List decoded = json.decode(content.data);
    // final tempList = <WordData>[];

    decoded.forEach((item) {
      final id = item[0] as int;
      final count = item[1] as int;

      words[id] = count;

      // final b = hub.words.value.where((e) => e.id == id);

      // if (b.isNotEmpty) {
      //   tempList.add(
      //     WordData()
      //       ..word = b.first
      //       ..count = count,
      //   );
      // }
    });

    // tempList..sort((a, b) => a.word.word.compareTo(b.word.word));

    // words.value = tempList;
  }
}
