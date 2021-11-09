import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/study_controller.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/model/content_data.dart';
import 'package:landlearn/util/util.dart';

import 'word_map.dart';

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
      context.read(studyControllerProvider);
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
      final wordMap = useProvider(wordMapProvider);
      final textController = useProvider(textControllerProvider);

      final editMode = useProvider(editModeProvider).state;

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
                    for (final w in textController.text.split(_regex))
                      () {
                        final isKnow = wordMap.isKnow(w);

                        return TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              final db = context.read(dbProvider);
                              final word = wordMap.get(w);

                              if (word != null) {
                                db.wordDao
                                    .updating(word.copyWith(know: !word.know));
                              }

                              analyze(context);
                            },
                          text: w + ' ',
                          style: TextStyle(
                            color: isKnow ? Colors.green : Colors.black,
                            decoration:
                                isKnow ? TextDecoration.underline : null,
                          ),
                        );
                      }(),
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
      final sortedWord = useProvider(studyControllerProvider).sortedWord;

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
                        for (final wordRow in sortedWord[alphaChar]!.list)
                          wordCard(sortedWord[alphaChar]!, wordRow),
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
                  .updateKnow(wordNotifier.wordObject);

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
        final map = useProvider(wordMapProvider);
        final editMode = useProvider(editModeProvider);

        return Material(
          elevation: 6,
          child: Row(
            children: [
              BackButton(),
              Text(
                'text word\n${map.allWordCount}',
                textAlign: TextAlign.center,
              ),
              Text(
                'word count\n${map.wordCount}',
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
                      context.read(getContentDataProvider).state;

                  final textController = context.read(textControllerProvider);

                  if (textController.text != contentData!.content.content) {
                    await context.read(dbProvider).contentDao.updateContent(
                          contentData.content,
                          textController.text,
                        );
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

  void analyze(BuildContext context) async {
    final db = context.read(dbProvider);

    final contentData = context.read(getContentDataProvider).state;

    if (contentData == null) {
      return;
    }

    final contentWords = context.read(getContentWordsProvider).state;

    final wordList = contentData.content.content.split(_regex);

    final addList = [];

    for (final word in wordList) {
      if (word.isEmpty) {
        continue;
      }

      if (contentWords.where((element) => element.word == word).isEmpty) {
        addList.add(word);
      }

      // mapMap.addWord(await getOrAddWord(context, word));
    }

    for (final item in addList) {
      await db.wordDao.add(item);
    }

    final mapMap = context.read(wordMapProvider)..resetMap();

    final wordFromDB = await db.wordDao.getAllByWord(wordList);

    for (final w in wordFromDB) {
      mapMap.addWord(w);
    }

    final newData = mapMap.toJson();
    if (contentData.content.data != newData) {
      await db.contentDao.updateData(contentData.content, newData);

      mapMap.notify();
      return;
    }

    mapMap.notify();
  }

  Future<Word> getOrAddWord(BuildContext context, String word) async {
    final db = context.read(dbProvider);

    final wordLowerCase = word.toLowerCase();

    var w = await db.wordDao.get(wordLowerCase);

    if (w == null) {
      return await db.wordDao.add(wordLowerCase);
    }

    return w;
  }
}

final _regex = RegExp("(?:(?![a-zA-Z])'|'(?![a-zA-Z])|[^a-zA-Z'])+");
