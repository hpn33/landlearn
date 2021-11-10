import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/util/util.dart';

export 'model_exten.dart' show Util;

class WordCategoryNotifier extends ChangeNotifier {
  final List<WordNotifier> list = [];

  WordCategoryNotifier();

  void add(Word word) {
    final tempW = list.where((element) => element.word == word.word);

    if (tempW.isEmpty) {
      list.add(WordNotifier(word));
    }

    list.where((element) => element.word == word.word).first.count++;
  }

  void addNotifier(WordNotifier word) {
    final tempW = list.where((element) => element.word == word.word);

    if (tempW.isEmpty) {
      list.add(word);
    }

    list.where((element) => element.word == word.word).first.count++;
  }
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

  // List<WordData> wordDatas = [];
  // List<int> get wordIds => wordDatas.map((e) => e.id).toList();
  List<int> wordIds = [];

  List<WordNotifier> wordNotifiers = [];

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

    // wordDatas.clear();
    wordIds.clear();

    final List decoded = json.decode(data);

    decoded.forEach(
      (item) {
        final id = item[0] as int;
        // final count = item[1] as int;

        // bool know = false;
        // if (item.length >= 3) {
        //   know = item[2] as bool;
        // }

        wordIds.add(id);
        // wordDatas.add(WordData(id: id));
      },
    );
  }

  Future<void> getWordsFromDB(Database db) async {
    final wordsIn = await db.wordDao.getIn(wordIds: wordIds);

    wordNotifiers.clear();
    wordNotifiers.addAll(wordsIn.map((e) => WordNotifier(e)));

    for (final wordNotifier in wordNotifiers) {
      final firstChar = wordNotifier.word.toLowerCase().substring(0, 1);

      wordCategoris[firstChar]!.addNotifier(wordNotifier);
    }

    notify();
  }

  void notify() => notifyListeners();

  void updateData(String newData) {
    value = value.copyWith(data: newData);

    exportData();
  }
}

class WordData {
  int id = -1;
  int count = 0;
  bool know = false;
  String word = '';

  WordData({this.id = -1, this.count = 0, this.know = false, this.word = ''});
}
