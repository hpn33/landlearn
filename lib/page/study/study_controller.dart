import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/hub_provider.dart';
import 'package:landlearn/service/model/content_data.dart';

import 'word_map.dart';

final studyControllerProvider =
    Provider.autoDispose((ref) => StudyController());

class StudyController {
  late ContentData contentO;

  final editMode = ValueNotifier(false);

  void init(ContentData contentO) {
    this.contentO = contentO;
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

    hub.db.contentDao.updateData(contentO.content, mapMap.toJson());
  }

  Future<void> toggleEditMode(
      BuildContext context, TextEditingController textEditingController) async {
    final hub = context.read(hubProvider);
    final input = textEditingController.text;

    if (editMode.value) {
      if (contentO.content.content != input) {
        await hub.repo.contents.updateContent(context, contentO, input);
      }

      contentO = ContentData(
        hub,
        contentO.content.copyWith(content: textEditingController.text),
      );

      await analyze(context, input);
    }

    editMode.value = !editMode.value;
  }
}
