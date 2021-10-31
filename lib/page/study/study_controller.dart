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

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/model/content_data.dart';

final _getContentStreamProvider =
    StreamProvider.autoDispose.family<Content?, int>((ref, id) {
  final db = ref.read(dbProvider);

  return db.contentDao.watchingSingleBy(id: id);
});

final getContentProvider =
    StateProvider.autoDispose.family<ContentData?, int>((ref, id) {
  return ref.watch(_getContentStreamProvider(id)).when(
        data: (data) => data == null ? null : ContentData(data),
        loading: () => null,
        error: (s, o) => null,
      );
});

final _getContentWordsStreamProvider =
    StreamProvider.autoDispose.family<List<Word>, int>((ref, id) {
  final db = ref.read(dbProvider);

  final content = ref.watch(getContentProvider(id)).state;

  return db.wordDao.watchingIn(wordIds: content!.words.keys);
});

final getContentWordsProvider =
    StateProvider.autoDispose.family<List<Word>, int>((ref, id) {
  return ref.watch(_getContentWordsStreamProvider(id)).when(
        data: (data) => data,
        loading: () => [],
        error: (s, o) => [],
      );
});
