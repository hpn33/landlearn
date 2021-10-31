import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/util/util.dart';

import '../../dialog/add_word_dialog.dart';
import 'word_view_controller.dart';

class WordView extends HookWidget {
  const WordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final words = useProvider(wordsListProvider).state;

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
          ],
        ),
        Row(
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
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final item in alphabeta)
                        // for (final item in sortedWords.entries)
                        wordSectionCard(context, item),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column wordSectionCard(BuildContext context, String alphaChar) {
    return Column(
      children: [
        Card(
          child: Row(
            children: [
              Text(alphaChar),
            ],
          ),
        ),
        Consumer(builder: (context, watch, child) {
          return Wrap(
            children: [
              for (final word in context.read(getWordWithProvider(alphaChar)))
                wordItem(context, word)
            ],
          );
        }),
        SizedBox(height: 30),
      ],
    );
  }

  Widget wordItem(BuildContext context, Word word) {
    return Card(
      color: word.know ? Colors.green[100] : null,
      child: InkWell(
        onTap: () {
          final db = context.read(dbProvider);

          db.wordDao.updating(word.copyWith(know: !word.know));
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(word.word),
        ),
      ),
    );
  }
}
