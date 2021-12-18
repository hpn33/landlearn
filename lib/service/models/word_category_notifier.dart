import 'package:flutter/foundation.dart';

import 'word_notifier.dart';

class WordCategoryNotifier extends ChangeNotifier {
  final List<WordNotifier> words = [];

  // void add(Word word) => addNotifier(WordNotifier(word));

  void addNotifier(WordNotifier word) {
    final selection = words.where((element) => element.word == word.word);

    if (selection.isEmpty) {
      words.add(word);
    }

    final wordNotifier =
        words.where((element) => element.word == word.word).first;

    wordNotifier.addListener(() => notifyListeners());

    notifyListeners();
  }

  void sort() => words.sort((a, b) => a.word.compareTo(b.word));

  void notify() => notifyListeners();

  void addAll(List<WordNotifier> list) {
    for (final word in list) {
      addNotifier(word);
    }
  }
}

extension Gets on WordCategoryNotifier {
  int get length => words.length;
  int get knowCount => words.where((element) => element.know).length;
}
