import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/db/database.dart';

import 'models.dart';

final selectedContentIdProvider = StateProvider<int>((ref) => -1);

final _getContentStreamProvider = FutureProvider.autoDispose<Content?>((ref) {
  final db = ref.read(dbProvider);
  final selectedContent = ref.watch(selectedContentIdProvider).state;

  return db.contentDao.getSingleBy(id: selectedContent);
});

final getContentNotifierProvider = StateProvider.autoDispose<ContentNotifier?>(
  (ref) => ref.watch(_getContentStreamProvider).when(
        data: (data) {
          final contentNotifier = data == null ? null : ContentNotifier(data);

          if (contentNotifier != null) {
            contentNotifier.getWordsFromDB(ref.read(dbProvider));
          }

          return contentNotifier;
        },
        loading: () => null,
        error: (s, o) => null,
      ),
);

// final _getContentWordsStreamProvider = FutureProvider.autoDispose<List<Word>>(
//   (ref) {
//     final db = ref.read(dbProvider);
//     final contentNotifier = ref.watch(getContentNotifierProvider).state;

//     return db.wordDao.getIn(wordIds: contentNotifier!.wordIds);
//   },
// );

// final getContentWordsProvider = StateProvider.autoDispose<List<Word>>(
//   (ref) => ref.watch(_getContentWordsStreamProvider).when(
//         data: (data) => data,
//         loading: () => [],
//         error: (s, o) => [],
//       ),
// );

final textControllerProvider = ChangeNotifierProvider.autoDispose((ref) {
  // final contentData = ref.watch(studyControllerProvider).contentNotifier;
  final contentNotifier = ref.watch(getContentNotifierProvider).state;

  return TextEditingController(
    text: contentNotifier == null ? 'something Wrong' : contentNotifier.content,
  );
});

// final getWordsByAlphaCharProvider =
//     StateProvider.autoDispose.family<List<Word>, String>(
//   (ref, alphaChar) {
//     final words = ref.watch(studyControllerProvider).words;

//     return words
//         .where((element) => element.word.startsWith(alphaChar))
//         .toList();
//   },
// );

// final studyControllerProvider = Provider.autoDispose((ref) {
//   final contentData = ref.watch(getContentNotifierProvider).state;
//   // final words = ref.watch(getContentWordsProvider).state;

//   return StudyController(
//     contentNotifier: contentData,
//     // words: words
//   );
// });

// class StudyController {
//   final ContentNotifier? contentNotifier;
//   // final List<Word> words;
//   // final Map<String, WordCategoryNotifier> sortedWord = {
//   //   for (final alphaChar in alphabeta) alphaChar: WordCategoryNotifier()
//   // };

//   StudyController({this.contentNotifier
//       // , this.words = const []
//       }) {
//     // sortingWord();
//   }

//   // void sortingWord() {
//   //   for (final word in words) {
//   //     final firstChar = word.word.substring(0, 1);

//   //     sortedWord[firstChar]!.add(word);
//   //   }

//   //   sortedWord.forEach(
//   //     (key, value) => value.list.sort(
//   //       (a, b) => a.word.compareTo(b.word),
//   //     ),
//   //   );
//   // }
// }
