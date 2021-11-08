import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/util/util.dart';

import '../../service/model/word_data.dart';

final wordMapProvider = ChangeNotifierProvider.autoDispose((ref) => WordMap());

class WordMap extends ChangeNotifier {
  // { char: map { word , word data }}
  final map = <String, List<WordData>>{
    for (final alphaChar in alphabeta) alphaChar: []
  };

  String get wordCount {
    var sum = 0;

    for (var c in map.entries) sum += c.value.length;

    return sum.toString();
  }

  String get allWordCount {
    var sum = 0;

    for (var c in map.entries) for (var w in c.value) sum += w.count;

    return sum.toString();
  }

  // void clear() {
  //   map.clear();

  //   notifyListeners();
  // }

  void resetMap() {
    map.clear();
    map.addAll({for (final alphaChar in alphabeta) alphaChar: []});
  }

  void addWord(Word word) {
    final lowerCaseWord = word.word.toLowerCase();
    final firstChar = lowerCaseWord.substring(0, 1);

    // if (!map.containsKey(firstChar)) {
    //   map[firstChar] = [];
    // }

    final tempW =
        map[firstChar]!.where((element) => element.word.word == word.word);

    if (tempW.isEmpty) {
      map[firstChar]!.add(WordData()..word = word);
    }

    map[firstChar]!
        .where((element) => element.word.word == lowerCaseWord)
        .first
        .count++;
    // tempW.first.count++;

    // notifyListeners();
  }

  void notify() => notifyListeners();

  String toJson() {
    final m = map.values
        .expand((element) => element)
        .map((e) => [e.word.id, e.count, e.word.know])
        .toList();

    return jsonEncode(m);
  }

  bool isKnow(String w) {
    if (w == ' ' || w.isEmpty) {
      return false;
    }

    final lowerCaseWord = w.toLowerCase();
    final list = map[w.toLowerCase().substring(0, 1)];

    if (list == null) {
      return false;
    }

    final item = list.where((element) => element.word.word == lowerCaseWord);

    if (item.isEmpty) {
      return false;
    }

    return item.first.word.know;
  }

  Word? get(String w) {
    if (w == ' ' || w.isEmpty) {
      return null;
    }

    final lowerCaseWord = w.toLowerCase();
    final list = map[w.toLowerCase().substring(0, 1)];

    if (list == null) {
      return null;
    }

    final item = list.where((element) => element.word.word == lowerCaseWord);

    if (item.isEmpty) {
      return null;
    }

    return item.first.word;
  }
}
