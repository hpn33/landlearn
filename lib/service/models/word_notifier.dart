import 'package:flutter/foundation.dart';
import 'package:landlearn/service/db/database.dart';

import 'content_notifier.dart';
import 'word_data.dart';

class WordNotifier extends ValueNotifier<Word> {
  int get id => value.id;
  String get word => value.word;
  bool get know => value.know;

  // on every load change
  int _lastContentId = -1;
  int _contentCount = 0;
  int getContentCount(int contentId) {
    if (_lastContentId != contentId) {
      _contentCount = wordDataCatch[contentId]!.count;
    }

    return _contentCount;
  }

  int get totalCount => wordDataCatch.values
      .map((e) => e.count)
      .reduce((value, element) => value + element);

  // contentId, wordData
  final wordDataCatch = <int, WordData>{};

  WordNotifier(Word wordObject) : super(wordObject);

  void toggleKnow() {
    value = value.copyWith(know: !know);
  }

  void setContentNotifier(ContentNotifier contentNotifier, WordData wordData) {
    addListener(() => contentNotifier.notify());

    wordDataCatch[contentNotifier.id] = wordData;
  }
}
