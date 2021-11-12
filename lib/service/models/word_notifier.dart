import 'package:flutter/foundation.dart';
import 'package:landlearn/service/db/database.dart';

class WordNotifier extends ValueNotifier<Word> {
  int get id => value.id;
  String get word => value.word;
  bool get know => value.know;

  // on every load change
  int contentCount = 0;
  int totalCount = 0;

  WordNotifier(Word wordObject) : super(wordObject);

  void toggleKnow() {
    value = value.copyWith(know: !know);
  }

  void increaseTotalCount(int count) {
    totalCount += count;
  }

  void setContentCount(int count) {
    contentCount = count;
  }
}
