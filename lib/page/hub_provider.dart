import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/model/content_data.dart';
import 'package:landlearn/service/repo/repository.dart';
import 'package:landlearn/util/util.dart';

final hubProvider = Provider((ref) => Hub(ref.read(dbProvider)));

class Hub {
  final Database db;
  final repo = Repository();

  Hub(this.db);

  final words = ValueNotifier(<Word>[]);
  final alphaSort = ValueNotifier(<String, List<Word>>{});
  final contents = ValueNotifier(<ContentData>[]);

  Future<void> init() async {
    words.addListener(sortWord);

    db.wordDao.watching()..listen((event) => words.value = event);

    db.contentDao.watching()
      ..listen((event) {
        contents.value = event.map((e) => ContentData(this, e)).toList();
      });
  }

  void sortWord() {
    alphaSort.value = {};

    final a = <String, List<Word>>{};

    for (final char in alphabeta) {
      for (final word
          in words.value.where((element) => element.word.startsWith(char))) {
        if (!a.containsKey(char)) {
          a[char] = [];
        }

        a[char]!.add(word);
      }
    }

    a.forEach(
      (key, value) => a[key] = value..sort((a, b) => a.word.compareTo(b.word)),
    );

    alphaSort.value = a;
  }

  Future<Word> getOrAddWord(String word) async {
    final wordLowerCase = word.toLowerCase();
    final firstChar = wordLowerCase.substring(0, 1);

    if (!alphaSort.value.containsKey(firstChar)) {
      alphaSort.value[firstChar] = [];
    }

    final w = alphaSort.value[firstChar]!
        .where((element) => element.word == wordLowerCase);

    if (w.isEmpty) {
      final addedWord = await db.wordDao.add(wordLowerCase);

      words.value = [...words.value, addedWord];
      alphaSort.value[wordLowerCase.substring(0, 1)]!.add(addedWord);

      return addedWord;
    }

    return w.first;
  }
}
