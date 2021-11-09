import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/study_controller.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/util/util.dart';

final wordMapProvider = ChangeNotifierProvider.autoDispose((ref) => WordMap());

class WordMap extends ChangeNotifier {
  // { char: map { word , word data }}
  final map = <String, WordCategoryNotifier>{
    for (final alphaChar in alphabeta) alphaChar: WordCategoryNotifier()
  };

  String get wordCount {
    var sum = 0;

    for (var c in map.entries) sum += c.value.list.length;

    return sum.toString();
  }

  String get allWordCount {
    var sum = 0;

    for (var c in map.entries) for (var w in c.value.list) sum += w.count;

    return sum.toString();
  }

  // void clear() {
  //   map.clear();

  //   notifyListeners();
  // }

  void resetMap() {
    map.clear();
    map.addAll(
      {for (final alphaChar in alphabeta) alphaChar: WordCategoryNotifier()},
    );
  }

  void addWord(Word word) {
    final lowerCaseWord = word.word.toLowerCase();
    final firstChar = lowerCaseWord.substring(0, 1);

    // if (!map.containsKey(firstChar)) {
    //   map[firstChar] = [];
    // }

    final tempW =
        map[firstChar]!.list.where((element) => element.word == word.word);

    if (tempW.isEmpty) {
      map[firstChar]!.add(word);
    }

    map[firstChar]!
        .list
        .where((element) => element.word == lowerCaseWord)
        .first
        .count++;
    // tempW.first.count++;

    // notifyListeners();
  }

  void notify() => notifyListeners();

  String toJson() {
    final m = map.values
        .expand((element) => element.list)
        .map((e) => [e.id, e.count, e.know])
        .toList();

    return jsonEncode(m);
  }

  bool isKnow(String w) {
    if (w == ' ' || w.isEmpty) {
      return false;
    }

    final lowerCaseWord = w.toLowerCase();
    final wordCategory = map[w.toLowerCase().substring(0, 1)];

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

  Word? get(String w) {
    if (w == ' ' || w.isEmpty) {
      return null;
    }

    final lowerCaseWord = w.toLowerCase();
    final wordCategory = map[w.toLowerCase().substring(0, 1)];

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
}
