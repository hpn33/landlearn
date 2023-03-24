import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/logic/service/db/database.dart';

import 'content_notifier.dart';
import 'word_data.dart';

class WordNotifier extends ValueNotifier<Word> {
  bool selected = false;
  void setSelection(bool select) {
    selected = select;
    notifyListeners();
  }

  int get id => value.id;
  String get word => value.word;
  bool get know => value.know;
  String? get note => value.note;
  String? get onlineTranslation => value.onlineTranslation;

  DateTime get createdAt => value.createdAt;
  DateTime get updatedAt => value.updatedAt;

  // on every load change
  int _lastContentId = -1;
  int _contentCount = 0;
  int getContentCount(int contentId) {
    if (_lastContentId != contentId) {
      _contentCount = wordDataCatch[contentId]!.count;
      _lastContentId = contentId;
    }

    return _contentCount;
  }

  // contentId, wordData
  final wordDataCatch = <int, WordData>{};
  final contentCatch = <int, ContentNotifier>{};

  WordNotifier(Word wordObject) : super(wordObject);
}

extension DB on WordNotifier {
  Future<void> toggleKnowToDB(WidgetRef ref) async {
    final db = ref.read(dbProvider);

    value = value.copyWith(know: !know);

    await db.wordDao.up(value);
  }

  Future<void> updateOnlineTranslationToDB(
    WidgetRef ref,
    String translation,
  ) async {
    final db = ref.read(dbProvider);

    updateOnlineTranslation(translation);

    await db.wordDao.up(value);
  }

  Future<void> updateNoteToDB(
    WidgetRef ref,
    String note,
  ) async {
    final db = ref.read(dbProvider);

    value = value.copyWith(note: Value(note));

    await db.wordDao.up(value);
  }

  Future<void> updateTime(WidgetRef ref) async {
    final db = ref.read(dbProvider);

    value = value.copyWith(updatedAt: DateTime.now());

    await db.wordDao.up(value);
  }
}

extension Update on WordNotifier {
  void updateOnlineTranslation(String translation) {
    value = value.copyWith(onlineTranslation: Value(translation));
  }
}

extension Gets on WordNotifier {
  int get totalCount => wordDataCatch.values
      .map((e) => e.count)
      .reduce((value, element) => value + element);
}

extension Func on WordNotifier {
  void setContentNotifier(ContentNotifier contentNotifier, WordData wordData) {
    addListener(() => contentNotifier.notify());

    wordDataCatch[contentNotifier.id] = wordData;
    if (!contentCatch.containsKey(contentNotifier.id)) {
      contentCatch[contentNotifier.id] = contentNotifier;
    }
  }
}
