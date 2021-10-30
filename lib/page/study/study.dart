import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/study_controller.dart';
import 'package:landlearn/service/model/content_data.dart';

import '../../service/model/word_data.dart';
import 'word_map.dart';

class StudyPage extends HookWidget {
  final ContentData contentData;

  StudyPage(this.contentData);

  @override
  Widget build(BuildContext context) {
    final studyController = useProvider(studyControllerProvider);

    useListenable(studyController.editMode);

    final textController =
        useTextEditingController(text: contentData.content.content);

    useEffect(() {
      studyController.init(context, contentData);
      studyController.analyze(context, textController.text);
    }, []);

    return Material(
      child: Column(
        children: [
          topBar(context, textController),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: contentView(studyController, textController),
                ),
                Expanded(
                  child: wordOfContent(context, studyController),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView contentView(
      StudyController studyController, TextEditingController textController) {
    return SingleChildScrollView(
      child: studyController.editMode.value
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
    StudyController studyController,
    // Map<String, List<WordData>> wordsSorted,
  ) {
    return HookBuilder(
      builder: (context) {
        // useListenable(contentData.words);
        final wordsSorted = studyController.wordsSorted;
        useListenable(wordsSorted);

        return SingleChildScrollView(
          child: Column(
            children: [
              for (final index
                  in List.generate(wordsSorted.value.length, (index) => index))
                Card(
                  child: Column(
                    children: [
                      Text(wordsSorted.value.entries.elementAt(index).key),
                      Divider(),
                      Wrap(
                        children: [
                          for (final wordRow in wordsSorted.value.entries
                              .elementAt(index)
                              .value)
                            wordCard(context, wordRow, index),
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

  Widget wordCard(BuildContext context, WordData wordRow, int index) {
    return Card(
      color: wordRow.word.know ? Colors.green[100] : null,
      child: InkWell(
        onTap: () => context
            .read(studyControllerProvider)
            .updateKnowWord(context, wordRow, index),
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

  Widget topBar(BuildContext context, TextEditingController textController) {
    return HookBuilder(
      builder: (context) {
        final map = useProvider(wordMapProvider);
        final controller = useProvider(studyControllerProvider);

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
                onPressed: () =>
                    controller.analyze(context, textController.text),
              ),

              ElevatedButton(
                child: Text(controller.editMode.value ? 'done' : 'edit'),
                onPressed: () =>
                    controller.toggleEditMode(context, textController),
              ),
            ],
          ),
        );
      },
    );
  }
}
