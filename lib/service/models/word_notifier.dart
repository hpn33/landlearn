import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  void setContentNotifier(ContentNotifier contentNotifier, WordData wordData) {
    addListener(() => contentNotifier.notify());

    wordDataCatch[contentNotifier.id] = wordData;
  }
}

extension DB on WordNotifier {
  Future<void> toggleKnowToDB(WidgetRef ref) async {
    final db = ref.read(dbProvider);

    await db.wordDao.updateKnow(this.value);

    this.value = this.value.copyWith(know: !know);
  }
}
