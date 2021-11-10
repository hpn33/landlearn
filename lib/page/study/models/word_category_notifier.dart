import 'package:flutter/foundation.dart';
import 'package:landlearn/service/db/database.dart';

import 'word_notifier.dart';

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
