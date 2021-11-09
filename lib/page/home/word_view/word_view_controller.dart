import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/db/database.dart';

final wordViewControllerProvider =
    Provider.autoDispose((ref) => WordViewController());

class WordViewController {}

final getAllWordsFutureProvider =
    FutureProvider((ref) => ref.read(dbProvider).wordDao.getAll());

final getAllWordsProvider = StateProvider<List<Word>>(
  (ref) => ref.watch(getAllWordsFutureProvider).when(
        data: (data) => data,
        loading: () => [],
        error: (s, o) => [],
      ),
);

// final getWordWithProvider =
//     Provider.family<List<Word>, String>((ref, alphaChar) {
//   final words = ref.watch(getAllWordsProvider).state;

//   return (words.where((element) => element.word.startsWith(alphaChar)).toList()
//     ..sort((a, b) => a.word.compareTo(b.word)));
// });

// final sortedWordProvider = StateProvider((ref) {
//   final words = ref.watch(wordsListProvider).state;

//   final a = <String, List<Word>>{};

//   for (final char in alphabeta) {
//     final selectedWord = words.where(
//       (element) => element.word.startsWith(char),
//     );

//     for (final word in selectedWord) {
//       if (!a.containsKey(char)) {
//         a[char] = [];
//       }

//       a[char]!.add(word);
//     }
//   }

//   a.forEach(
//     (key, value) => a[key] = value..sort((a, b) => a.word.compareTo(b.word)),
//   );

//   return a;
// });
