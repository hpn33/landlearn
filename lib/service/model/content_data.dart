import 'dart:convert';

import 'package:landlearn/page/hub_provider.dart';
import 'package:landlearn/service/model/word_data.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/util/util.dart';

class ContentData {
  late final Content content;
  final words = <WordData>[];

  Map<String, List<WordData>> get wordsSorted => {
        for (final char in alphabeta)
          char: words
              .where((element) => element.word.word.startsWith(char))
              .toList()
      };

  void init(Hub hub, Content e) {
    content = e;

    if (!e.data.startsWith('[')) {
      return;
    }

    final List decoded = json.decode(content.data);

    decoded.forEach((item) {
      final id = item[0] as int;
      final count = item[1] as int;

      final b = hub.words.value.where((e) => e.id == id);

      if (b.isNotEmpty) {
        words.add(
          WordData()
            ..word = b.first
            ..count = count,
        );
      }
    });

    words..sort((a, b) => a.word.word.compareTo(b.word.word));
  }
}
