import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/models/word_category_notifier.dart';
import 'package:landlearn/service/models/word_notifier.dart';
import 'package:landlearn/util/util.dart';

final wordHubProvider = Provider((ref) => WordHub());

class WordHub extends ChangeNotifier {
  final List<Word> words = [];

  final List<WordNotifier> _wordNotifiers = [];
  List<WordNotifier> get wordNotifiers => wordCategories.values
      .map((e) => e.list)
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
        (e) => WordNotifier(e)..addListener(() => this.notifyListeners()),
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
    wordCategories.values.forEach((e) => e.list.clear());
    notifyListeners();
  }

  void notify() {
    wordCategories.values.forEach((e) => e.notify());

    notifyListeners();
  }

  void addWordNotifier(WordNotifier wordNotifier) {
    _wordNotifiers.add(
      wordNotifier..addListener(() => this.notifyListeners()),
    );

    wordCategories[wordNotifier.word.substring(0, 1)]!
        .addNotifier(wordNotifier);

    notify();
  }
}
