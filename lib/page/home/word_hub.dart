import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/home/word_view/word_view_controller.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/models/word_category_notifier.dart';
import 'package:landlearn/service/models/word_notifier.dart';
import 'package:landlearn/util/util.dart';

final wordHubProvider = Provider.autoDispose((ref) {
  final allWords = ref.watch(getAllWordsStateProvider).state;

  return WordHub(allWords);
});

class WordHub {
  final List<Word> words;

  final List<WordNotifier> _wordNotifiers = [];
  List<WordNotifier> get wordNotifiers => wordCategories.values
      .map((e) => e.list)
      .expand((element) => element)
      .toList();

  final Map<String, WordCategoryNotifier> wordCategories = {
    for (final alphaChar in alphabeta) alphaChar: WordCategoryNotifier(),
  };

  WordHub(this.words) {
    _wordNotifiers.addAll(words.map((e) => WordNotifier(e)));

    for (final wordNotifier in _wordNotifiers) {
      wordCategories[wordNotifier.word.substring(0, 1)]!
          .addNotifier(wordNotifier);
    }
  }
}
