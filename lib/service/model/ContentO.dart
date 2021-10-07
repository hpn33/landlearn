import 'dart:convert';

import 'package:landlearn/page/hub_provider.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/util/util.dart';

class ContentO {
  late final Content content;
  final words = <Word>[];

  Map<String, List<Word>> get wordsSorted => {
        for (final char in alphabeta)
          char: words.where((element) => element.word.startsWith(char)).toList()
      };

  void init(Hub hub, Content e) {
    content = e;

    if (!e.data.startsWith('[')) {
      return;
    }

    final List decoded = json.decode(content.data);

    decoded.forEach((id) {
      final b = hub.words.value.where((e) => e.id == (id as int));

      if (b.isNotEmpty) {
        words.add(b.first);
      }
    });

    words..sort((a, b) => a.word.compareTo(b.word));
  }
}
