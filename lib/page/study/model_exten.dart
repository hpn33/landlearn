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

  String toJson() {
    final m = words.map((e) => [e.id, e.count, e.know]).toList();

    return jsonEncode(m);
  }

  void addWord(Word word) {
    final lowerCaseWord = word.word.toLowerCase();
    final firstChar = lowerCaseWord.substring(0, 1);

    // if (!map.containsKey(firstChar)) {
    //   map[firstChar] = [];
    // }

    final tempW = wordCategoris[firstChar]!
        .list
        .where((element) => element.word == word.word);

    if (tempW.isEmpty) {
      wordCategoris[firstChar]!.add(word);
    }

    wordCategoris[firstChar]!
        .list
        .where((element) => element.word == lowerCaseWord)
        .first
        .count++;
    // tempW.first.count++;

    // notifyListeners();
  }
}
