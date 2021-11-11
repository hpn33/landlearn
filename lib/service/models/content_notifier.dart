import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:landlearn/page/home/word_hub.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/models/word_data.dart';
import 'package:landlearn/util/util.dart';

import 'word_category_notifier.dart';
import 'word_notifier.dart';

class ContentNotifier extends ValueNotifier<Content> {
  ContentNotifier(Content content) : super(content) {
    exportData();
  }

  int get id => value.id;
  String get title => value.title;
  String get content => value.content;
  String get data => value.data;

  final wordDatas = <WordData>[];
  final wordNotifiers = <WordNotifier>[];
  final wordCategoris = <String, WordCategoryNotifier>{
    for (final alphaChar in alphabeta) alphaChar: WordCategoryNotifier()
  };

  void exportData() {
    if (!data.startsWith('[')) {
      return;
    }

    wordDatas.clear();

    final List decoded = json.decode(data);

    decoded.forEach(
      (item) {
        final id = item[0] as int;
        final count = item[1] as int;

        wordDatas.add(WordData(id: id, count: count));
      },
    );
  }

  void updateData() {
    value = value.copyWith(data: this.toJson());

    exportData();
  }

  void loadData(WordHub wordHub) {
    wordNotifiers.clear();

    for (final wordData in wordDatas) {
      final selection =
          wordHub.wordNotifiers.where((element) => element.id == wordData.id);

      if (selection.isNotEmpty) {
        final wordNotifier = selection.first
          ..addListener(() => this.notifyListeners())
          ..contentCount = wordData.count;

        wordNotifiers.add(wordNotifier);
      }
    }

    // add to categories
    for (final wordNotifier in wordNotifiers) {
      final firstChar = wordNotifier.word.substring(0, 1);

      wordCategoris[firstChar]!.addNotifier(wordNotifier);
    }

    wordCategoris.values.forEach((element) => element.sort());

    notifyListeners();
  }

  void updateContent(String newContent) {
    value = value.copyWith(content: newContent);
  }

  void clear() {
    wordDatas.clear();
    wordNotifiers.clear();
    wordCategoris.values.forEach((element) => element.list.clear());
  }
}

extension Get on ContentNotifier {
  String get wordCount {
    var sum = 0;

    for (var category in wordCategoris.values) {
      sum += category.list.length;
    }

    return sum.toString();
  }

  String get allWordCount {
    var sum = 0;

    for (var wordNotifier in wordNotifiers) {
      sum += wordNotifier.contentCount;
    }

    return sum.toString();
  }

  double get awarnessPercent {
    final ratio = (wordNotifiers.where((element) => element.know).length /
        wordNotifiers.length);

    if (ratio == 0) {
      return 0;
    }

    return ratio * 100;
  }
}

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
    final m = wordNotifiers.map((e) => [e.id, e.contentCount, e.know]).toList();

    return jsonEncode(m);
  }

  void addWordNotifier(WordNotifier wordNotifier) {
    wordNotifiers.add(wordNotifier);

    final firstChar = wordNotifier.word.toLowerCase().substring(0, 1);

    wordCategoris[firstChar]!.addNotifier(wordNotifier);
  }
}
