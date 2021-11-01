import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/study_controller.dart';
import 'package:landlearn/service/db/database.dart';

import '../../service/model/word_data.dart';
import 'word_map.dart';

class StudyPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final editMode = useState(false);

    final contentData = useProvider(getContentProvider).state;
    final words = useProvider(getContentWordsProvider).state;

    // final textController = useTextEditingController(text: '');
    final textController = useProvider(textControllerProvider);

    useEffect(() {
      analyze(context);
    }, [contentData!.content.content]);

    return Material(
      child: Column(
        children: [
          topBar(context, textController, editMode),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: contentView(editMode.value, textController),
                ),
                Expanded(
                  child: wordOfContent(context, words),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget contentView(
    bool editMode,
    TextEditingController textController,
  ) {
    return SingleChildScrollView(
      child: editMode
          ? TextField(
              controller: textController,
              minLines: 20,
              maxLines: 1000,
            )
          : Text(textController.text),
    );
  }

  Widget wordOfContent(
    BuildContext context,
    // StudyController studyController,
    // Map<String, List<WordData>> wordsSorted,
    List<Word> words,
  ) {
    return HookBuilder(
      builder: (context) {
        // useListenable(contentData.words);
        // final wordsSorted = studyController.wordsSorted;
        // useListenable(wordsSorted);

        return SingleChildScrollView(
          child: Column(
            children: [
              //     for (final index
              //         in List.generate(wordsSorted.value.length, (index) => index))
              //       Card(
              //         child: Column(
              //           children: [
              //             Text(wordsSorted.value.entries.elementAt(index).key),
              //             Divider(),
              //             Wrap(
              //               children: [
              //                 for (final wordRow in wordsSorted.value.entries
              //                     .elementAt(index)
              //                     .value)
              //                   wordCard(context, wordRow, index),
              //               ],
              //             ),
              //           ],
              //         ),
              //       ),
            ],
          ),
        );
      },
    );
  }

  Widget wordCard(BuildContext context, WordData wordRow, int index) {
    return Card(
      color: wordRow.word.know ? Colors.green[100] : null,
      child: InkWell(
        onTap: null,
        // () => context
        //     .read(studyControllerProvider)
        //     .updateKnowWord(context, wordRow, index),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            '${wordRow.word.word}',
            style: TextStyle(
              fontSize: 12.0 + wordRow.count,
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
                  final contentData = context.read(getContentProvider).state;
//TODO: is refresh auto???
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

    final contentData = context.read(getContentProvider).state;

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
