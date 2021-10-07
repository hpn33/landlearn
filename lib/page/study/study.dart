import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/page/hub_provider.dart';
import 'package:landlearn/service/db/database.dart';
import 'package:landlearn/service/model/ContentO.dart';

final wordMapProvider = ChangeNotifierProvider.autoDispose((ref) => WordMap());

class WordData {
  late Word word;
  int count = 0;
}

class WordMap extends ChangeNotifier {
  // { char: map { word , word data }}
  final map = <String, Map<String, WordData>>{};

  void clear() {
    map.clear();

    notifyListeners();
  }

  void addWord(Word word) {
    final w = word.word.toLowerCase();
    final firstC = w.substring(0, 1);

    if (!map.containsKey(firstC)) map[firstC] = {};

    if (!map[firstC]!.containsKey(w)) map[firstC]![w] = WordData()..word = word;

    map[firstC]![w]!.count++;

    notifyListeners();
  }

  String toJson() {
    final m = map.entries
        .map((e) => e.value.entries.map((e) => e.value.word.id))
        .expand((element) => element)
        .toList();

    return jsonEncode(m);
  }
}

final allWordCountInTextP = StateProvider.autoDispose<String>((ref) {
  final wordMap = ref.watch(wordMapProvider).map;
  var sum = 0;

  for (var c in wordMap.entries)
    for (var w in c.value.entries) sum += w.value.count;

  return sum.toString();
});

final wordCountP = StateProvider.autoDispose<String>((ref) {
  final wordMap = ref.watch(wordMapProvider).map;
  var sum = 0;

  for (var c in wordMap.entries) sum += c.value.length;

  return sum.toString();
});

// final wordsSortedP =
//     StateProvider.autoDispose<Map<String, Map<String, WordData>>>((ref) {
//   final wordMap = ref.watch(wordMapProvider).map;
//   // final words = <String>[];

//   return {
//     for (final char in (wordMap.keys.toList()..sort((a, b) => a.compareTo(b))))
//       if (wordMap.containsKey(char)) char: wordMap[char]!
//   };

//   // for (final c in newWordMap.entries) {
//   //   words.add('${c.key}\n--------');
//   //   for (var w in c.value.entries) words.add('${w.value} ${w.key}');
//   // }

//   // return words.join('\n');
// });

class StudyPage extends HookWidget {
  final ContentO contentO;

  StudyPage(this.contentO);

  @override
  Widget build(BuildContext context) {
    final allWordCount = useProvider(allWordCountInTextP).state;
    final wordCount = useProvider(wordCountP).state;
    // final wordsSorted = useProvider(wordsSortedP).state;

    final textController =
        useTextEditingController(text: contentO.content.content);

    return Material(
      child: Column(
        children: [
          topBar(textController),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  // child: Text(textController.text),
                  // child: SingleChildScrollView(child: TextSelectable(text: text)),
                  child: SingleChildScrollView(
                    child: TextField(
                      controller: textController,
                      minLines: 20,
                      maxLines: 1000,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'text word\n$allWordCount',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'word count\n$wordCount',
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                        child: Text('analyze'),
                        onPressed:
                            // null
                            () => analyze(context, textController.text),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: wordOfContent(contentO.wordsSorted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget wordOfContent(Map<String, List<Word>> wordsSorted) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (final wordsByChar in wordsSorted.entries)
            Card(
              child: Column(
                children: [
                  Text(wordsByChar.key),
                  Divider(),
                  Wrap(
                    children: [
                      for (final wordRow in wordsByChar.value)
                        Card(
                          child: Text(
                            '${wordRow.word}',
                            // TODO: show count of word in content
                            style: TextStyle(
                                // fontSize: 12.0 + wordRow.value.count,
                                ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void analyze(BuildContext context, String input) async {
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

  final _regex = RegExp("(?:(?![a-zA-Z])'|'(?![a-zA-Z])|[^a-zA-Z'])+");

  Widget topBar(TextEditingController textController) {
    return Material(
      elevation: 6,
      child: Row(
        children: [
          BackButton(),
          // TextButton(
          //   child: Text('save'),
          //   onPressed: () {
          //     // project
          //     //   ..text = textController.text
          //     //   ..save();

          //     // box.put(keyId, project..text = textController.text);
          //     // box.get(keyId);
          //   },
          // ),
        ],
      ),
    );
  }
}
