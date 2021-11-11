import 'package:flutter/foundation.dart';
import 'package:landlearn/service/db/database.dart';

import 'word_notifier.dart';

class WordCategoryNotifier extends ChangeNotifier {
  final List<WordNotifier> list = [];

  void add(Word word) => addNotifier(WordNotifier(word));

  void addNotifier(WordNotifier word) {
    final selection = list.where((element) => element.word == word.word);

    if (selection.isEmpty) {
      list.add(word);
    }

    final wordNotifier =
        list.where((element) => element.word == word.word).first;

    wordNotifier.addListener(() => this.notifyListeners());

    notifyListeners();
  }

  void sort() => list.sort((a, b) => a.word.compareTo(b.word));
}
