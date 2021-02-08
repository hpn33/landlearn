import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:landlearn/util/sample.dart';
import 'package:landlearn/widget/TextSelectable.dart';
import 'package:hive_flutter/hive_flutter.dart';

final wordMapProvider = ChangeNotifierProvider((ref) => WordMap());

class WordMap extends ChangeNotifier {
  final map = <String, Map<String, int>>{};

  void clear() {
    map.clear();

    notifyListeners();
  }

  void addWord(String word) {
    final w = word.toLowerCase();
    final firstC = w.characters.first;

    if (!map.containsKey(firstC)) map[firstC] = {};

    if (!map[firstC].containsKey(w)) map[firstC][w] = 0;

    map[firstC][w]++;

    notifyListeners();
  }
}

final allWordCountP = StateProvider<String>((ref) {
  final wordMap = ref.watch(wordMapProvider).map;
  var sum = 0;

  for (var c in wordMap.entries) for (var w in c.value.entries) sum += w.value;

  return sum.toString();
});

final wordCountP = StateProvider<String>((ref) {
  final wordMap = ref.watch(wordMapProvider).map;
  var sum = 0;

  for (var c in wordMap.entries) sum += c.value.length;

  return sum.toString();
});

final wordsProvider = StateProvider<String>((ref) {
  final wordMap = ref.watch(wordMapProvider).map;
  final words = <String>[];

  for (final c in wordMap.entries) {
    words.add('${c.key}\n--------');
    for (var w in c.value.entries) words.add('${w.value}\t${w.key}');
  }

  return words.join('\n');
});

class Home extends HookWidget {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final allWordCount = useProvider(allWordCountP).state;
    final wordCount = useProvider(wordCountP).state;
    final words = useProvider(wordsProvider).state;

    useListenable(Hive.box('words').listenable());

    return Material(
      child: Row(
        children: [
          Expanded(
            // child: Text(sample),
            child: SingleChildScrollView(child: TextSelectable(text: sample)),
            // child: TextField(
            //   controller: textController,
            //   minLines: 20,
            //   maxLines: 20,
            // ),
          ),
          Column(children: [
            Text(allWordCount),
            Text(wordCount),
            RaisedButton(
              child: Text('split'),
              onPressed: () => mapingWord(context),
            ),
          ]),
          Expanded(child: SingleChildScrollView(child: Text(words))),
        ],
      ),
    );
  }

  void mapingWord(BuildContext context) async {
    final mapMap = context.read(wordMapProvider);
    final wordList = sample.split(_regex);
    final wordsBox = Hive.box('words');

    // await wordsBox.clear();
    mapMap.clear();
    // map.state = {};

    for (var word in wordList) {
      if (word.isNotEmpty) {
        // await Future.delayed(Duration(milliseconds: 1));
        mapMap.addWord(word);

        if (!wordsBox.containsKey(word.toLowerCase()))
          await wordsBox.put(word.toLowerCase(), 0);

        // if (wordsBox.containsKey(w)) wordsBox.add(w);
      }
    }
  }

  final _regex = RegExp("(?:(?![a-zA-Z])'|'(?![a-zA-Z])|[^a-zA-Z'])+");
}
