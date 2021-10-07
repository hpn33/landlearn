import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/db/database.dart';

import '../../service/model/word_data.dart';

final wordMapProvider = ChangeNotifierProvider.autoDispose((ref) => WordMap());

class WordMap extends ChangeNotifier {
  // { char: map { word , word data }}
  final map = <String, List<WordData>>{};

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

  void clear() {
    map.clear();

    notifyListeners();
  }

  void addWord(Word word) {
    final w = word.word.toLowerCase();
    final firstC = w.substring(0, 1);

    if (!map.containsKey(firstC)) map[firstC] = [];

    final tempW = map[firstC]!.where((element) => element.word.word == w);
    if (tempW.isEmpty) map[firstC]!.add(WordData()..word = word);

    tempW.first.count++;

    notifyListeners();
  }

  String toJson() {
    final m = map.values
        .expand((element) => element)
        .map((e) => [e.word.id, e.count])
        .toList();

    return jsonEncode(m);
  }
}
