import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/study_controller.dart';
import 'package:landlearn/service/db/database.dart';
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
      studyController.init(contentData);
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
                  // child: Text(textController.text),
                  // child: SingleChildScrollView(child: TextSelectable(text: text)),
                  child: contentView(studyController, textController),
                ),
                Expanded(
                  child: wordOfContent(context, contentData.wordsSorted),
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
    Map<String, List<WordData>> wordsSorted,
  ) {
    return HookBuilder(
      builder: (context) {
        useListenable(contentData.words);

        return SingleChildScrollView(
          child: Column(
            children: [
              for (final wordsByChar in wordsSorted.entries)
                Card(
                  child: Column(
                    children: [
                      Text(wordsByChar.key),
                      Divider(),
                      Wrap(
                        children: [
                          for (final wordRow in wordsByChar.value)
                            Card(
                              color:
                                  wordRow.word.know ? Colors.green[100] : null,
                              child: InkWell(
                                onTap: () {
                                  final db = context.read(dbProvider);

                                  db.wordDao.updating(wordRow.word
                                      .copyWith(know: !wordRow.word.know));
                                },
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
                            ),
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
