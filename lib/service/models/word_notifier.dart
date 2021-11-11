import 'package:flutter/foundation.dart';
import 'package:landlearn/service/db/database.dart';

class WordNotifier extends ValueNotifier<Word> {
  int get id => value.id;
  String get word => value.word;
  bool get know => value.know;

  int count = 0;

  WordNotifier(Word wordObject) : super(wordObject);

  void toggleKnow() {
    value = value.copyWith(know: !know);
  }
}
