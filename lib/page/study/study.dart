import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/hub_provider.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/model/content_data.dart';

import '../../service/model/word_data.dart';
import 'word_map.dart';

class StudyPage extends HookWidget {
  final ContentData contentO;

  StudyPage(this.contentO);

  @override
  Widget build(BuildContext context) {
    // final textController =
    //     useTextEditingController(text: contentO.content.content);

    return Material(
      child: Column(
        children: [
          topBar(context),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  // child: Text(textController.text),
                  // child: SingleChildScrollView(child: TextSelectable(text: text)),
                  child: SingleChildScrollView(
                    child: Text(contentO.content.content),
                    // TextField(
                    //   controller: textController,
                    //   minLines: 20,
                    //   maxLines: 1000,
                    // ),
                  ),
                ),
                Expanded(
                  child: wordOfContent(context, contentO.wordsSorted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget wordOfContent(
    BuildContext context,
    Map<String, List<WordData>> wordsSorted,
  ) {
    return HookBuilder(
      builder: (context) {
        useListenable(contentO.words);

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

  void analyze(BuildContext context, String input) async {
    final mapMap = context.read(wordMapProvider)..clear();
    final wordList = input.split(_regex);
    final hub = context.read(hubProvider);

    for (var word in wordList) {
      if (word.isEmpty) {
        continue;
      }

      mapMap.addWord(await hub.getOrAddWord(word));
    }

    hub.db.contentDao.updateData(contentO.content, mapMap.toJson());
  }

  final _regex = RegExp("(?:(?![a-zA-Z])'|'(?![a-zA-Z])|[^a-zA-Z'])+");

  Widget topBar(BuildContext context) {
    return HookBuilder(
      builder: (context) {
        final map = useProvider(wordMapProvider);

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
                onPressed:
                    // null
                    () => analyze(context, contentO.content.content),
              ),
            ],
          ),
        );
      },
    );
  }
}
