import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/home/word_hub.dart';
import 'package:landlearn/page/study/models/model_exten.dart';
import 'package:landlearn/page/study/study_controller.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/util/util.dart';

import 'models/word_category_notifier.dart';
import 'models/word_data.dart';
import 'models/word_notifier.dart';

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
    // load data
    useEffect(() {
      context.read(getContentNotifierProvider);
    }, []);

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

      final contentNotifier = useProvider(getContentNotifierProvider).state;

      useListenable(contentNotifier ?? ChangeNotifier());

      return SingleChildScrollView(
        child: editMode
            ? TextField(
                controller: textController,
                minLines: 20,
                maxLines: 1000,
              )
            // : Text(textController.text),
            : contentNotifier == null
                ? Text('- - - -')
                : RichText(
                    text: TextSpan(
                      children: [
                        for (final paragh
                            in textController.text.split('\n')) ...[
                          TextSpan(
                            children: [
                              for (final word in paragh.split(_regex))
                                WidgetSpan(
                                  child: HookBuilder(
                                    builder: (context) {
                                      final w =
                                          contentNotifier.getNotifier(word);

                                      useListenable(w ?? ChangeNotifier());

                                      if (w == null) {
                                        return Text('($word)');
                                      }

                                      return InkWell(
                                        onTap: () async {
                                          final db = context.read(dbProvider);

                                          await db.wordDao.updateKnow(w.value);
                                          w.toggleKnow();
                                        },
                                        child: Text(
                                          word + ' ',
                                          style: TextStyle(
                                            color: w.know
                                                ? Colors.green
                                                : Colors.black,
                                            decoration: w.know
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
      final contentNotifier = useProvider(getContentNotifierProvider).state;
      useListenable(contentNotifier ?? ChangeNotifier());

      if (contentNotifier == null) {
        return Center(child: Text('wait'));
      }

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

        return Card(
          color: wordNotifier.know ? Colors.green[100] : null,
          child: InkWell(
            onTap: () async {
              await context
                  .read(dbProvider)
                  .wordDao
                  .updateKnow(wordNotifier.value);

              wordNotifier.toggleKnow();
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                '${wordNotifier.word}',
                style: TextStyle(
                  fontSize: 12.0, //+ word.count,
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
        // final map = useProvider(wordMapProvider);
        final editMode = useProvider(editModeProvider);
        final contentNotifier = useProvider(getContentNotifierProvider).state;

        return Material(
          elevation: 6,
          child: Row(
            children: [
              BackButton(),
              Text(
                'text word\n${contentNotifier?.allWordCount}',
                textAlign: TextAlign.center,
              ),
              Text(
                'word count\n${contentNotifier?.wordCount}',
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                child: Text('analyze'),
                onPressed: () => analyze(context),
              ),
              ElevatedButton(
                child: Text(editMode.state ? 'done' : 'edit'),
                onPressed: () async {
                  final contentData =
                      context.read(getContentNotifierProvider).state;

                  final textController = context.read(textControllerProvider);

                  if (textController.text != contentData!.content) {
                    await context
                        .read(dbProvider)
                        .contentDao
                        .updateContent(contentData.value, textController.text);
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
    final contentNotifier = context.read(getContentNotifierProvider).state;

    if (contentNotifier == null) {
      return;
    }

    final db = context.read(dbProvider);
    final wordMap = <String, List<WordData>>{
      for (final alpha in alphabeta) alpha: [],
    };

    final wordExtractedFromContentText = contentNotifier.content
        .split(_regex)
        .map((e) => e.toLowerCase())
        .toList();

    // by default remove empty and dublicat word
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
    final allWordOnDB = context.read(wordHubProvider).wordNotifiers;

    for (final word
        in wordMap.values.expand((element) => element).map((e) => e.word)) {
      final wordNotifier = await getOrAddWord(db, allWordOnDB, word);

      contentNotifier.addWordNotifier(wordNotifier);
    }

    // load word
    final newData = contentNotifier.toJson();

    if (contentNotifier.data != newData) {
      await db.contentDao.updateData(contentNotifier.value, newData);
      contentNotifier.updateData();
    }

    contentNotifier.getWordsFromDB(allWordOnDB);
    // contentNotifier.notify();
  }

  Future<WordNotifier> getOrAddWord(
    Database db,
    List<WordNotifier> allWordInDB,
    String word,
  ) async {
    final selection =
        allWordInDB.where((element) => element.word == word).toList();

    if (selection.isEmpty) {
      return WordNotifier(await db.wordDao.add(word));
    }

    return selection.first;
  }
}

final _regex = RegExp("(?:(?![a-zA-Z])'|'(?![a-zA-Z])|[^a-zA-Z'])+");
