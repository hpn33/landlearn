import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/util/util.dart';

import '../../dialog/add_word_dialog.dart';
import 'word_view_controller.dart';

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
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (final item in alphabeta) wordSectionCard(item),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget statusOfWord() {
    return Consumer(
      builder: (context, watch, child) {
        final words = watch(wordsListProvider).state;

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

  Column wordSectionCard(String alphaChar) {
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
          final words = watch(getWordWithProvider(alphaChar));

          return Wrap(
            children: [
              for (final word in words) wordItem(context, word),
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
