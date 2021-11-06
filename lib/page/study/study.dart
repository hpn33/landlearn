import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/study_controller.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/util/util.dart';

import 'word_map.dart';

class StudyPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final editMode = useState(false);

    final contentData = useProvider(getContentDataProvider).state;

    final textController = useProvider(textControllerProvider);

    useEffect(() {
      analyze(context);
    }, [contentData?.content.content]);

    return Material(
      child: Column(
        children: [
          topBar(context, textController, editMode),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: contentView(context, editMode.value, textController),
                ),
                Expanded(
                  child: wordOfContent(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget contentView(
    BuildContext context,
    bool editMode,
    TextEditingController textController,
  ) {
    final wordMap = context.read(wordMapProvider);

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
                        // recognizer: ,
                        text: w + ' ',
                        style: TextStyle(
                          color: isKnow ? Colors.green : Colors.black,
                          decoration: isKnow ? TextDecoration.underline : null,
                        ),
                      );
                    }(),
                ],
              ),
            ),
    );
  }

  Widget wordOfContent(BuildContext context) {
    return HookBuilder(
      builder: (context) {
        final words = useProvider(getContentWordsProvider).state;

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
                          for (final wordRow in words.where(
                              (element) => element.word.startsWith(alphaChar)))
                            wordCard(context, wordRow),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget wordCard(BuildContext context, Word word) {
    return Card(
      color: word.know ? Colors.green[100] : null,
      child: InkWell(
        onTap: () => context.read(dbProvider).wordDao.updateKnow(word),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            '${word.word}',
            style: TextStyle(
              fontSize: 12.0, //+ word.count,
            ),
          ),
        ),
      ),
    );
  }

  Widget topBar(
    BuildContext context,
    TextEditingController textController,
    ValueNotifier<bool> editMode,
  ) {
    return HookBuilder(
      builder: (context) {
        final map = useProvider(wordMapProvider);

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
                child: Text(editMode.value ? 'done' : 'edit'),
                onPressed: () async {
                  final contentData =
                      context.read(getContentDataProvider).state;
                  if (textController.text != contentData!.content.content) {
                    await context.read(dbProvider).contentDao.updateContent(
                          contentData.content,
                          textController.text,
                        );
                  }

                  editMode.value = !editMode.value;
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

    final mapMap = context.read(wordMapProvider)..clear();
    final wordList = contentData!.content.content.split(_regex);

    for (var word in wordList) {
      if (word.isEmpty) {
        continue;
      }

      mapMap.addWord(await getOrAddWord(context, word));
    }

    db.contentDao.updateData(contentData.content, mapMap.toJson());
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
