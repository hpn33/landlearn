import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:landlearn/service/models/word_hub.dart';
import 'package:landlearn/service/models/word_category_notifier.dart';
import 'package:landlearn/service/models/word_notifier.dart';

import '../../dialog/add_word_dialog.dart';

class WordView extends StatelessWidget {
  const WordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        toolBar(context),
        Expanded(
          child: listViewWidget(),
        ),
      ],
    );
  }

  Widget toolBar(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            statusOfWord(),
            Spacer(),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (c) => addWordDialog(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget statusOfWord() {
    return HookConsumer(
      builder: (context, ref, child) {
        final wordHub = ref.read(wordHubProvider);
        final wordNotifiers = wordHub.wordNotifiers;

        useListenable(wordHub);

        final totalCount = wordNotifiers.length;
        final knowCount = wordNotifiers.where((element) => element.know).length;
        final unknowCount = totalCount - knowCount;

        return Row(
          children: [
            Text('$totalCount/$unknowCount'),
            SizedBox(width: 8),
            Card(
              color: Colors.green[200],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('$knowCount ( %' +
                    (knowCount / totalCount * 100).toStringAsFixed(1) +
                    ' )'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget listViewWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: HookConsumer(builder: (context, ref, child) {
              final wordHub = ref.read(wordHubProvider);

              useListenable(wordHub);

              final wordCategories = wordHub.wordCategories.entries;

              return ListView.builder(
                itemCount: wordCategories.length,
                itemBuilder: (context, index) {
                  final alphaChar = wordCategories.elementAt(index).key;
                  final category = wordCategories.elementAt(index).value;

                  return wordSectionCard(alphaChar, category);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Column wordSectionCard(
    String alphaChar,
    WordCategoryNotifier wordCategoryNotifier,
  ) {
    return Column(
      children: [
        Card(
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [Text(alphaChar)]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: HookBuilder(builder: (context) {
            useListenable(wordCategoryNotifier);

            // return ListView.builder(
            //   itemCount: wordCategoryNotifier.list.length,
            //   shrinkWrap: true,
            //   itemBuilder: (context, index) {
            //     final word = wordCategoryNotifier.list[index];

            //     return wordItem(word);
            //   },
            // );

            return Wrap(
              alignment: WrapAlignment.center,
              children: [
                for (final word in wordCategoryNotifier.list) wordItem(word),
              ],
            );
          }),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Widget wordItem(WordNotifier wordNotifier) {
    return HookConsumer(builder: (context, ref, child) {
      useListenable(wordNotifier);

      return Card(
        color: wordNotifier.know ? Colors.green[100] : null,
        child: InkWell(
          onTap: () {
            wordNotifier.toggleKnowToDB(ref);
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(wordNotifier.word + ' ${wordNotifier.totalCount}'),
          ),
        ),
      );
    });
  }
}
