import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/home/word_hub.dart';
import 'package:landlearn/page/study/models/word_category_notifier.dart';
import 'package:landlearn/page/study/models/word_notifier.dart';
import 'package:landlearn/service/db/database.dart';

import '../../dialog/add_word_dialog.dart';

class WordView extends StatelessWidget {
  const WordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (c) => addWordDialog(),
                );
              },
            ),
            Spacer(),
            statusOfWord(),
          ],
        ),
        Expanded(
          child: listViewWidget(),
        ),
      ],
    );
  }

  Widget listViewWidget() {
    return Row(
      children: [
        Expanded(
          child: HookBuilder(builder: (context) {
            final wordHub = useProvider(wordHubProvider);

            return SingleChildScrollView(
              child: Column(
                children: [
                  for (final row in wordHub.wordCategories.entries)
                    wordSectionCard(row.key, row.value),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget statusOfWord() {
    return Consumer(
      builder: (context, watch, child) {
        final words = watch(wordHubProvider).words;

        return Row(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  words.length.toString() +
                      '/' +
                      words.where((element) => !element.know).length.toString(),
                ),
              ),
            ),
            Card(
              color: Colors.green[200],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    words.where((element) => element.know).length.toString() +
                        ' ( %' +
                        (words.where((element) => element.know).length /
                                words.length *
                                100)
                            .toStringAsFixed(1) +
                        ' )'),
              ),
            ),
          ],
        );
      },
    );
  }

  Column wordSectionCard(
    String alphaChar,
    WordCategoryNotifier wordCategoryNotifier,
  ) {
    return Column(
      children: [
        Card(
          child: Row(
            children: [
              Text(alphaChar),
            ],
          ),
        ),
        HookBuilder(builder: (context) {
          useListenable(wordCategoryNotifier);

          return Wrap(
            children: [
              for (final word in wordCategoryNotifier.list) wordItem(word),
            ],
          );
        }),
        SizedBox(height: 30),
      ],
    );
  }

  Widget wordItem(WordNotifier wordNotifier) {
    return HookBuilder(builder: (context) {
      useListenable(wordNotifier);

      return Card(
        color: wordNotifier.know ? Colors.green[100] : null,
        child: InkWell(
          onTap: () async {
            final db = context.read(dbProvider);

            await db.wordDao.updateKnow(wordNotifier.value);

            wordNotifier.toggleKnow();
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(wordNotifier.word),
          ),
        ),
      );
    });
  }
}
