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
}
