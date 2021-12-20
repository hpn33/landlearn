import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/service/db/database.dart';
import 'package:landlearn/logic/util/util.dart';

import 'word_category_notifier.dart';
import 'word_notifier.dart';

final wordHubProvider = ChangeNotifierProvider((ref) => WordHub());

class WordHub extends ChangeNotifier {
  final List<Word> words = [];

  final List<WordNotifier> _wordNotifiers = [];
  List<WordNotifier> get wordNotifiers => wordCategories.values
      .map((e) => e.words)
      .expand((element) => element)
      .toList();

  final Map<String, WordCategoryNotifier> wordCategories = {
    for (final alphaChar in alphabeta) alphaChar: WordCategoryNotifier(),
  };

  // functions

  /// load with all words in db
  /// because clear prevs data
  void load([List<Word>? newWords]) {
    if (newWords != null) {
      words.clear();
      words.addAll(newWords);
    }

    _wordNotifiers.addAll(
      words.map(
        (e) => WordNotifier(e)..addListener(() => notifyListeners()),
      ),
    );

    for (final wordNotifier in _wordNotifiers) {
      wordCategories[wordNotifier.word.substring(0, 1)]!
          .addNotifier(wordNotifier);
    }
  }

  void clear() {
    words.clear();
    _wordNotifiers.clear();
    for (var e in wordCategories.values) {
      e.words.clear();
    }
    notifyListeners();
  }

  void notify() {
    for (var e in wordCategories.values) {
      e.notify();
    }

    notifyListeners();
  }

  void addWordNotifier(WordNotifier wordNotifier) {
    _wordNotifiers.add(
      wordNotifier..addListener(() => notifyListeners()),
    );

    wordCategories[wordNotifier.word.substring(0, 1)]!
        .addNotifier(wordNotifier);

    notify();
  }
}
