import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/hub_provider.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/model/content_data.dart';
import 'package:landlearn/service/model/word_data.dart';

import 'word_map.dart';

final studyControllerProvider =
    Provider.autoDispose((ref) => StudyController());

class StudyController {
  late ContentData contentData;

  final editMode = ValueNotifier(false);

  late final wordsSorted = ValueNotifier(contentData.wordsSorted);
  void wordNotify() => wordsSorted.notifyListeners();

  void init(ContentData contentO) {
    this.contentData = contentO;
  }

  final _regex = RegExp("(?:(?![a-zA-Z])'|'(?![a-zA-Z])|[^a-zA-Z'])+");

  Future<void> analyze(BuildContext context, String input) async {
    final mapMap = context.read(wordMapProvider)..clear();
    final wordList = input.split(_regex);
    final hub = context.read(hubProvider);

    for (var word in wordList) {
      if (word.isEmpty) {
        continue;
      }

      mapMap.addWord(await hub.getOrAddWord(word));
    }

    hub.db.contentDao.updateData(contentData.content, mapMap.toJson());
  }

  Future<void> toggleEditMode(
      BuildContext context, TextEditingController textEditingController) async {
    final hub = context.read(hubProvider);
    final input = textEditingController.text;

    if (editMode.value) {
      if (contentData.content.content != input) {
        await hub.repo.contents.updateContent(context, contentData, input);
      }

      contentData = ContentData(
        hub,
        contentData.content.copyWith(content: textEditingController.text),
      );

      await analyze(context, input);
    }

    editMode.value = !editMode.value;
  }

  void updateKnowWord(BuildContext context, WordData wordRow, int index) {
    final db = context.read(dbProvider);

    db.wordDao.updating(wordRow.word.copyWith(know: !wordRow.word.know));

    wordsSorted.value.update(
      wordsSorted.value.entries.elementAt(index).key,
      (list) {
        return [
          for (final i in list)
            if (i.word.word == wordRow.word.word)
              WordData()
                ..count = i.count
                ..word = i.word.copyWith(know: !i.word.know)
            else
              i
        ];
      },
    );

    wordNotify();
  }
}
