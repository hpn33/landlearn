import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/models/content_notifier.dart';

import 'word_hub.dart';

final contentHubProvider = ChangeNotifierProvider((ref) => ContentHub());

class ContentHub extends ChangeNotifier {
  final List<Content> contents = [];
  final List<ContentNotifier> contentNotifiers = [];

  void load(WordHub wordHub, [List<Content>? newContents]) {
    if (newContents != null) {
      contents.clear();
      contents.addAll(newContents);
    }

    for (final content in contents) {
      addContent(content, wordHub);
    }
  }

  ContentNotifier addContent(Content content, WordHub wordHub) {
    final contentNotifier = ContentNotifier(content);
    contentNotifier.loadData(wordHub);

    contentNotifiers.add(contentNotifier);

    return contentNotifier;
  }

  void clear() {
    contents.clear();
    contentNotifiers.clear();

    notifyListeners();
  }

  void notify({bool sub = false}) {
    if (sub) {
      for (var contentNotifier in contentNotifiers) {
        contentNotifier.notify();
      }
    }

    notifyListeners();
  }

  void remove(ContentNotifier contentNotifier) {
    contents.remove(contentNotifier.value);
    contentNotifiers.remove(contentNotifier);

    notify();
  }
}
