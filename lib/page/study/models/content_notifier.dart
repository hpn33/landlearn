import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:landlearn/page/study/models/model_exten.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/util/util.dart';

import 'word_category_notifier.dart';
import 'word_notifier.dart';

export 'model_exten.dart' show Util;

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

  Future<void> getWordsFromDB(List<WordNotifier> wordOfDB) async {
    wordNotifiers.clear();

    for (final id in wordIds) {
      final selection = wordOfDB.where((element) => element.id == id);

      if (selection.isNotEmpty) {
        wordNotifiers.add(selection.first);
      }
    }

    for (final wordNotifier in wordNotifiers) {
      final firstChar = wordNotifier.word.substring(0, 1);

      wordCategoris[firstChar]!.addNotifier(wordNotifier);
    }

    notify();
  }

  void notify() => notifyListeners();

  void updateData() {
    value = value.copyWith(data: this.toJson());

    exportData();
  }
}

// extension DBUtil on ContentNotifier {

//   Future<void> updateDataToDB(Database db) async {
//     await db.contentDao.updateData(value, toJson());

//     value = value.copyWith(data: this.toJson());

//     exportData();
//   }
// }
