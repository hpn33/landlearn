import 'dart:convert';

import 'package:landlearn/page/study/models.dart';
import 'package:landlearn/service/db/database.dart';

extension Util on ContentNotifier {
  bool isKnow(String w) {
    if (w == ' ' || w.isEmpty) {
      return false;
    }

    final lowerCaseWord = w.toLowerCase();
    final wordCategory = wordCategoris[w.toLowerCase().substring(0, 1)];

    if (wordCategory == null) {
      return false;
    }

    final item =
        wordCategory.list.where((element) => element.word == lowerCaseWord);

    if (item.isEmpty) {
      return false;
    }

    return item.first.know;
  }

  // get(String w) {}
  Word? get(String w) {
    if (w == ' ' || w.isEmpty) {
      return null;
    }

    final lowerCaseWord = w.toLowerCase();
    final wordCategory = wordCategoris[w.toLowerCase().substring(0, 1)];

    if (wordCategory == null) {
      return null;
    }

    final item =
        wordCategory.list.where((element) => element.word == lowerCaseWord);

    if (item.isEmpty) {
      return null;
    }

    return item.first.value;
  }

  WordNotifier? getNotifier(String word) {
    final lowerCase = word.toLowerCase();
    final findedWord = words.where((element) => element.word == lowerCase);

    if (findedWord.isEmpty) {
      return null;
    }

    return findedWord.first;
  }

  String toJson() {
    final m = words.map((e) => [e.id, e.count, e.know]).toList();

    return jsonEncode(m);
  }

  void addWord(Word word) {
    words.add(WordNotifier(word));

    final firstChar = word.word.toLowerCase().substring(0, 1);

    wordCategoris[firstChar]!.add(word);
  }
}
