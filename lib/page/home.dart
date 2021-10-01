import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/study/study.dart';
import 'package:landlearn/service/db/database.dart';

import 'dialog/add_content_dialog.dart';
import 'dialog/add_word_dialog.dart';

final wordsP = StreamProvider((ref) => ref.read(dbProvider).wordDao.watching());
final contentsP =
    StreamProvider((ref) => ref.read(dbProvider).contentDao.watching());

class HomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // final db = useProvider(dbProvider);
    // db.clearAllTable();

    return Material(
      child: SafeArea(
        child: Row(
          children: [
            Expanded(child: words(context)),
            Expanded(child: contents(context)),
          ],
        ),
      ),
    );
  }

  Widget words(BuildContext context) {
    final wordsFuture = useProvider(wordsP);

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
            )
          ],
        ),
        Expanded(
          child: Scrollbar(
            child: Column(
              children: [
                ...wordsFuture.when(
                  data: (List<Word> words) => [
                    for (final word in words) Text(word.word),
                  ],
                  loading: () => [CircularProgressIndicator()],
                  error: (Object error, StackTrace? stackTrace) => [
                    Text('$error || $stackTrace'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget contents(BuildContext context) {
    final contentsFuture = useProvider(contentsP);

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (c) => addContentDialog(),
                );
              },
            )
          ],
        ),
        Expanded(
          child: Scrollbar(
            child: Column(
              children: [
                ...contentsFuture.when(
                  data: (List<Content> contents) => [
                    for (final content in contents)
                      contentItem(context, content),
                  ],
                  loading: () => [CircularProgressIndicator()],
                  error: (Object error, StackTrace? stackTrace) => [
                    Text('$error || $stackTrace'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget contentItem(BuildContext context, Content content) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => StudyPage(content)),
          );
        },
        child: Text(content.title),
      ),
    );
  }
}
