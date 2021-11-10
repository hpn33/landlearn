import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/study_controller.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/util/util.dart';

import 'models.dart';

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
      final textController = useProvider(textControllerProvider);

      final editMode = useProvider(editModeProvider).state;

      final contentNotifier =
          useProvider(studyControllerProvider).contentNotifier;

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
                    for (final word in textController.text.split(_regex))
                      WidgetSpan(
                        child: HookBuilder(
                          builder: (context) {
                            final w = contentNotifier!.getNotifier(word);

                            useListenable(w ?? ChangeNotifier());

                            if (w == null) {
                              return Text('(xxx)');
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
                                  color: w.know ? Colors.green : Colors.black,
                                  decoration:
                                      w.know ? TextDecoration.underline : null,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
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
      final wordCategoris =
          useProvider(studyControllerProvider).contentNotifier?.wordCategoris;

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
                        for (final wordRow in wordCategoris![alphaChar]!.list)
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
        final contentNotifier =
            useProvider(studyControllerProvider).contentNotifier;

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
                      context.read(studyControllerProvider).contentNotifier;

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

  void analyze(BuildContext context) async {
    final db = context.read(dbProvider);
    final studyController = context.read(studyControllerProvider);

    final contentNotifier = studyController.contentNotifier;
    if (contentNotifier == null) {
      return;
    }

    final contentWords = studyController.words;

    final wordList = contentNotifier.content.split(_regex);

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

    // final mapMap = context.read(wordMapProvider)..resetMap();

    final wordFromDB = await db.wordDao.getAllByWord(wordList);

    for (final w in wordFromDB) {
      contentNotifier.addWord(w);
      // mapMap.addWord(w);
    }

    final newData = contentNotifier
        // mapMap
        .toJson();
    if (contentNotifier.data != newData) {
      await db.contentDao.updateData(contentNotifier.value, newData);

      // mapMap.notify();
      return;
    }

    // mapMap.notify();
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
