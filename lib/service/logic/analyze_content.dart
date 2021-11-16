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
Future<void> analyzeContent(
  Database db,
  ContentNotifier contentNotifier,
  WordHub wordHub,
) async {
  final wordExtractedFromContentText =
      contentNotifier.content.split(regex).map((e) => e.toLowerCase()).toList();

  final wordMap = collectAndCountWords(wordExtractedFromContentText);

  // check for add or get from db
  contentNotifier.clear();

  for (final wordDataRow in wordMap.entries) {
    for (final wordData in wordDataRow.value) {
      final wordNotifier =
          await getOrAddWord(db, wordHub, wordDataRow.key, wordData);

      wordNotifier.setContentNotifier(contentNotifier, wordData);

      contentNotifier.addWordNotifier(wordNotifier);
    }
  }

  // load word data of content to db
  final newData = contentNotifier.toJson();

  await db.contentDao.updateData(contentNotifier.value, newData);
  contentNotifier.updateData();

  contentNotifier.loadData(wordHub);
}

Map<String, List<WordData>> collectAndCountWords(List<String> words) {
  final wordMap = <String, List<WordData>>{
    for (final alpha in alphabeta) alpha: [],
  };

  // collect and count words
  for (final word in words) {
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

  return wordMap;
}

Future<WordNotifier> getOrAddWord(
  Database db,
  WordHub wordHub,
  String alphaChar,
  WordData wordData,
) async {
  final selection = wordHub.wordCategories[alphaChar]!.list
      .where((element) => element.word == wordData.word)
      .toList();

  if (selection.isEmpty) {
    final wordNotifier = WordNotifier(await db.wordDao.add(wordData.word));
    wordHub.addWordNotifier(wordNotifier);

    return wordNotifier;
  }

  return selection.first;
}
