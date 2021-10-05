import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/db/database.dart';

import '../dialog/add_word_dialog.dart';

final wordsP = StreamProvider((ref) => ref.read(dbProvider).wordDao.watching());

class WordView extends HookWidget {
  const WordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wordsFuture = useProvider(wordsP);

    return Container(
      child: wordsFuture.when(
        data: (List<Word> words) {
          return wordsWidget(context, words);
        },
        loading: () => CircularProgressIndicator(),
        error: (Object error, StackTrace? stackTrace) =>
            Text('$error || $stackTrace'),
      ),
    );
  }

  Widget wordsWidget(BuildContext context, List<Word> words) {
    final charMap = <String, int?>{};

    for (final word in words) {
      charMap[word.word.substring(0, 1)] = null;
    }

    final chars = charMap.keys.toList()..sort((a, b) => a.compareTo(b));

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
                      for (final char in chars)
                        Column(
                          children: [
                            Card(
                                child: Row(
                              children: [
                                Text(char),
                              ],
                            )),
                            Wrap(
                              children: [
                                for (final word
                                    in words
                                        .where((element) =>
                                            element.word.startsWith(char))
                                        .toList()
                                      ..sort(
                                          (a, b) => a.word.compareTo(b.word)))
                                  wordItem(context, word)
                              ],
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
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
