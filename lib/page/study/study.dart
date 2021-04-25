import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/hive/project.dart';
import 'package:landlearn/hive/word.dart';

final wordMapProvider = ChangeNotifierProvider.autoDispose((ref) => WordMap());

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

    if (!map[firstC]!.containsKey(w)) map[firstC]![w] = 0;

    map[firstC]![w] = map[firstC]![w]! + 1;

    notifyListeners();
  }
}

final allWordCountInTextP = StateProvider.autoDispose<String>((ref) {
  final wordMap = ref.watch(wordMapProvider).map;
  var sum = 0;

  for (var c in wordMap.entries) for (var w in c.value.entries) sum += w.value;

  return sum.toString();
});

final wordCountP = StateProvider.autoDispose<String>((ref) {
  final wordMap = ref.watch(wordMapProvider).map;
  var sum = 0;

  for (var c in wordMap.entries) sum += c.value.length;

  return sum.toString();
});

final wordsProvider = StateProvider.autoDispose<String>((ref) {
  final wordMap = ref.watch(wordMapProvider).map;
  final words = <String>[];

  for (final c in wordMap.entries) {
    words.add('${c.key}\n--------');
    for (var w in c.value.entries) words.add('${w.value} ${w.key}');
  }

  return words.join('\n');
});

class StudyPage extends HookWidget {
  // final textController = TextEditingController();

  // final int keyId;
  // final String text;
  final ProjectObj project;

  StudyPage(this.project);

  @override
  Widget build(BuildContext context) {
    final allWordCount = useProvider(allWordCountInTextP).state;
    final wordCount = useProvider(wordCountP).state;
    final words = useProvider(wordsProvider).state;

    // final box = Hive.box<ProjectObj>('projects');
    // final project = box.get(keyId);

    // useListenable(box.listenable(keys: [project.key]));

    final textController = useTextEditingController(text: project.text);

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
                      // minLines: 20,
                      // maxLines: 1000,
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
                        child: Text('split'),
                        onPressed:
                            // null
                            () => mapingWord(context, textController.text),
                      ),
                    ],
                  ),
                ),
                Expanded(child: SingleChildScrollView(child: Text(words))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void mapingWord(BuildContext context, String input) async {
    final mapMap = context.read(wordMapProvider);
    final wordList = input.split(_regex);
    final wordsBox = Hive.box<WordObj>('words');

    // await wordsBox.clear();
    mapMap.clear();
    // map.state = {};
    print(wordList.length);
    for (var word in wordList) {
      if (word.isEmpty) {
        continue;
      }

      // await Future.delayed(Duration(milliseconds: 1));
      mapMap.addWord(word);

      final wordLowerCase = word.toLowerCase();
      final firstWord = wordLowerCase.characters.first;

      if (wordsBox.values
          .where((element) => element.word.startsWith(firstWord))
          .where((element) => element.word == wordLowerCase)
          .isEmpty) {
        await wordsBox.add(
          WordObj()..word = word.toLowerCase(),
        );
      }

      // if (wordsBox.containsKey(w)) wordsBox.add(w);
    }
  }

  final _regex = RegExp("(?:(?![a-zA-Z])'|'(?![a-zA-Z])|[^a-zA-Z'])+");

  Widget topBar(TextEditingController textController) {
    return Material(
      elevation: 6,
      child: Row(
        children: [
          BackButton(),
          TextButton(
            child: Text('save'),
            onPressed: () {
              project
                ..text = textController.text
                ..save();
              // box.put(keyId, project..text = textController.text);
              // box.get(keyId);
            },
          ),
        ],
      ),
    );
  }
}
