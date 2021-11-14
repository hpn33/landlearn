import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/models/content_notifier.dart';
import 'package:landlearn/service/models/word_data.dart';
import 'package:landlearn/service/models/word_hub.dart';
import 'package:landlearn/service/models/word_notifier.dart';
import 'package:landlearn/util/util.dart';

/// extract work from content text
/// remove dub
///
/// check for add or get
///
/// update
///
/// ready to use
void analyzeContent(
  Database db,
  ContentNotifier contentNotifier,
  WordHub wordHub,
) async {
  final wordMap = <String, List<WordData>>{
    for (final alpha in alphabeta) alpha: [],
  };

  final wordExtractedFromContentText =
      contentNotifier.content.split(regex).map((e) => e.toLowerCase()).toList();

  // collect and count words
  for (final word in wordExtractedFromContentText) {
    if (word.isEmpty) {
      continue;
    }

    final category = wordMap[word.substring(0, 1)]!;

    final selection = category.where((element) => element.word == word);

    if (selection.isEmpty) {
      category.add(WordData(word: word));
    }

    category.where((element) => element.word == word).first.count++;
  }

  // check for add or get from db
  final allWordOnDB = wordHub.wordNotifiers;
  contentNotifier.clear();

  for (final wordData in wordMap.values.expand((element) => element)) {
    final wordNotifier = await getOrAddWord(db, allWordOnDB, wordData)
      ..setContentNotifier(contentNotifier, wordData);

    contentNotifier.addWordNotifier(wordNotifier);
  }

  // load word
  final newData = contentNotifier.toJson();

  await db.contentDao.updateData(contentNotifier.value, newData);
  contentNotifier.updateData();

  contentNotifier.loadData(wordHub);
}

Future<WordNotifier> getOrAddWord(
  Database db,
  List<WordNotifier> allWordInDB,
  WordData wordData,
) async {
  final selection =
      allWordInDB.where((element) => element.word == wordData.word).toList();

  if (selection.isEmpty) {
    return WordNotifier(await db.wordDao.add(wordData.word));
  }

  return selection.first;
}
