// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:landlearn/page/hub_provider.dart';
// import 'package:landlearn/service/db/database.dart';
// import 'package:landlearn/service/model/content_data.dart';
// import 'package:landlearn/service/model/word_data.dart';

// import 'word_map.dart';

// final studyControllerProvider =
//     Provider.autoDispose((ref) => StudyController());

// class StudyController {
//   late ContentData contentData;

//   final contentObject = ValueNotifier<Content?>(null);

//   final editMode = ValueNotifier(false);

//   // late final wordsSorted = ValueNotifier(contentData.wordsSorted);
//   // void wordNotify() => wordsSorted.notifyListeners();

//   void init(BuildContext context, ContentData contentO) {
//     contentData = contentO;

//     // final db = context.read(dbProvider);
//     // db.contentDao
//     //     .watchingSingleBy(id: contentO.content.id)
//     //     .listen((event) => contentObject.value = event);

//     // db.wordDao.watchingThatIn(ids: contentO.content.data);
//   }

//   final _regex = RegExp("(?:(?![a-zA-Z])'|'(?![a-zA-Z])|[^a-zA-Z'])+");

//   Future<void> analyze(BuildContext context, String input) async {
//     final mapMap = context.read(wordMapProvider)..clear();
//     final wordList = input.split(_regex);
//     final hub = context.read(hubProvider);

//     for (var word in wordList) {
//       if (word.isEmpty) {
//         continue;
//       }

//       mapMap.addWord(await hub.getOrAddWord(word));
//     }

//     hub.db.contentDao.updateData(contentData.content, mapMap.toJson());
//   }

//   Future<void> toggleEditMode(
//       BuildContext context, TextEditingController textEditingController) async {
//     final hub = context.read(hubProvider);
//     final input = textEditingController.text;

//     if (editMode.value) {
//       if (contentData.content.content != input) {
//         await hub.repo.contents.updateContent(context, contentData, input);
//       }

//       contentData = ContentData(
//         hub,
//         contentData.content.copyWith(content: textEditingController.text),
//       );

//       await analyze(context, input);
//     }

//     editMode.value = !editMode.value;
//   }

//   void updateKnowWord(BuildContext context, WordData wordRow, int index) {
//     final db = context.read(dbProvider);

//     db.wordDao.updating(wordRow.word.copyWith(know: !wordRow.word.know));

//     wordsSorted.value.update(
//       wordsSorted.value.entries.elementAt(index).key,
//       (list) {
//         return [
//           for (final i in list)
//             if (i.word.word == wordRow.word.word)
//               WordData()
//                 ..count = i.count
//                 ..word = i.word.copyWith(know: !i.word.know)
//             else
//               i
//         ];
//       },
//     );

//     wordNotify();
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/model/content_data.dart';
import 'package:landlearn/util/util.dart';

final selectedContentIdProvider = StateProvider<int>((ref) => -1);

final _getContentStreamProvider = FutureProvider.autoDispose<Content?>((ref) {
  final db = ref.read(dbProvider);
  final selectedContent = ref.watch(selectedContentIdProvider).state;

  return db.contentDao.getSingleBy(id: selectedContent);
});

final getContentDataProvider = StateProvider.autoDispose<ContentData?>(
  (ref) => ref.watch(_getContentStreamProvider).when(
        data: (data) => data == null ? null : ContentData(data),
        loading: () => null,
        error: (s, o) => null,
      ),
);

final _getContentWordsStreamProvider = FutureProvider.autoDispose<List<Word>>(
  (ref) {
    final db = ref.read(dbProvider);
    final content = ref.watch(getContentDataProvider).state;

    return db.wordDao.getIn(wordIds: content!.wordIds);
  },
);

final getContentWordsProvider = StateProvider.autoDispose<List<Word>>(
  (ref) => ref.watch(_getContentWordsStreamProvider).when(
        data: (data) => data,
        loading: () => [],
        error: (s, o) => [],
      ),
);

final textControllerProvider = ChangeNotifierProvider.autoDispose((ref) {
  final contentData = ref.watch(studyControllerProvider).contentData;

  return TextEditingController(
    text: contentData == null ? 'something Wrong' : contentData.content.content,
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

final studyControllerProvider = Provider.autoDispose((ref) {
  final contentData = ref.watch(getContentDataProvider).state;
  final words = ref.watch(getContentWordsProvider).state;

  return StudyController(contentData: contentData, words: words);
});

class StudyController {
  final ContentData? contentData;
  final List<Word> words;
  final Map<String, WordCategoryNotifier> sortedWord = {
    for (final alphaChar in alphabeta) alphaChar: WordCategoryNotifier()
  };

  StudyController({this.contentData, this.words = const []}) {
    sortingWord();
  }

  void sortingWord() {
    for (final word in words) {
      final firstChar = word.word.substring(0, 1);

      sortedWord[firstChar]!.add(word);
    }

    sortedWord.forEach(
      (key, value) => value.list.sort(
        (a, b) => a.word.compareTo(b.word),
      ),
    );
  }
}

class WordCategoryNotifier extends ChangeNotifier {
  final List<WordNotifier> list = [];

  WordCategoryNotifier();

  void add(Word word) => list.add(WordNotifier(word));
}

class WordNotifier extends ChangeNotifier {
  final Word wordObject;

  final int id;
  final String word;
  bool know;

  WordNotifier(this.wordObject)
      : id = wordObject.id,
        word = wordObject.word,
        know = wordObject.know;

  void toggleKnow() {
    know = !know;

    notifyListeners();
  }
}
