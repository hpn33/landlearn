import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/models/content_notifier.dart';

import 'word_hub.dart';

final contentHubProvider = Provider((ref) => ContentHub());

class ContentHub extends ChangeNotifier {
  final List<Content> contents = [];
  final List<ContentNotifier> contentNotifiers = [];

  void load(WordHub wordHub, [List<Content>? newContents]) {
    if (newContents != null) {
      contents.clear();
      contents.addAll(newContents);
    }

    for (final content in contents) {
      final contentNotifier = ContentNotifier(content);
      contentNotifier.loadData(wordHub);

      contentNotifiers.add(contentNotifier);
    }
  }
}
