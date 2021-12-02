import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/models/content_hub.dart';
import 'package:landlearn/service/models/word_hub.dart';
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

    for (var item in decoded) {
      final id = item[0] as int;
      final count = item[1] as int;

      wordDatas.add(WordData(id: id, count: count));
    }
  }

  void updateData() {
    value = value.copyWith(data: toJson());

    exportData();
  }

  void updateContent(String newContent) {
    value = value.copyWith(content: newContent);
  }

  void clear() {
    wordDatas.clear();
    wordNotifiers.clear();

    for (var element in wordCategoris.values) {
      element.list.clear();
    }
  }

  void notify() => notifyListeners();
}

extension Flow on ContentNotifier {
  void loadData(WordHub wordHub) {
    wordNotifiers.clear();

    for (final wordData in wordDatas) {
      final selection =
          wordHub.wordNotifiers.where((element) => element.id == wordData.id);

      if (selection.isNotEmpty) {
        final wordNotifier = selection.first
          ..setContentNotifier(this, wordData);

        wordNotifiers.add(wordNotifier);
      }
    }

    // add to categories
    for (final wordNotifier in wordNotifiers) {
      final firstChar = wordNotifier.word.substring(0, 1);

      wordCategoris[firstChar]!.addNotifier(wordNotifier);
    }

    for (var element in wordCategoris.values) {
      element.sort();
    }

    notify();
  }
}

extension Get on ContentNotifier {
  int get wordCount => wordNotifiers.length;

  int get wordKnowCount =>
      wordNotifiers.where((element) => element.know).length;

  int get allWordCount {
    var sum = 0;

    for (var wordNotifier in wordNotifiers) {
      sum += wordNotifier.getContentCount(id);
    }

    return sum;
  }

  String get allWordCountString => allWordCount.toString();

  double get awarnessPercent {
    final ratio = (wordNotifiers.where((element) => element.know).length /
        wordNotifiers.length);

    if (ratio == 0.0 || ratio.toString() == 'NaN') {
      return 0.0;
    }

    return ratio * 100;
  }

  double get awarnessPercentOfAllWord {
    final count = wordNotifiers
        .where((element) => element.know)
        .map((e) => e.getContentCount(id));

    final reduce = count.isEmpty ? 0 : count.reduce((a, b) => a + b);
    final ratio = (reduce / allWordCount);

    if (ratio == 0.0 || ratio.toString() == 'NaN') {
      return 0.0;
    }

    return ratio * 100;
  }
}

extension Util on ContentNotifier {
  bool isKnow(String w) {
    final word = getWord(w);

    if (word == null) {
      return false;
    }

    return word.know;
  }

  Word? getWord(String word) {
    final wordNotifiers = getWordNotifier(word);

    if (wordNotifiers == null) {
      return null;
    }

    return wordNotifiers.value;
  }

  // TODO : optimize ( is slow )
  WordNotifier? getWordNotifier(String word) {
    if (word.isEmpty) {
      return null;
    }

    final cleanWord = word.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
    if (cleanWord.isEmpty) {
      return null;
    }

    final lowerCase = cleanWord.toLowerCase();
    final firstChar = lowerCase.characters.first;

    if (int.tryParse(firstChar) != null) {
      return null;
    }

    final category = wordCategoris[firstChar]!.list;
    final selection = category.where((element) => element.word == lowerCase);

    if (selection.isEmpty) {
      return null;
    }

    return selection.first;
  }

  String toJson() {
    final m = wordNotifiers
        .map((e) => [e.id, e.getContentCount(id), e.know])
        .toList();

    return jsonEncode(m);
  }

  void addWordNotifier(WordNotifier wordNotifier) {
    wordNotifiers.add(wordNotifier);

    final firstChar = wordNotifier.word.toLowerCase().substring(0, 1);

    wordCategoris[firstChar]!.addNotifier(wordNotifier);
  }
}

extension DB on ContentNotifier {
  Future<void> removeWithDB(WidgetRef ref) async {
    final db = ref.read(dbProvider);
    final contentHub = ref.read(contentHubProvider);

    await db.contentDao.remove(this);

    contentHub.remove(this);
  }
}
