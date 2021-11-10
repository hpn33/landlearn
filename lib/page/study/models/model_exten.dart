import 'dart:convert';

import 'package:landlearn/service/db/database.dart';

import 'content_notifier.dart';
import 'word_notifier.dart';

extension Util on ContentNotifier {
  bool isKnow(String w) {
    final word = get(w);

    if (word == null) {
      return false;
    }

    return word.know;
  }

  Word? get(String word) {
    final wordNotifiers = getNotifier(word);

    if (wordNotifiers == null) {
      return null;
    }

    return wordNotifiers.value;
  }

  WordNotifier? getNotifier(String word) {
    if (word.isEmpty) {
      return null;
    }

    final lowerCase = word.toLowerCase();
    final selection = wordCategoris[lowerCase.substring(0, 1)]!
        .list
        .where((element) => element.word == lowerCase);

    if (selection.isEmpty) {
      return null;
    }

    return selection.first;
  }

  String toJson() {
    final m = wordNotifiers.map((e) => [e.id, e.count, e.know]).toList();

    return jsonEncode(m);
  }

  void addWord(Word word) => addWordNotifier(WordNotifier(word));

  void addWordNotifier(WordNotifier wordNotifier) {
    wordNotifiers.add(wordNotifier);

    final firstChar = wordNotifier.word.toLowerCase().substring(0, 1);

    wordCategoris[firstChar]!.addNotifier(wordNotifier);
  }
}
