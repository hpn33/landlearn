import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/models/word_hub.dart';
import 'package:landlearn/page/study/study_controller.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/models/word_category_notifier.dart';
import 'package:landlearn/service/models/word_data.dart';
import 'package:landlearn/service/models/word_notifier.dart';
import 'package:landlearn/service/models/content_notifier.dart';
import 'package:landlearn/util/util.dart';

/// TODO:  goal: improve data flow in study page
/// refactor
///
/// first load all needed data - content and words
///
/// better refresh
/// faster load
///
/// when change content and remove word
/// the word not remove from word of content (wordmap maybe)
///
/// get all word and check with saved word
/// any that not was there add to add list
/// and add to database
///
/// study managment
/// manager content text and word of content
/// on edit
/// update word

class StudyPage extends HookWidget {
  static final editModeProvider = StateProvider((ref) => false);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          topBar(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: contentView(),
                ),
                Expanded(
                  child: wordOfContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget contentView() {
    return HookBuilder(builder: (context) {
      final textController = useProvider(textControllerProvider);
      final editMode = useProvider(editModeProvider).state;
      final contentNotifier = useProvider(selectedContentStateProvider).state!;

      useListenable(contentNotifier);

      return SingleChildScrollView(
        child: editMode
            ? TextField(
                controller: textController,
                minLines: 20,
                maxLines: 1000,
              )
            // : Text(textController.text),
            : RichText(
                text: TextSpan(
                  children: [
                    for (final paragh in textController.text.split('\n')) ...[
                      TextSpan(
                        children: [
                          for (final word in paragh.split(_regex))
                            WidgetSpan(
                              child: HookBuilder(
                                builder: (context) {
                                  final wordNotifier =
                                      contentNotifier.getNotifier(word);

                                  useListenable(
                                      wordNotifier ?? ChangeNotifier());

                                  if (wordNotifier == null) {
                                    return Text('($word)');
                                  }

                                  return InkWell(
                                    onTap: () {
                                      wordNotifier.toggleKnowToDB(context);
                                    },
                                    child: Text(
                                      word + ' ',
                                      style: TextStyle(
                                        color: wordNotifier.know
                                            ? Colors.green
                                            : Colors.black,
                                        decoration: wordNotifier.know
                                            ? TextDecoration.underline
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                      TextSpan(text: '\n'),
                    ],
                  ],
                ),
              ),
      );
    });
  }

  Widget wordOfContent() {
    // TODO: refresh word by word
    // or section section
    // - [x] update word know state
    // - [ ] remove on update
    return HookBuilder(builder: (context) {
      final contentNotifier = useProvider(selectedContentStateProvider).state!;
      useListenable(contentNotifier);

      final wordCategoris = contentNotifier.wordCategoris;

      return SingleChildScrollView(
        child: Column(
          children: [
            for (final alphaChar in alphabeta)
              Card(
                child: Column(
                  children: [
                    Text(alphaChar),
                    Divider(),
                    Wrap(
                      children: [
                        for (final wordRow in wordCategoris[alphaChar]!.list)
                          wordCard(wordCategoris[alphaChar]!, wordRow),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget wordCard(
      WordCategoryNotifier wordCategory, WordNotifier wordNotifier) {
    return HookBuilder(
      builder: (context) {
        useListenable(wordNotifier);

        final contentNotifier =
            context.read(selectedContentStateProvider).state!;

        final contentCount = wordNotifier.getContentCount(contentNotifier.id);

        return Card(
          color: wordNotifier.know ? Colors.green[100] : null,
          child: InkWell(
            onTap: () {
              wordNotifier.toggleKnowToDB(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                '${wordNotifier.word} $contentCount',
                style: TextStyle(
                  fontSize: 12.0 + contentCount,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget topBar() {
    return HookBuilder(
      builder: (context) {
        final editMode = useProvider(editModeProvider);
        final contentNotifier =
            useProvider(selectedContentStateProvider).state!;

        useListenable(contentNotifier);

        return Material(
          elevation: 6,
          child: Row(
            children: [
              BackButton(),
              Text(
                'text word\n${contentNotifier.allWordCount}',
                textAlign: TextAlign.center,
              ),
              Text(
                'word count\n${contentNotifier.wordCount}',
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                child: Text('analyze'),
                onPressed: () => analyze(context),
              ),
              ElevatedButton(
                child: Text(editMode.state ? 'done' : 'edit'),
                onPressed: () async {
                  final contentNotifier =
                      context.read(selectedContentStateProvider).state!;

                  final textController = context.read(textControllerProvider);

                  if (textController.text != contentNotifier.content) {
                    await context.read(dbProvider).contentDao.updateContent(
                          contentNotifier.value,
                          textController.text,
                        );

                    contentNotifier.updateContent(textController.text);
                  }

                  editMode.state = !editMode.state;
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// extract work from content text
  /// remove dub
  ///
  /// check for add or get
  ///
  /// update
  ///
  /// ready to use
  void analyze(BuildContext context) async {
    final contentNotifier = context.read(selectedContentStateProvider).state!;
    final wordHub = context.read(wordHubProvider);

    final db = context.read(dbProvider);
    final wordMap = <String, List<WordData>>{
      for (final alpha in alphabeta) alpha: [],
    };

    final wordExtractedFromContentText = contentNotifier.content
        .split(_regex)
        .map((e) => e.toLowerCase())
        .toList();

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
      final wordNotifier = await getOrAddWord(db, allWordOnDB, wordData);

      contentNotifier.addWordNotifier(wordNotifier);
    }

    // load word
    final newData = contentNotifier.toJson();

    // if (contentNotifier.data != newData) {
    await db.contentDao.updateData(contentNotifier.value, newData);
    contentNotifier.updateData();
    // }

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
}

final _regex = RegExp("(?:(?![a-zA-Z])'|'(?![a-zA-Z])|[^a-zA-Z'])+");
