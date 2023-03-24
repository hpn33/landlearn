import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/service/db/database.dart';
import 'package:landlearn/logic/model/content_notifier.dart';

import 'word_hub.dart';

final contentHubProvider = ChangeNotifierProvider((ref) => ContentHub());

class ContentHub extends ChangeNotifier {
  final List<Content> contents = [];
  final List<ContentNotifier> contentNotifiers = [];

  Future<void> load(WordHub wordHub, [List<Content>? newContents]) async {
    if (newContents != null) {
      contents.clear();
      contents.addAll(newContents);
    }

    for (final content in contents) {
      addByContent(content, wordHub);
    }
  }

  void loadSync(WordHub wordHub, [List<Content>? newContents]) {
    if (newContents != null) {
      contents.clear();
      contents.addAll(newContents);
    }

    for (final content in contents) {
      addByContent(content, wordHub);
    }
  }

  Iterable<ContentNotifier> addLoad(
    WordHub wordHub,
    List<Content> analyzeList,
  ) sync* {
    contents.addAll(analyzeList);

    for (final content in analyzeList) {
      yield addByContent(content, wordHub);
    }
  }

  ContentNotifier addByContent(Content content, WordHub wordHub) {
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

extension ContentHubExtension on ContentHub {
  double get awarness {
    final awarness =
        contentNotifiers.map((e) => e.awarnessPercentOfAllWord).fold<double>(
                  0.0,
                  (previousValue, element) => previousValue + element,
                ) /
            contentNotifiers.length;
    return awarness.isNaN ? 0.0 : awarness;
  }
}
