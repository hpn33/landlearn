import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/util/util.dart';

export 'model_exten.dart' show Util;

class WordCategoryNotifier extends ChangeNotifier {
  final List<WordNotifier> list = [];

  WordCategoryNotifier();

  void add(Word word) => list.add(WordNotifier(word));
  void addNotifier(WordNotifier word) => list.add(word);
}

class WordNotifier extends ValueNotifier<Word> {
  int get id => value.id;
  String get word => value.word;
  bool get know => value.know;

  int count = 0;

  WordNotifier(Word wordObject) : super(wordObject);

  void toggleKnow() {
    value = value.copyWith(know: !know);

    notifyListeners();
  }
}

class ContentNotifier extends ValueNotifier<Content> {
  ContentNotifier(Content content) : super(content) {
    exportData();
  }

  int get id => value.id;
  String get title => value.title;
  String get content => value.content;
  String get data => value.data;

  List<WordData> wordDatas = [];
  List<int> get wordIds => wordDatas.map((e) => e.id).toList();

  List<WordNotifier> words = [];
  // Map<String, WordCategoryNotifier> sortedWords = {};

  final Map<String, WordCategoryNotifier> wordCategoris = {
    for (final alphaChar in alphabeta) alphaChar: WordCategoryNotifier()
  };

  String get wordCount {
    var sum = 0;

    for (var category in wordCategoris.values) sum += category.list.length;

    return sum.toString();
  }

  String get allWordCount {
    var sum = 0;

    for (var category in wordCategoris.values)
      for (var wordNotifier in category.list) sum += wordNotifier.count;

    return sum.toString();
  }

  void exportData() {
    if (!data.startsWith('[')) {
      return;
    }

    wordDatas.clear();

    final List decoded = json.decode(data);

    decoded.forEach(
      (item) {
        final id = item[0] as int;
        // final count = item[1] as int;

        // bool know = false;
        // if (item.length >= 3) {
        //   know = item[2] as bool;
        // }

        wordDatas.add(WordData(id));
      },
    );
  }

  void getWordsFromDB(Database db) async {
    final wordsIn = await db.wordDao.getIn(wordIds: wordIds);

    words.addAll(wordsIn.map((e) => WordNotifier(e)));

    for (final word in words) {
      wordCategoris[word.word.substring(0, 1)]!.addNotifier(word);
    }
  }
}

class WordData {
  final int id;
  int count = 0;
  bool know = false;

  WordData(this.id, {this.count = 0, this.know = false});
}
