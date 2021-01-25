import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final textController = TextEditingController();
  final map = <String, Map<String, int>>{};

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              minLines: 20,
              maxLines: 20,
            ),
          ),
          Column(children: [
            Text(getAllWordCount()),
            Text(getWordCount()),
            RaisedButton(
              child: Text('split'),
              onPressed: () {
                setState(() {
                  mapWord();
                });
              },
            ),
          ]),
          Expanded(child: SingleChildScrollView(child: Text(words()))),
        ],
      ),
    );
  }

  void mapWord() {
    final wordList = textController.text
        .split(RegExp("(?:(?![a-zA-Z])'|'(?![a-zA-Z])|[^a-zA-Z'])+"));

    for (var w in wordList) {
      String firstC;

      if (w.isNotEmpty) {
        firstC = w.characters.first;

        if (!map.containsKey(firstC)) map[firstC] = {};

        if (!map[firstC].containsKey(w)) map[firstC][w] = 0;

        map[firstC][w]++;
      }
    }

    if (map.containsKey(' ')) map.remove(' ');
  }

  String words() {
    final words = [];

    for (final c in map.entries) {
      words.add('${c.key}\n--------');
      for (var w in c.value.entries) words.add('${w.value}\t${w.key}');
    }

    return words.join('\n');
  }

  String getWordCount() {
    var sum = 0;

    for (var c in map.entries) sum += c.value.length;

    return sum.toString();
  }

  String getAllWordCount() {
    var sum = 0;

    for (var c in map.entries) for (var w in c.value.entries) sum += w.value;

    return sum.toString();
  }
}
