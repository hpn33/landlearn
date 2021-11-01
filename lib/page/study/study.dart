import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/study_controller.dart';
import 'package:landlearn/service/db/database.dart';

import '../../service/model/word_data.dart';
import 'word_map.dart';

class StudyPage extends HookWidget {
  // final ContentData contentData;
  // final int contentId;

  // StudyPage(this.contentId);

  @override
  Widget build(BuildContext context) {
    // final studyController = useProvider(studyControllerProvider);

    // useListenable(studyController.editMode);
    final editMode = useState(false);
    // final contentData = useState<Content?>(null);

    final contentData = useProvider(getContentProvider).state;
    final words = useProvider(getContentWordsProvider).state;

    final textController = useTextEditingController(text: '');

    useEffect(() {
      if (contentData != null) {
        textController.text = contentData.content.content;
      }

      // studyController.init(context, contentData);
      // studyController.analyze(context, textController.text);
    }, [contentData]);

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
        // final controller = useProvider(studyControllerProvider);

        return Material(
          elevation: 6,
          child: Row(
            children: [
              BackButton(),
              // TextButton(
              //   child: Text('save'),
              //   onPressed: () {
              //     // project
              //     //   ..text = textController.text
              //     //   ..save();

              //     // box.put(keyId, project..text = textController.text);
              //     // box.get(keyId);
              //   },
              // ),
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
                  onPressed: () {
                    final db = context.read(dbProvider);

                    final mapMap = context.read(wordMapProvider)..clear();
                    final wordList = textController.text.split(_regex);
                    // final hub = context.read(hubProvider);

                    for (var word in wordList) {
                      if (word.isEmpty) {
                        continue;
                      }

                      // mapMap.addWord(await hub.getOrAddWord(word));
                    }

                    // hub.db.contentDao.updateData(contentData.content, mapMap.toJson());
                  }

                  // controller.analyze(context, textController.text),
                  ),

              ElevatedButton(
                child: Text(editMode.value ? 'done' : 'edit'),
                onPressed: () => editMode.value = !editMode.value,
                // controller.toggleEditMode(context, textController),
              ),
            ],
          ),
        );
      },
    );
  }
}

final _regex = RegExp("(?:(?![a-zA-Z])'|'(?![a-zA-Z])|[^a-zA-Z'])+");
